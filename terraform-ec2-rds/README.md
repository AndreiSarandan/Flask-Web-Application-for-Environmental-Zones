# LEZ demo on AWS: EC2 + RDS

Low-cost presentation deployment that preserves the required architecture:

```text
Internet -> EC2 (Flask + Prometheus + Grafana + node-exporter)
              |
              +-> private RDS MySQL (Single-AZ)
```

There is no load balancer, NAT Gateway or Auto Scaling Group. The small private
S3 bucket only transports the existing SQL dump and stores nightly backups; it is
not used as the application database.

## Deploy

```powershell
aws login --profile lez-demo --region eu-central-1
cd E:\Licenta\terraform-ec2-rds
.\deploy.ps1
```

Initial creation normally takes 10–20 minutes because RDS must become available,
then EC2 imports the SQL backup and starts the containers.

## Check

```powershell
terraform output
aws ssm start-session --profile lez-demo --region eu-central-1 --target (terraform output -raw instance_id)
```

Inside the SSM session:

```bash
sudo /usr/local/bin/lez-demo-status
sudo tail -f /var/log/cloud-init-output.log
```

Grafana uses username `admin`. Retrieve the generated password locally:

```powershell
$json = aws ssm get-parameter --profile lez-demo --region eu-central-1 --name /lez-demo/app-runtime --with-decryption --query Parameter.Value --output text | ConvertFrom-Json
$json.GRAFANA_ADMIN_PASSWORD
```

## Stop costs after the presentation

Stop EC2 first, then RDS:

```powershell
$instance = terraform output -raw instance_id
$database = terraform output -raw rds_identifier
aws ec2 stop-instances --profile lez-demo --region eu-central-1 --instance-ids $instance
aws rds stop-db-instance --profile lez-demo --region eu-central-1 --db-instance-identifier $database
```

RDS automatically restarts after seven stopped days. Storage, backups and the EC2
EBS volume remain billable while compute is stopped.

