# DevOps Lab — plan de lucru

Scop: să treci hands-on prin stack-ul unei echipe DevOps reale, folosind aplicația Flask ca workload.
Fiecare fază = 1–3 sesiuni. Ordinea contează: fiecare fază se sprijină pe cea dinainte.

Regula de aur: **apply → învață → destroy** pentru tot ce e scump. Infrastructura e cod, deci o recreezi oricând în câteva minute.

## Mod de lucru (ca într-o echipă enterprise)
- **Totul e cod.** Nimic creat din consolă care să rămână. Dacă ai făcut ceva de mână ca să înțelegi, îl ștergi sau îl imporți (`import` block).
- **Unde rulează:** Terraform, AWS CLI, kubectl etc. din **WSL** (`/mnt/e/Licenta`), profil `lab` (`aws login --profile lab`).
- **Git flow:** trunk = `devops-lab`. Fiecare schimbare: branch `feat/<ce>` → PR în `devops-lab` → review (plan) → merge → apply. Până la Faza 2 (pipeline-ul), plan/apply se fac local, dar tot pe branch-uri de feature.
- **Plan → apply pe același plan:** `terraform plan -out=tfplan` și apoi `terraform apply tfplan`. Nu `apply` direct, ca să aplici exact ce ai revizuit.
- **Versiuni fixate:** `required_version` pentru Terraform, `~>` pentru provider, `.terraform.lock.hcl` comis.
- **State:** un bucket S3 (`devops-lab-tfstate-<account>`), câte o cheie per strat: `dev/<strat>/terraform.tfstate`. Straturile se leagă prin `terraform_remote_state` / data sources, niciodată prin copy-paste de ID-uri.
- **Naming:** `lab-<env>-<componentă>` (ex. `lab-dev-vpc`, `lab-dev-private-app-a`). Tag-uri prin `default_tags`: `Project`, `Env`, `ManagedBy`, plus `Layer` (stratul care a creat resursa).
- **Module:** în `infra/modules/`, fără provider și fără backend în ele. Au `variables.tf` / `main.tf` / `outputs.tf` / `terraform.tf`. Straturile din `infra/NN-*` doar le compun.
- **Calitate:** `pre-commit` local (fmt, validate, tflint). Aceleași verificări + scanare IaC în CI.
- **Least privilege:** fiecare actor are rolul lui: tu (IAM user), `gha-tf-plan`, `gha-tf-apply`, `gha-app-deploy`, rolurile instanțelor și task-urilor.

## Contul AWS: Free plan (creat 2026-10)
- Cont nou, dedicat lab-ului (separat de contul disertației).
- Free plan: **100$ credite (până la 200$ dacă faci task-urile de onboarding din consolă)**. Planul expiră după **6 luni** sau când se termină creditele, oricare vine prima. Apoi ai 90 de zile să faci upgrade, altfel contul se închide și resursele se șterg.
- → Ținta: termini fazele 0–11 în ~5 luni. Înainte de luna 6 decizi dacă faci upgrade la Paid.
- Unele servicii sunt restricționate pe Free plan (Marketplace, Reserved Instances / Savings Plans etc.). **EKS nu e confirmat oficial** → verificăm devreme (faza 0) cu un `aws eks list-clusters` + un cluster de test de 10 min, ca să nu ne blocăm în faza 9.
- Creditele se consumă pe orice: NAT, ALB, EKS. „Uitat pornit” = credite arse, nu card debitat. Tot e o pierdere reală.

## Straturi Terraform: ce rămâne pornit vs ce distrugi
Ca în companii, infrastructura e împărțită pe **straturi cu state separat**. Stratul de jos se schimbă rar, cele de sus des.

