# 🌐 EKS Atlas NodeJS Microservice

This project demonstrates how to use **Terraform**, **Helm**, and **GitHub Actions** to provision a cloud infrastructure on **AWS** and **MongoDB Atlas**, and automatically deploy a Node.js microservice through a complete CI/CD pipeline.

## 📦 Repository Contents

- 🛠️ Terraform folder (infrastructure)
  - EKS Cluster
  - ALB Ingress Controller
  - VPC, IAM roles/policies, etc.
  - MongoDB Atlas Cluster (via Terraform)

- 📦 Helm folder (infrastructure)
  - Helm Chart for EKS deployment

- 🧠 A Node.js Microservice (Express) written in typescript exposing CRUD APIs on a "users" resource.

- 🔁 GitHub Action for CI/CD:
  - Apply Terraform plan, Build/Push Docker image and Deploy the microservice on EKS through Helm.
  - Destroy infrastructure when needed.

---

## 🔐 Prerequisites

1. **AWS Account**

   - Required variables:
     - `AWS_ACCESS_KEY_ID`
     - `AWS_SECRET_ACCESS_KEY`
   - You must create an IAM User associated with these keys which must have permissions to create **AutoScaling**, **C2**, **VPC**, **EKS**, **ALB**, and **IAM** resources.

2. **Terraform Cloud Account**

   - Required variable:
     - `TF_API_TOKEN`
   - You must create an organization and a workspace with execution mode set to "Remote" in Terraform Cloud.
   - The `TF_API_TOKEN` should be a Team API token with permissions to manage workspaces and run plans.

3. **MongoDB Atlas Account**

   - Required variables:
     - `ATLAS_PUBLIC_KEY`
     - `ATLAS_PRIVATE_KEY`
   - You must create an Atlas Organization manually and generate the API keys from the Atlas UI with Organization Owner permissions.
     Note: In the Organization settings, ensure to deselect "Require IP Access List for the Atlas Administration API". This is necessary to allow the Terraform provider to manage resources without IP restrictions.

4. **DockerHub Account** (to publish the microservice image)
   - `DOCKERHUB_USERNAME`
   - `DOCKERHUB_TOKEN`
   - You must create a DockerHub account and generate a Personal Access Token with read and write permissions to your repositories.

---

## 🛠️ Configurations

You must set the following variables in your Terraform Cloud workspace.

| Name                    | Description                     | Type      | Category  |
| ----------------------- | ------------------------------- | --------- | --------- |
| `atlas_db_password`     | MongoDB Atlas database password | Sensitive | Terraform |
| `atlas_db_username`     | MongoDB Atlas database username | Sensitive | Terraform |
| `atlas_org_id`          | MongoDB Atlas Organization ID   | Sensitive | Terraform |
| `atlas_private_key`     | MongoDB Atlas private key       | Sensitive | Terraform |
| `atlas_public_key`      | MongoDB Atlas public key        | Sensitive | Terraform |
| `AWS_ACCESS_KEY_ID`     | AWS Access Key ID               | Sensitive | env       |
| `AWS_SECRET_ACCESS_KEY` | AWS Secret Access Key           | Sensitive | env       |

You must also set the following variables in your GitHub repository secrets:

| Name                    | Description                     |
| ----------------------- | ------------------------------- |
| `AWS_ACCESS_KEY_ID`     | AWS Access Key ID               |
| `AWS_SECRET_ACCESS_KEY` | AWS Secret Access Key           |
| `TF_API_TOKEN`          | Terraform Cloud API Token       |
| `MONGODB_USERNAME`      | MongoDB Atlas database username |
| `MONGODB_PASSWORD`      | MongoDB Atlas database password |
| `DOCKERHUB_USERNAME`    | DockerHub username              |
| `DOCKERHUB_TOKEN`       | DockerHub Personal Access Token |

## 🧰 Project Structure

```

.
├── .github/
│   └── workflows/
│       ├── plan-provisioning-on-pull-request.yml
│       ├── provision-infrastructure-and-deploy-application.yml
│       └── destroy-infrastructure.yml
├── .gitignore
├── infrastructure/
│   ├── helm/
│   │   ├── charts/
│   │   ├── templates/
│   │   ├── values.yaml
│   │   └── Chart.yaml
│   │   └── ...
│   ├── terraform/
│   │   ├── modules/
│   │   │   ├── eks/
│   │   │   ├── alb/
│   │   │   ├── vpc/
│   │   │   └── mongodb-atlas/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── ...
├── src/
│   ├── server.ts
│   ├── routes/
│   ├── models/
│   ├── services/ 
├── package.json
├── yarn.lock
├── tsconfig.json
├── Dockerfile
└── README.md

```

---

## 🚀 Step-by-Step: How to Replicate the Project

### 1. **Fork the repository**

Click "Fork" in the top-right corner on GitHub.

### 2. **Clone your fork**

```bash
git clone https://github.com/<your-username>/your-repo-name.git
cd your-repo-name
```

### 3. **Configure GitHub Secrets**

Go to your forked repository on GitHub, navigate to **Settings > Secrets and variables > Actions**, and add the secrets listed in the "Configurations" section above.

### 4. **Configure Terraform Cloud Workspace**

Go to your Terraform Cloud account, create a new workspace, and set the required variables as described in the "Configurations" section. Ensure that the workspace is set to "Remote" execution mode.

### 5. **Customize the Microservice (Optional)**

Go to the `src/` folder and edit the Node.js microservice code as needed. You can modify the API endpoints, add new features, or change the database schema.

### 6. **Push to `master` branch**

Each push to the `master` branch will:

- Apply the Terraform plan via Terraform Cloud provisioning the EKS cluster, ALB, and MongoDB Atlas cluster.
- Create a .env file with the database connection string and other environment variables for the microservice.
- Build and push the Docker image of the microservice to your DockerHub repository.
- Deploy a Deployment, Service, and Ingress resource to the EKS cluster using Helm.
- Echo the ALB DNS name in the GitHub Actions logs, in order to access the microservice APIs.

---

## 📡 Microservice API

Once successfully deployed, the ALB will expose the CRUD APIs.

```http
GET http://<alb-dns-name>/api/users // List all users
GET http://<alb-dns-name>/api/users/:id // Get a user by ID
POST http://<alb-dns-name>/api/users // Create a new user
PUT http://<alb-dns-name>/api/users/:id // Update a user by ID
DELETE http://<alb-dns-name>/api/users/:id // Delete a user by ID
```
---

## 📎 Final Notes

- After the provisioning of the EKS cluster, create a Kubernetes Service Account with the necessary permissions to allow the ALB Ingress Controller to manage resources in the EKS cluster. It also deploys an ALB Ingress Controller class to the cluster through `aws-load-balancer-controller` Helm chart.
- The Atlas cluster is accessesible from anywhere. If you have an Atlas Account with billing enabled, you can decomment the `mongodbatlas_privatelink_endpoint` and `mongodbatlas_privatelink_endpoint_service` blocks in the `mongodb-atlas` module to create a private link endpoint for the Atlas cluster from the VPC where the EKS cluster was created.
- The microservice connects to MongoDB using hostname provided in the `.env` file generated during the provisioning process.

---

## 🧹 Cleanup

Remember to clean up the resources when you are done testing in order to avoid unnecessary costs:
- You can run a GitHub Action to destroy the infrastructure by triggering the `destroy-infrastructure.yml` workflow.