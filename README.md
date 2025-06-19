# 🌐 Microservizio Node.js con Deploy su EKS, MongoDB Atlas e CI/CD via GitHub Actions

Questo progetto dimostra come usare **Terraform**, **Helm**, e **GitHub Actions** per il provisioning di un'infrastruttura cloud-ready su **AWS** ed **Atlas MongoDB**, e il deploy automatico di un microservizio Node.js tramite CI/CD.

## 📦 Contenuto del repository

- 🛠️ Infrastruttura su AWS via Terraform:
  - Cluster EKS
  - ALB Ingress Controller
  - VPC, IAM roles/policies, ecc.
- 🌍 Cluster MongoDB Atlas (via Terraform)
- 🧠 Microservizio Node.js (Express) con CRUD su "utenti"
- 📦 Helm Chart per il deploy sul cluster EKS
- 🔁 GitHub Action per CI/CD:
  - Apply piano Terraform
  - Build/push immagine Docker
  - Deploy via Helm

---

## 🔐 Prerequisiti

1. **Account AWS**  
   - Variabili richieste:
     - `AWS_ACCESS_KEY_ID`
     - `AWS_SECRET_ACCESS_KEY`
   - Lo IAM User deve avere permessi per:
     - EKS, VPC, EC2, IAM, ALB, etc.

2. **Account Terraform Cloud**  
   - Variabile richiesta:
     - `TF_API_TOKEN`
   - Crea un’organizzazione e workspace in modalità "remote" per usare il backend.

3. **Account MongoDB Atlas**
   - Variabili richieste:
     - `ATLAS_PUBLIC_KEY`
     - `ATLAS_PRIVATE_KEY`

4. **DockerHub** (per la pubblicazione dell’immagine del microservizio)
   - `DOCKERHUB_USERNAME`
   - `DOCKERHUB_TOKEN`

5. **GitHub Secrets**
   Tutte le variabili sopra elencate vanno salvate come **GitHub Secrets** nel repository.

---

## 🧰 Struttura del progetto

```
.
├── .github/
│   └── workflows/
│       └── ci-cd.yml
├── charts/
│   └── nodejs-ms/
├── infra/
│   ├── eks/
│   ├── vpc/
│   ├── alb/
│   ├── atlas/
│   └── main.tf
├── microservice/
│   ├── Dockerfile
│   ├── app.js
│   └── ...
└── README.md
````

---

## 🚀 Step-by-step: Come replicare il progetto

### 1. **Forka il repository**

Clicca su "Fork" in alto a destra su GitHub.

### 2. **Clona il fork**

```bash
git clone https://github.com/<tuo-utente>/nome-repo.git
cd nome-repo
````

aws eks update-kubeconfig --region us-east-2 --name eks-cluster
curl --header 'Host: simple-nodejs-app.local' http://k8s-default-nodejsms-89fa6a9e72-1991283653.us-east-2.elb.amazonaws.com

### 3. **Configura i GitHub Secrets**

Nel tuo repository forkato:

1. Vai su `Settings > Secrets and variables > Actions`
2. Aggiungi i seguenti secrets:

| Nome                    | Valore                             |
| ----------------------- | ---------------------------------- |
| `AWS_ACCESS_KEY_ID`     | Chiave AWS                         |
| `AWS_SECRET_ACCESS_KEY` | Segreto AWS                        |
| `TF_API_TOKEN`          | Token API di Terraform Cloud       |
| `ATLAS_PUBLIC_KEY`      | Chiave pubblica Atlas              |
| `ATLAS_PRIVATE_KEY`     | Chiave privata Atlas               |
| `DOCKERHUB_USERNAME`    | Nome utente DockerHub              |
| `DOCKERHUB_TOKEN`       | Personal Access Token di DockerHub |

### 4. **Configura Terraform Cloud**

* Crea un workspace su [Terraform Cloud](https://app.terraform.io)
* Imposta il backend remoto nel file `infra/main.tf` se non è già configurato:

```hcl
terraform {
  backend "remote" {
    organization = "TUO_ORG"

    workspaces {
      name = "eks-nodejs-app"
    }
  }
}
```

### 5. **Personalizza il microservizio (opzionale)**

Vai nella cartella `microservice/` e modifica `app.js` per aggiungere logica o routes personalizzate.

### 6. **Push su `main` o `master`**

Ogni push su `main`/`master`:

* Applicherà il piano Terraform su Terraform Cloud
* Costruirà l’immagine Docker del microservizio
* Pusherà l’immagine su DockerHub
* Eseguirà `helm upgrade --install` per aggiornare o deployare il microservizio

---

## 📡 API del Microservizio

Una volta deployato con successo, l'ALB esporrà le API CRUD.

Esempio di endpoint:

```http
GET http://<alb-dns-name>/api/users
POST http://<alb-dns-name>/api/users
...
```

---

## 📎 Note finali

* L’ALB viene configurato automaticamente come Ingress Controller su EKS.
* Il cluster Atlas viene creato tramite provider MongoDB Atlas su Terraform.
* Il microservizio si connette a MongoDB tramite variabili d’ambiente fornite nel chart Helm.

---

## 🧹 Pulizia

Per distruggere l’infrastruttura:

```bash
cd infra/
terraform destroy
```

Assicurati di eseguire questo comando solo se sei sicuro di voler eliminare tutte le risorse.