| Strat (`infra/…`) | Conține | Ciclu de viață | Cost aprox. |
|---|---|---|---|
| `00-bootstrap` | bucket S3 pentru state, OIDC provider + rol GitHub | permanent | ~0$ |
| `10-foundation` | VPC, subneturi, IGW, route tables, S3 endpoint, ECR, Secrets Manager | permanent | ~1$/lună (secrete 0.40$/buc) |
| `20-data` | RDS MySQL `db.t4g.micro`, 20 GB gp3 | **permanent** (datele rămân) | ~12–15$/lună, posibil acoperit de free tier → verificăm în Billing |
| `30-nat` | NAT Gateway + rutele private → NAT | **efemer** | ~38$/lună dacă rămâne pornit! |
| `40-compute-ec2` / `50-ecs` / `60-eks` | ALB, ASG, ECS, EKS, host monitoring | **efemer** | variabil |

- Straturile de sus citesc output-urile celor de jos (`terraform_remote_state` sau `data` sources după tag-uri).
- Pentru RDS: `deletion_protection = true` + `skip_final_snapshot = false`. Așa un `destroy` greșit nu-ți șterge datele.
- Pauză lungă (> 2 săptămâni): snapshot + destroy pe `20-data`, apoi restore din snapshot. Alternativa e `stop`, dar RDS pornește singur după 7 zile.

---

## Arhitectura țintă (finalul proiectului)

```
                         GitHub Actions (OIDC, fără chei statice)
                          │ test → build → scan → push ECR → deploy
                          ▼
Internet ──► ALB (subneturi publice) ──► EKS / ECS Fargate / EC2 ASG  (subneturi private-app)
                                              │
                                              ├──► RDS MySQL (subneturi private-db, fără acces public)
                                              ├──► Secrets Manager (parole, SECRET_KEY, Maps key)
                                              └──► ECR (imagini)
             NAT Gateway (1, ca să coste puțin) ◄── ieșire spre internet din private
Prometheus + Grafana + Alertmanager (pe EC2 via Ansible, apoi în k8s via Helm)
Terraform state: S3 (versioning + encryption + lockfile nativ)
```

VPC `10.20.0.0/16`, 2 AZ (`eu-central-1a`, `eu-central-1b`):

| Tier        | AZ a            | AZ b            | Route table               |
|-------------|-----------------|-----------------|---------------------------|
| public      | 10.20.0.0/24    | 10.20.1.0/24    | 0.0.0.0/0 → IGW           |
| private-app | 10.20.10.0/24   | 10.20.11.0/24   | 0.0.0.0/0 → NAT           |
| private-db  | 10.20.20.0/24   | 10.20.21.0/24   | fără ieșire la internet   |

---

## Structura repo (se construiește pe parcurs)

```
devops-lab/
  PLAN.md  PROGRESS.md  README.md
  notes/                  # notițele tale per fază (ce ai învățat, comenzi, greșeli)
  infra/
    modules/              # network, nat, rds, ecr, ec2-app, ecs-service, eks, monitoring-host
    00-bootstrap/         # S3 state bucket + GitHub OIDC role
    10-foundation/        # VPC, ECR, secrets          (permanent)
    20-data/              # RDS                        (permanent)
    30-nat/               # NAT Gateway                (efemer)
    40-compute-ec2/  50-ecs/  60-eks/                (efemer)
  k8s/
    base/  overlays/dev/  # Kustomize
    charts/flask-app/     # Helm chart propriu
  ansible/
    inventory/aws_ec2.yml # inventar dinamic
    roles/ playbooks/
  monitoring/             # prometheus rules, grafana dashboards as code
.github/workflows/        # (trebuie în root-ul repo-ului)
```

---

## Faza 0 — Pregătire & igienă (1–2 sesiuni, 0$)
**Concepte:** root account vs IAM, MFA, least privilege, billing alerts, profile AWS CLI, credențiale temporare.

**Cont nou:**
- [ ] MFA pe root. Root-ul nu se mai folosește după setup.
- [ ] **IAM Identity Center (SSO)**: user `andrei-admin` cu permission set `AdministratorAccess`. Pe Windows: `aws configure sso` → profil `lab`. Credențialele sunt temporare, deci nu mai există chei în `.env`.
- [ ] Budgets: alertă la 5$, 20$, 50$ *consum* (inclusiv credite) + Cost Anomaly Detection.
- [ ] Billing → Free Tier: verifică creditele, data de expirare a planului și dacă RDS micro e acoperit.
- [ ] Test EKS pe Free plan (vezi secțiunea „Contul AWS”).

