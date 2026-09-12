# Flask Autoscaling on AWS (EC2 ASG + ALB + existing RDS)

Terraform that puts the Flask app behind a load balancer with autoscaling, so it
can survive past the ~100-user ceiling measured on a single instance.

It **reuses your existing RDS** (from the earlier migration) — the database and its
data are not created, copied, or modified, except for one inbound rule that lets the
new instances connect.

```
            ┌─────────────┐
  users ──▶ │     ALB     │   :80  (health-checks /health)
            └──────┬──────┘
        ┌──────────┴──────────┐
        ▼                     ▼
   ┌─────────┐           ┌─────────┐     EC2 Auto Scaling Group
   │ t3.micro│   ...     │ t3.micro│     min 1 / max 3, scale on CPU > 60%
   │ docker  │           │ docker  │     (each runs the app container :5000)
   └────┬────┘           └────┬────┘
        └──────────┬──────────┘
                   ▼
            ┌──────────────┐
            │ EXISTING RDS │   ← all instances share this ONE database
            └──────────────┘
```

## Cost (academic, minimised)

| Resource        | Free tier (12 mo) | If left running |
|-----------------|-------------------|-----------------|
| EC2 t3.micro    | 750 h/mo (1 inst) | ~$7.5/mo each   |
| **ALB**         | none              | **~$16–18/mo**  |
| RDS             | (already running) | unchanged       |

The ALB is the only new fixed cost. **Run `terraform destroy` after each test
session** — a 2-hour session costs a few cents. Your RDS keeps running as before.

## Prerequisites

1. AWS CLI configured (`aws configure`) — provides AWS credentials. The region is
   taken from `.env`, not from here.
2. Terraform >= 1.5.
3. A `../.env` file with the RDS credentials (already restored from git history).

### Secrets come from `.env`, not from any Terraform file

Don't put passwords in `.tfvars`. The `tf.ps1` / `tf.sh` wrapper reads `../.env`,
maps the values to `TF_VAR_*` environment variables, and runs Terraform with them:

| .env key      | Terraform variable        |
|---------------|---------------------------|
| `SECRET_KEY`  | `secret_key`              |
| `MYSQL_PASS`  | `db_password`             |
| `MYSQL_USER`  | `db_username`             |
| `MYSQL_DB`    | `db_name`                 |
| `MYSQL_HOST`  | derives `region` + `existing_db_identifier` |

So there are **no secrets in any tracked file**. `terraform.tfvars` is optional and
only used for tuning (asg_max, cpu_target).

## ⚠️ One thing to settle first: the Docker image must match THIS branch

The instances pull `andreisarandan900/flask-web-application:flask-app`. The CI/CD
pipeline (`.github/workflows/ci-cd.yml`) builds & pushes that exact tag automatically
on every push to `migrate-to-aws`, so just push this branch and wait for the pipeline
to go green — the image will then contain `/health` + `ProductionConfig`.

If you ever build manually, use the SAME tag the pipeline uses:

```bash
docker build -t andreisarandan900/flask-web-application:flask-app .
docker push  andreisarandan900/flask-web-application:flask-app
```

## Run (use the wrapper so .env is loaded)

Windows PowerShell:
```powershell
cd terraform
.\tf.ps1 init
.\tf.ps1 apply        # ~2-3 min (no RDS to wait for this time)
```

Linux/macOS/Git Bash:
```bash
cd terraform
chmod +x tf.sh
./tf.sh init
./tf.sh apply
```

(`terraform output`, `terraform destroy`, etc. also work through the wrapper:
`.\tf.ps1 output -raw alb_url`.)

Outputs: `alb_url` (Locust `--host`), `rds_endpoint` (sanity check — should be your
existing RDS), `asg_name` (watch it scale in the EC2 console).

## Load test (reuse your existing Locust suite)

```bash
locust -f ../locust_data/locustfile.py --host=$(terraform output -raw alb_url) \
       --users 200 --spawn-rate 10 --run-time 5m --headless --csv=results/asg_200
```

Because all instances share your existing RDS, the Locust test user from the migration
(`test123@gmail.com`) already exists — no seeding needed. The tasks are mostly reads,
so they don't corrupt your data.

Sweep 100 → 500 users and watch the ASG add instances as CPU crosses 60%. Compare
p95 / throughput / error-rate against the single-instance baseline for the thesis.

## Tear down (every time)

```powershell
.\tf.ps1 destroy     # or ./tf.sh destroy
```

## Manual step: one RDS inbound rule (you do this, not Terraform)

Terraform intentionally does NOT modify your RDS security group. After `apply`, add
ONE inbound rule on the RDS `default` SG (sg-00c574a10db6b646f) so the new instances
can reach the database:

- **Type:** MySQL/Aurora  → port **3306**
- **Source:** the app security group id, shown by `.\tf.ps1 output -raw app_security_group_id`

That's the only change to your existing DB security group, and you control it.
(The app's `/health` does not touch the DB, so instances pass health checks even
before you add this rule — just add it before running the Locust test.)

## Note on networking

The ALB and instances are placed in the **same subnets as your RDS** (read from its
subnet group) so connectivity is guaranteed. This assumes those subnets are public
(have an internet gateway route) — true for a default-VPC migration. If your RDS sits
in private-only subnets, create separate public subnets for the internet-facing ALB.
