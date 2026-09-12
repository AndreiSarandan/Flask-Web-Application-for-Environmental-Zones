# Monitoring

Prometheus and Grafana monitor the Flask application and EC2 instances. Prometheus discovers running Auto Scaling Group instances through the EC2 API and collects application metrics and node-exporter metrics.

## Files

- `prometheus.yml`: scrape configuration for the monitoring host and autoscaled instances.
- `grafana/`: dashboards and alert configuration for application performance and availability.
- `iam/trust-policy.json`: trust policy for the monitoring EC2 role.
- `iam/ec2-sd-policy.json`: permissions for EC2 service discovery.

## Deployment

The infrastructure and deployment instructions are in `../terraform/`, `../terraform-single/`, and `../terraform-ec2-rds/`. Use the configuration matching the environment being deployed.

Grafana listens on port 3000 and Prometheus on port 9090. Use the host address from the deployment outputs and obtain credentials from the environment's secret store as described in its README.

Prometheus and Grafana use persistent Docker volumes. The monitoring security group must be allowed to reach application metrics on port 5000 and node-exporter on port 9100.

Import dashboards through Grafana and select the Prometheus datasource configured for the deployment. The instance tags in `prometheus.yml` must match the Auto Scaling Group instances.