**Contul vechi (disertație):** `terraform/terraform.tfstate` listează încă 15 resurse. Verifică dacă există fizic. Dacă da, fă `destroy`, altfel plătești ALB/RDS degeaba. Apoi dezactivează cheile din `Terraform_accessKeys.csv` / `.env`.

**Mașina de lucru (Windows):** tot rulează nativ pe Windows, cu excepția Ansible. Ubuntu-ul separat nu e necesar.
```powershell
winget install Docker.DockerDesktop        # folosește WSL2 ca backend (necesar pentru kind)
winget install Kubernetes.kubectl Helm.Helm Kubernetes.kind GitHub.cli
winget install Amazon.SessionManagerPlugin # aws ssm start-session din PowerShell
winget install Git.Git                     # dacă nu ai Git Bash
wsl --install -d Ubuntu-24.04              # pentru Ansible (+ Docker Desktop)
```
- În WSL Ubuntu: `pipx install ansible-core` + `ansible-galaxy collection install amazon.aws community.general`, `awscli`, session-manager-plugin.
- Repo-ul îl accesezi din WSL la `/mnt/e/Licenta`. Pentru Ansible e ok. Dacă devine lent, clonezi în `~/` din WSL.
- **`.gitattributes`** cu `*.sh text eol=lf`: scripturile `.sh` cu CRLF de pe Windows strică containerele (`docker-entrypoint.sh`) și user_data.
- Scripturile care rulează în CI sau pe servere se scriu în **bash**, nu PowerShell. GitHub Actions și EC2 sunt Linux.
- [ ] Branch `devops-lab`, folder `devops-lab/notes/`.

**Gata când:** `aws sts get-caller-identity --profile lab` merge prin SSO, ai budget alerts, `docker run hello-world`, `kind create cluster` și `ansible --version` (în WSL) merg.

> **2026-10-19:** faza de explorare în consolă a fost scoasă. Totul se face prin Terraform; consola doar când userul cere sau se blochează. Conceptele ei (VPC, route tables, SG, instance profile, SSM) sunt acum în Faza 1.

## Faza 1 — Terraform fundamente: bootstrap + rețea (2–3 sesiuni, ~1$)
**Concepte:** provider, resource, data source, variables/outputs/locals, state, remote backend, locking, `plan -out`/`apply`/`destroy`, module, `for_each`/`count`, `default_tags`, version pinning + `.terraform.lock.hcl`, `fmt`/`validate`/`tflint`, VPC/subnet/route table/IGW/NAT, Security Group, IAM role + instance profile, SSM.
- [x] `infra/00-bootstrap` (2026-10-19): bucket creat manual în consolă (account regional namespace: `devops-lab-tfstate-678530698532-eu-central-1-an`, versioning, SSE-S3, block public access), adus în TF cu blocuri `import` → zero drift. 4 resurse în state: bucket, versioning, SSE, public access block. Backend S3 cu `use_lockfile = true`. Policy HTTP-deny + lifecycle: sărite (opțional).
- [ ] Tooling local: `pre-commit` (fmt, validate, tflint), `.terraform.lock.hcl` comis în git.
- [x] (2026-10-20) `modules/network` **scris de mână** (nu modulul community): VPC, 6 subneturi, IGW, route tables, S3 gateway endpoint (gratuit) → `infra/10-foundation`.
  - **Design:** VPC `10.20.0.0/16`, AZ `eu-central-1a` + `eu-central-1b`, DNS hostnames/support ON.
    | Nivel | 1a | 1b | Route table |
    |---|---|---|---|
    | public | `10.20.0.0/24` | `10.20.1.0/24` | `0.0.0.0/0 → IGW` |
    | private-app | `10.20.10.0/24` | `10.20.11.0/24` | doar local (+ `0.0.0.0/0 → NAT` adăugat de `30-nat`) |
    | private-data | `10.20.20.0/24` | `10.20.21.0/24` | doar local, niciodată internet |
    S3 gateway endpoint atașat pe RT-urile private. Outputs: `vpc_id`, id-uri subneturi pe nivel, id-uri RT private (le citește `30-nat`).
  - **Ordine (câte o resursă, plan după fiecare):** 1) VPC → 2) subneturi cu `for_each` → 3) IGW + RT public + asocieri → 4) RT-uri private + asocieri → 5) S3 gateway endpoint → 6) outputs → 7) refactor în `modules/network` cu blocuri `moved` (fără recreare).
  - Scriem întâi direct în `infra/10-foundation`, apoi extragem modulul — vezi resursele înainte de abstracție.
