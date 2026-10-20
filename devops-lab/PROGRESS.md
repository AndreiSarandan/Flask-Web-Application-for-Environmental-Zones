# DevOps Lab — progres (memoria comună între chaturi)

> Actualizează acest fișier la finalul FIECĂREI sesiuni. Un chat nou citește întâi asta.

## Stare curentă
- **Faza activă:** 1 — Terraform fundamente: bootstrap ✅, rețea `10-foundation` + `modules/network` ✅, urmează `30-nat`
- **Cont de lucru: `678530698532` — TOT lab-ul rulează aici.** Acces cu un IAM user personal (IAM clasic), drepturi prin grupuri.
- **(Context org)** AWS Organization `o-u9jfaxktb9`, 3 conturi (acces prin SSO, rol `AccountFullAccessRole`):
  - `678530698532` Ale-Team Management Account — plătește factura, are creditele. **Aici rulează lab-ul.**
  - `810995308787` Ale-Team Identity Delegated Admin — administrează IAM Identity Center.
  - `741796256003` Stack of Dreams — nefolosit în lab.
- **Credite:** 120$ pe management account (100$ Free Tier + 20$ activitate „Budgets”), folosite 0$. Expirare: de completat. Credit sharing: **Activated** pe toate 3 conturile (+ default pentru conturi noi). De verificat: plan Free vs Paid; activitățile „Explore AWS” rămase (+20$ fiecare, până la 200$).
- **Resurse AWS pornite acum:**
  - permanent: S3 `devops-lab-tfstate-678530698532-eu-central-1-an` (state bucket, ~0$) — strat `00-bootstrap`
  - permanent: rețeaua `lab-dev-vpc` (`vpc-0dbb1f072857e45a1`, 10.20.0.0/16): 6 subneturi, IGW, 3 RT, S3 gateway endpoint — strat `10-foundation`, 0$
  - efemer: niciuna
  - (default VPC `172.31.0.0/16` există în regiune — nu e al nostru, îl ignorăm)
- **Disertație:** nu refolosim nimic din infra veche; din repo luăm doar aplicația + Dockerfile. Totul se construiește de la zero în contul nou.
- **MFA:** sărit deliberat (user-ul nu vrea pentru demo).
- **Mediu local:** WSL2 Ubuntu-24.04 (user `andrei`) **mutat deja pe `E:\WSL\Ubuntu`**. C: are ~9 GB liberi — **nimic mare pe C:** (Docker Desktop disk image, WSL, cache-uri → pe E:). Toolchain-ul complet e în WSL (aws 2.38, terraform 1.16, kubectl 1.31, helm 4.3, kind 0.33, gh, ansible-core 2.21 + amazon.aws/community.general, docker 27 via Docker Desktop). **Lucrăm din WSL.**
- **Făcut în Faza 0:** IAM user `andrei-sarandan` + grupuri `DevOps` (EC2FullAccess + RDSFullAccess + `SignInLocalDevelopmentAccess`) și `Admins` (`LabAdminPolicy`, vezi `iam/admins-policy.json`). Billing access pentru IAM activat. `aws login --profile lab` merge (regiune eu-central-1; când expiră sesiunea → din nou `aws login --profile lab`). JSON-uri budget/anomaly în `billing/`.
- **State Terraform:** backend S3 în bucket-ul de mai sus, `key = dev/<strat>/terraform.tfstate`, `use_lockfile = true`. Înainte de orice comandă TF: `export AWS_PROFILE=lab` (+ `aws login --profile lab` dacă a expirat).
- **Structură infra (plată):** `devops-lab/infra/NN-strat/` + `devops-lab/infra/modules/` (fără `live/dev/`). Fișiere per strat după HashiCorp style guide: `terraform.tf` (versiuni), `backend.tf`, `providers.tf` (cu tag `Layer`), `main.tf`, `outputs.tf`; module: `terraform.tf`, `variables.tf`, `main.tf`, `outputs.tf`.
- **Branch:** trunk `devops-lab` (pushed pe origin). Lucru curent pe `feat/network`: commit `aed3023` = rețeaua în `10-foundation`; **necomis încă**: refactorul în `modules/network` (+ `10-foundation/main.tf`, `outputs.tf`). Blocurile `moved` au fost aplicate și apoi șterse. Apoi PR `feat/network` → `devops-lab`.
- **`10-foundation` outputs** (citite de `30-nat` prin `terraform_remote_state`): `private_app_route_table_id`, `private_app_subnet_ids`, `private_data_subnet_ids`, `public_subnet_ids`, `vpc_id`.
- **Mod de lucru preferat (din 2026-10-20):** userul scrie singur resursele după documentația oficială (Terraform Registry / AWS docs); Claude dă linkurile, pașii și ce să urmărească în plan, și răspunde la întrebări.
- **Următorul pas:** commit refactor + PR/merge `feat/network`; apoi `infra/30-nat` (EIP + NAT Gateway în `public-a` + `aws_route` 0.0.0.0/0 pe RT private-app, ID-uri din remote state). **Efemer: destroy la finalul sesiunii (~0.05$/h + IPv4).**

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
| 2026-10-19 | Bucket-ul de state creat manual în consolă, apoi `import` în TF | fără oul-și-găina cu `migrate-state`; exercițiu de import + zero drift |
| 2026-10-19 | Structură plată `infra/NN-strat/` (fără `live/dev/`) | un singur mediu; env-ul e deja în tag-uri și în key-ul de state |
| 2026-10-19 | Fără hardening opțional (policy HTTP-deny, lifecycle) | userul vrea pașii minimi; extra doar dacă e nevoie |
| 2026-10-19 | Branch `devops` redenumit `devops-lab`; feature branches `feat/*` | consistent cu CLAUDE.md/PLAN; numele intră în `sub` claim-ul OIDC din Faza 2 |
| 2026-10-19 | Nume de fișiere după HashiCorp style guide (`terraform.tf` + `backend.tf`, nu `versions.tf`) | userul vrea structura cât mai aproape de documentația oficială |
| 2026-10-20 | Rutele se pun cu `aws_route` separat, nu inline în `aws_route_table` | `30-nat` adaugă rute pe RT-urile din `10-foundation`; inline + `aws_route` pe același RT se bat cap în cap |
| 2026-10-20 | Un RT per nivel privat (nu per AZ) | un singur NAT; per-AZ abia cu NAT per AZ |

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

