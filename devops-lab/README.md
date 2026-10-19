# DevOps Lab

Proiect de învățare hands-on: aplicația Flask din acest repo, dusă printr-un stack de producție complet pe AWS.

**Stack:** GitHub Actions · Terraform · AWS (VPC, IAM, RDS, EC2/ASG, ALB, ECR, Secrets Manager, ECS Fargate, EKS) · Docker · Kubernetes (RBAC, Helm, Kustomize) · Ansible · Prometheus/Grafana/Alertmanager.

- [PLAN.md](PLAN.md) — fazele, conceptele și criteriile de „gata”
- [PROGRESS.md](PROGRESS.md) — unde am rămas, ce e pornit în AWS, jurnal sesiuni
- `notes/` — notițe personale per fază

## Cum începi un chat nou
Deschide un chat în `E:\Licenta` și scrie, de exemplu:

> Continuăm DevOps Lab. Citește PROGRESS.md și hai să facem următorul pas.

`CLAUDE.md` din root se încarcă automat și îi spune lui Claude regulile proiectului.
La final: „actualizează PROGRESS.md”.

## Reguli
1. Totul prin Terraform. Consola doar ca să explorezi sau să depanezi. Nimic făcut de mână care să nu fie în cod.
2. Straturile efemere (NAT, compute, ECS, EKS) se distrug la finalul fiecărei sesiuni. Rețeaua și RDS rămân pornite.
3. Zero secrete în git.