- [ ] `modules/nat` → `infra/30-nat` (efemer).
- [ ] `infra/40-sandbox` (efemer): un EC2 `t4g.nano` în private-app, fără IP public și fără SSH, accesat prin **SSM Session Manager**. Rol IAM + instance profile + SG scrise de mână. Testezi ce se întâmplă fără NAT.
- [ ] Exercițiu: `destroy` + `apply` pe `10-foundation` de câteva ori, până devine banal (înainte să pui RDS peste).
**Gata când:** poți recrea rețeaua de la zero în < 5 min, explici fiecare route table și intri pe o instanță privată prin SSM.

## Faza 2 — Pipeline de infrastructură: Terraform prin PR (2 sesiuni, ~0$)
**Concepte:** GitHub OIDC federation (fără chei statice), roluri separate pentru plan și apply, `sub` claim, GitHub environments + required reviewers, branch protection, plan ca artefact, drift detection, scanare IaC.
- [ ] În `00-bootstrap`: OIDC provider + 2 roluri: `gha-tf-plan` (read-only + lock pe state, din orice PR) și `gha-tf-apply` (drepturi de scriere, **doar** din branch-ul `devops-lab` + environment `dev`).
- [ ] Workflow `infra.yml`: pe PR → `fmt -check`, `validate`, `tflint`, `trivy config` + `plan` pe straturile modificate, postat ca comentariu. Pe merge → `apply` pe exact planul aprobat, cu aprobare manuală (environment `dev`).
- [ ] Branch protection pe `devops-lab`: PR obligatoriu, check-uri verzi.
- [ ] Workflow programat de drift detection: `plan` zilnic, deschide un issue dacă găsește diferențe.
- [ ] **De aici înainte:** schimbările de infra trec doar prin PR. Apply local doar pe `00-bootstrap` (break-glass) și pe straturile efemere în timpul unei sesiuni de învățare.
**Gata când:** o modificare în `10-foundation` ajunge în AWS doar prin PR → plan → aprobare → apply.

## Faza 3 — Date + compute pe EC2 (2 sesiuni, ~2$)
**Concepte:** RDS (subnet group, parameter group, Multi-AZ, backups), Secrets Manager, ECR, IAM instance profile, launch template, ASG, ALB (listener, target group, health check), SG chaining (SG ca sursă).
- [ ] `modules/ecr`: repo + lifecycle policy (păstrează ultimele 10 imagini).
- [ ] `infra/20-data` cu `modules/rds`: MySQL `db.t4g.micro` în private-db, `manage_master_user_password = true` (parola stă în Secrets Manager, nu în state), `deletion_protection`, backup 7 zile. **Rămâne pornit.**
- [ ] Acces la DB de pe laptop fără să fie public: SSM port forwarding printr-o instanță din VPC (`AWS-StartPortForwardingSessionToRemoteHost`).
- [ ] App config: `secrets.json` → env var; app citește secretele la startup.
- [ ] `modules/ec2-app`: ASG în private-app + ALB public; user_data trage imaginea din ECR; SG: ALB → app:5000 → RDS:3306.
- [ ] Migrații DB (Flask-Migrate) rulate ca pas separat, nu la fiecare boot.
**Gata când:** aplicația merge prin ALB, RDS nu are IP public, nicio parolă în cod/state în clar.