### 2026-10-19 — Faza 1: bootstrap (state bucket)
- Ce am făcut: bucket S3 creat în consolă (Frankfurt, versioning, SSE-S3, block public access, tag-uri; numele a primit sufixul `-eu-central-1-an` = account regional namespace). `infra/00-bootstrap` cu `versions.tf` (pin TF ≥1.10, aws ~> 6.0, backend S3 + `use_lockfile`), `providers.tf` (region + `default_tags`, fără `profile`), `main.tf` (data sources, `locals`, bucket cu `prevent_destroy`, versioning, SSE, public access block). Import cu blocuri `import`, apply → state în S3. 4 resurse în state.
- Ce am învățat: folder = root module = state separat (blast radius, lifecycle diferit); `.terraform/terraform.tfstate` e doar cache-ul config-ului de backend, nu state; state-ul real apare în S3 abia la primul apply; „No changes” fără `main.tf` = zero resurse declarate; lanțul de credențiale (AWS_PROFILE → `aws login` → token temporar) e același pentru CLI și TF; S3 nu e într-un VPC — e protejat prin IAM/policy, nu prin rețea (VPC-ul îl atinge doar prin gateway endpoint).
- Probleme + rezolvare: typo `--butcket`; `main.tf` necreat/nesalvat → plan gol; nume de bucket diferit de cel plănuit (sufix `-an`) → actualizat backend + import.
- Ce a rămas pornit în AWS: doar bucket-ul de state (permanent, ~0$). Nimic efemer.
- Următorul pas: `infra/10-foundation` — VPC.

### 2026-10-19 → 20 — Faza 1: rețeaua (`10-foundation` + `modules/network`)
- Ce am făcut: branch `devops` → `devops-lab` (pushed; auth GitHub prin `gh auth login`), primul commit cu `00-bootstrap`; `.gitignore` + `tfplan`, `*.pem`, `*.csv`. Fișiere redenumite după style guide. Rețeaua pas cu pas, plan/apply după fiecare: VPC → 6 subneturi (`for_each` pe `locals`) → IGW + RT public + `aws_route` + asocieri → RT-uri private (`private-app`, `private-data`, doar `local`) → S3 gateway endpoint → outputs. Apoi refactor în `modules/network` cu blocuri `moved` → plan `0 to add/change/destroy`, apply doar pe state; `moved` șterse după.
- Ce am învățat: `plan -out` + `apply tfplan` (aplici exact ce ai revizuit; fișierul conține secrete → gitignored); `for_each` vs `count`; `for` expressions ca filtru (`{...}` → map, `[...]` → listă); public/privat = ruta din RT, nu numele; ruta `local` implicită; main RT + default VPC create automat de AWS; gateway endpoint S3 gratuit (prefix list `pl-…`); modul = funcție (variables = parametri, outputs = return), stratul îl apelează; outputs-urile stratului sunt cele scrise în state și citite de alte straturi; resursele de rețea sunt gratuite — nu are sens destroy pentru cost.
- Probleme + rezolvare: push cu parolă refuzat → `gh auth login`; `10-foundation` creat din greșeală în `00-bootstrap/` → mutat; în modul rămăseseră `local.subnets` și lipsea `data "aws_region"` → corectat.
- Ce a rămas pornit în AWS: bucket state + rețeaua (ambele permanente, ~0$). Nimic efemer.
- Următorul pas: commit refactor + PR/merge, apoi `30-nat`.
