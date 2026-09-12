# LEZ demo — single-instance AWS deployment

This deployment intentionally prioritizes low cost and presentation reliability over
high availability. One `t3a.small` runs Flask, MySQL, Prometheus, Grafana and
node-exporter in Docker. There is no RDS, ALB, NAT Gateway or Auto Scaling Group.

## Authentication

Use temporary browser credentials:

```powershell
aws login --profile lez-demo --region eu-central-1
aws sts get-caller-identity --profile lez-demo
```

Do not copy access keys into this directory or into Terraform variables.

## Runtime secret

The EC2 bootstrap expects `/lez-demo/runtime`, an SSM SecureString JSON parameter
containing database, Flask, Grafana and Docker Hub credentials. `deploy.ps1` creates
or rotates it without putting secret values into Terraform state.

## Deploy

```powershell
cd E:\Licenta\terraform-single
.\deploy.ps1
```

The initial boot can take 5–10 minutes while Docker images are downloaded and the
database backup is imported.

## Operate

```powershell
terraform output

# Inspect the host without SSH
aws ssm start-session --profile lez-demo --region eu-central-1 --target (terraform output -raw instance_id)
# then run: sudo /usr/local/bin/lez-demo-status

# Stop compute billing after the presentation (EBS and S3 remain billed)
aws ec2 stop-instances --profile lez-demo --region eu-central-1 --instance-ids (terraform output -raw instance_id)

# Start it again; the public IP changes
aws ec2 start-instances --profile lez-demo --region eu-central-1 --instance-ids (terraform output -raw instance_id)
```

Grafana's generated password stays in SSM. Retrieve it locally when needed:

```powershell
$json = aws ssm get-parameter --profile lez-demo --region eu-central-1 --name /lez-demo/runtime --with-decryption --query Parameter.Value --output text | ConvertFrom-Json
$json.GRAFANA_ADMIN_PASSWORD
```

## Removal

Run a final database backup before removal:

```bash
sudo /usr/local/bin/lez-demo-backup
```

The S3 bucket deliberately has `force_destroy = false`, so Terraform cannot silently
delete the seed and database backups. Remove the bucket contents explicitly only
after confirming that the data is no longer needed. The SSM SecureString is also
kept outside Terraform and must be deleted separately.