## Faza 4 — CI/CD pentru aplicație (2 sesiuni, ~0$)
**Concepte:** jobs, needs, matrix, cache, reusable workflows, image tagging (git SHA, nu `latest`), supply chain (scan, SBOM). OIDC e deja făcut în Faza 2.
- [ ] Rol `gha-app-deploy` în `00-bootstrap` (push ECR + instance refresh, nimic altceva).
- [ ] Workflow `app-ci.yml`: lint (ruff) → pytest → docker build (cache buildx) → Trivy scan → push ECR `:<sha>`.
- [ ] Deploy pe ASG: instance refresh declanșat din pipeline.
- [ ] Înlocuiește vechiul `ci-cd.yml` (SSH + Docker Hub) — păstrează-l ca `.old` pentru comparație.
**Gata când:** un push pe branch ajunge în producție fără nicio cheie AWS statică în GitHub.

## Faza 5 — Ansible (1–2 sesiuni, ~1$)
**Concepte:** control node vs managed node, inventar static vs dinamic, playbook, task, handler, role, idempotență, variables/group_vars, templates Jinja2, Ansible Vault, `--check --diff`.
- [ ] Din WSL: inventar dinamic `amazon.aws.aws_ec2` (filtrat pe tag-uri).
- [ ] Conexiune prin SSM (`amazon.aws.aws_ssm`) — fără SSH deschis.
- [ ] Role-uri: `common` (pachete, swap, timezone), `docker`, `node_exporter`.
- [ ] Rulează de 2 ori — a doua rulare trebuie să arate `changed=0`.
**Unde se potrivește în industrie:** Terraform creează infrastructura, Ansible configurează mașinile (sau construiește AMI-uri cu Packer).

## Faza 6 — Monitoring v1 pe EC2 (2 sesiuni, ~1.5$)
**Concepte:** pull vs push metrics, service discovery, PromQL, RED/USE, recording & alerting rules, Alertmanager, Grafana provisioning (dashboards as code), CloudWatch.
- [ ] Terraform: host `monitoring` (t3.small — t3.micro a murit de OOM în disertație) în private-app, acces prin SSM port-forwarding.
- [ ] Ansible role-uri `prometheus`, `grafana`, `alertmanager` — config din repo, nimic manual.
- [ ] Prometheus `ec2_sd_configs` pentru fleet-ul ASG; datasource + dashboard-uri Grafana provizionate din fișiere.
- [ ] Alerte: instanță down, 5xx > 5%, p95 > 1s, CPU > 80%. Alertmanager → email/Discord webhook.
- [ ] Grafana CloudWatch datasource pentru RDS (CPU, conexiuni, storage).

## Faza 7 — ECS Fargate (2 sesiuni, ~2$)
**Concepte:** cluster, task definition, service, Fargate vs EC2 launch type, **task role vs execution role**, `awsvpc` networking, target group de tip `ip`, secrets din Secrets Manager în task def, CloudWatch Logs, service autoscaling, rolling vs blue/green (CodeDeploy).
- [ ] `modules/ecs-service`: cluster + task def + service în private-app, în spatele ALB-ului.
- [ ] Autoscaling target tracking (CPU 60% sau requests per target).
- [ ] Pipeline: deploy = task def nouă cu `:<sha>` → `aws ecs update-service` (sau `amazon-ecs-deploy-task-definition`).
- [ ] Compară în `notes/`: EC2 ASG vs ECS — ce nu mai administrezi.

## Faza 8 — Kubernetes local (2–3 sesiuni, 0$)
**Concepte:** Pod, Deployment, ReplicaSet, Service (ClusterIP/NodePort/LoadBalancer), Ingress, ConfigMap, Secret, Namespace, probes (liveness/readiness/startup), requests/limits, HPA, PDB, **RBAC** (ServiceAccount, Role, ClusterRole, RoleBinding), NetworkPolicy, Kustomize, Helm.
- [ ] Cluster `kind` + ingress-nginx + metrics-server; MySQL în cluster doar local.
- [ ] Manifeste `k8s/base` (înlocuiesc `k8manifest.yaml`), overlay `dev`.
- [ ] RBAC: user „developer” cu acces read-only în namespace `app` + test cu `kubectl auth can-i`.
- [ ] NetworkPolicy: doar pod-urile app pot vorbi cu DB-ul.
- [ ] Transformă manifestele în Helm chart `k8s/charts/flask-app`.

