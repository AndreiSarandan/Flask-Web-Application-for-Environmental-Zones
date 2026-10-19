# DevOps Lab — progres (memoria comună între chaturi)

> Actualizează acest fișier la finalul FIECĂREI sesiuni. Un chat nou citește întâi asta.

## Stare curentă
- **Faza activă:** 1 — Terraform fundamente: bootstrap + rețea (Faza 0 gata, faza de consolă eliminată)
- **Cont de lucru: `678530698532` — TOT lab-ul rulează aici.** Acces cu un IAM user personal (IAM clasic), drepturi prin grupuri.
- **(Context org)** AWS Organization `o-u9jfaxktb9`, 3 conturi (acces prin SSO, rol `AccountFullAccessRole`):
  - `678530698532` Ale-Team Management Account — plătește factura, are creditele. **Aici rulează lab-ul.**
  - `810995308787` Ale-Team Identity Delegated Admin — administrează IAM Identity Center.
  - `741796256003` Stack of Dreams — nefolosit în lab.
- **Credite:** 120$ pe management account (100$ Free Tier + 20$ activitate „Budgets”), folosite 0$. Expirare: de completat. Credit sharing: **Activated** pe toate 3 conturile (+ default pentru conturi noi). De verificat: plan Free vs Paid; activitățile „Explore AWS” rămase (+20$ fiecare, până la 200$).
- **Resurse AWS pornite acum:**
  - permanent: niciuna încă
  - efemer: niciuna
- **Disertație:** nu refolosim nimic din infra veche; din repo luăm doar aplicația + Dockerfile. Totul se construiește de la zero în contul nou.
- **MFA:** sărit deliberat (user-ul nu vrea pentru demo).
- **Mediu local:** WSL2 Ubuntu-24.04 (user `andrei`) **mutat deja pe `E:\WSL\Ubuntu`**. C: are ~9 GB liberi — **nimic mare pe C:** (Docker Desktop disk image, WSL, cache-uri → pe E:). Toolchain-ul complet e în WSL (aws 2.38, terraform 1.16, kubectl 1.31, helm 4.3, kind 0.33, gh, ansible-core 2.21 + amazon.aws/community.general, docker 27 via Docker Desktop). **Lucrăm din WSL.**
- **Făcut în Faza 0:** IAM user `andrei-sarandan` + grupuri `DevOps` (EC2FullAccess + RDSFullAccess + `SignInLocalDevelopmentAccess`) și `Admins` (`LabAdminPolicy`, vezi `iam/admins-policy.json`). Billing access pentru IAM activat. `aws login --profile lab` merge (regiune eu-central-1; când expiră sesiunea → din nou `aws login --profile lab`). JSON-uri budget/anomaly în `billing/`.
- **Următorul pas:** branch `devops-lab` + primul commit; apoi Faza 1: `infra/live/dev/00-bootstrap` (bucket de state).

## Decizii luate
| Data       | Decizie | De ce |
|------------|---------|-------|
| 2026-10-17 | Proiectul trăiește în repo-ul existent, folder `devops-lab/`, branch `devops-lab` | aplicația și workflow-urile GitHub sunt deja aici |
| 2026-10-17 | Regiune `eu-central-1`, VPC `10.20.0.0/16`, 2 AZ, 1 NAT | consistent cu disertația; 1 NAT ca să coste puțin |
| 2026-10-17 | ECR în loc de Docker Hub, OIDC în loc de access keys în CI | practică standard de producție |
| 2026-10-17 | Rețeaua scrisă de mână; EKS cu modulul community | rețeaua e fundamentul de învățat; EKS e prea mare pentru scris de la zero |
| 2026-10-17 | Ansible din WSL2; restul nativ pe Windows; mașina Ubuntu separată nu se folosește | Ansible nu suportă Windows ca control node; VM-ul Ubuntu e lent |
| 2026-10-17 | Cont AWS nou pe Free plan, dedicat lab-ului | credite gratuite, izolare de contul disertației |
| 2026-10-17 | Totul în contul `678530698532`, IAM clasic: un singur IAM user personal, în mai multe grupuri (`devops` cu drepturi crescute treptat — întâi EC2+RDS; `admins` cu billing/IAM) | simplu; least privilege prin grupuri |
| 2026-10-17 | Terraform pe straturi; bootstrap + foundation + RDS permanente, NAT/compute efemere | DB-ul și datele rămân; ce e scump se distruge |
| 2026-10-19 | Fără fază de consolă: totul prin Terraform, consola doar la cerere | userul a mai făcut EC2 manual; vrea flux enterprise |
| 2026-10-19 | Pipeline de infra (OIDC + PR → plan → apply) mutat în Faza 2, înainte de RDS/compute | în enterprise infra se schimbă prin PR; tot ce vine după trece prin pipeline |
| 2026-10-19 | Toolchain-ul rulează din WSL, nu nativ pe Windows | toate tool-urile sunt instalate acolo; CI și serverele sunt Linux |

## Jurnal sesiuni
<!-- Format:
### YYYY-MM-DD — Faza X: titlu
- Ce am făcut:
- Ce am învățat / ce m-a surprins:
- Probleme + rezolvare:
- Ce a rămas pornit în AWS:
- Următorul pas:
-->

### 2026-10-17 — Setup proiect
- Creat `CLAUDE.md` (root), `devops-lab/PLAN.md`, `devops-lab/PROGRESS.md`, `devops-lab/README.md`.
- Tool-uri prezente: Terraform 1.15.5, AWS CLI 2.35. Lipsesc: docker, kubectl, helm, kind, gh, ansible (WSL).
- Ce a rămas pornit în AWS: nimic nou.
- Următorul pas: Faza 0.

### 2026-10-17 → 19 — Faza 0: IAM + billing
- Ce am făcut: IAM clasic în contul `678530698532` (nu Identity Center); grup `DevOps` și grup `Admins` cu policy custom `LabAdminPolicy`; `aws login` + profil `lab`; JSON-uri pentru budget (50$/lună, fără credite, alerte 10/40/100% + forecast) și anomaly alert ≥5$.
- Ce am învățat: drepturi prin grupuri, nu pe user; un Deny explicit câștigă peste orice Allow (și între grupuri); `iam:PassRole` pe `*` = privilege escalation; `IncludeCredit:false` ca bugetul să arate consumul real; profile CLI.
- Probleme + rezolvare: `aws login` → „Something went wrong” = lipsea `SignInLocalDevelopmentAccess`; regiunea profilului rămăsese us-east-1 → `aws configure set region eu-central-1 --profile lab`.
- Decizii: MFA sărit; nimic refolosit din infra disertației.
- Ce a rămas pornit în AWS: nimic.