## Faza 9 — EKS (3 sesiuni, ~5–8$ — sesiuni scurte, destroy obligatoriu)
**Concepte:** control plane managed, managed node groups vs **Fargate profiles**, EKS access entries → RBAC, **IRSA vs EKS Pod Identity**, AWS Load Balancer Controller, External Secrets Operator, Cluster Autoscaler / Karpenter, add-ons (vpc-cni, coredns, kube-proxy).
- [ ] `modules/eks` (aici e ok `terraform-aws-modules/eks` — dar citește ce creează).
- [ ] Varianta A: managed node group (t3.medium spot). Varianta B: Fargate profile pentru namespace `app`. Notează diferențele (ex. **Fargate nu suportă DaemonSet** → node-exporter nu merge).
- [ ] AWS LB Controller → Ingress creează ALB automat.
- [ ] External Secrets Operator → secretul RDS din Secrets Manager devine k8s Secret.
- [ ] Access entry pentru un rol IAM „developer” mapat pe Role-ul RBAC din faza 8.
- [ ] Deploy aplicația cu Helm chart-ul tău, conectată la RDS.

## Faza 10 — Monitoring v2 în Kubernetes (1–2 sesiuni)
**Concepte:** Prometheus Operator, ServiceMonitor, PrometheusRule, kube-state-metrics, logs (Loki) — opțional.
- [ ] `kube-prometheus-stack` prin Helm; ServiceMonitor pentru flask-app.
- [ ] Mută dashboard-urile din faza 6 ca ConfigMap-uri provizionate.
- [ ] Opțional: Loki + Promtail pentru loguri.

## Faza 11 — CI/CD către Kubernetes + GitOps (1–2 sesiuni)
**Concepte:** push-based vs pull-based (GitOps), Argo CD, promovare între medii.
- [ ] Varianta push: Actions → `helm upgrade --install` pe EKS prin OIDC.
- [ ] Varianta GitOps: Argo CD urmărește `k8s/`; pipeline-ul doar actualizează tag-ul imaginii.

## Faza 12 — Hardening de producție (opțional, pe bucăți)
- [ ] HTTPS: ACM + Route 53 (ai nevoie de un domeniu, ~10$/an).
- [ ] WAF pe ALB (rate limiting — legătura cu feature-ul DDOS-protection din repo).
- [ ] Policy as code: `checkov`/OPA cu reguli proprii (ex. „orice SG fără 0.0.0.0/0 pe 22”), peste `tflint` + `trivy config` din Faza 2.
- [ ] Backup/restore RDS testat, RDS Multi-AZ, chaos test (omori un pod/instanță, urmărești în Grafana).
- [ ] Mediu `prod` separat (`envs/prod`) — aceleași module, alte variabile.
- [ ] Load test cu Locust (ai deja `locust_data/`) pe EKS vs ECS vs ASG.

---

## Estimare consum credite
Permanent (foundation + RDS): **~15$/lună → ~75–90$ pe 5–6 luni** (mai puțin dacă RDS micro intră în free tier).
Efemer, sesiuni de ~3h cu destroy: **~25–40$** pe tot proiectul. EKS e cel mai scump.
→ Încape în 200$ credite. În 100$ încape doar dacă RDS e acoperit de free tier sau dacă îl oprești/snapshot-ezi în pauze. Verificăm Billing săptămânal.

Prețuri orientative pe oră:
| Resursă           | Preț aprox. (eu-central-1) |
|-------------------|----------------------------|
| NAT Gateway       | ~0.052$/h + trafic         |
| ALB               | ~0.027$/h                  |
| RDS db.t4g.micro  | ~0.017$/h + storage (free tier dacă eligibil) |
| EKS control plane | 0.10$/h                    |
| Fargate           | ~0.05$/h per task 0.5vCPU/1GB |
| EC2 t3.micro/small| ~0.012 / 0.024$/h          |
| IPv4 public       | 0.005$/h per IP (inclusiv cel al NAT/ALB) |

Uitat pornit o lună (NAT + ALB + EKS): ~130$, adică practic toate creditele.
