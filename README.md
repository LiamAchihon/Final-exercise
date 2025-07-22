# Final DevOps Project – Flask App on AWS EKS with Terraform & Helm

## Overview

This project demonstrates a complete DevOps pipeline using:

- Dockerized Flask application  
- Amazon ECR for image storage  
- Terraform to provision AWS infrastructure (including EKS)  
- Helm to deploy the app to the EKS cluster  
- Cleanup to avoid unnecessary cloud costs  

---

## 📁 Project Structure

final-exercise/
├── app/ # Flask app and Dockerfile
├── terraform/ # Infrastructure as Code (Terraform)
└── helm/ # Helm chart for Kubernetes deployment

yaml
Copy
Edit

---

## 🚀 Step 1: Build & Push Docker Image to ECR

```bash
cd app

# Build the image
docker build -t my-app .

# Tag the image
docker tag my-app:latest 430658514390.dkr.ecr.us-east-1.amazonaws.com/my-app:latest

# Authenticate to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 430658514390.dkr.ecr.us-east-1.amazonaws.com

# Push the image
docker push 430658514390.dkr.ecr.us-east-1.amazonaws.com/my-app:latest
🏗️ Step 2: Provision Infrastructure with Terraform
bash
Copy
Edit
cd terraform

terraform init
terraform apply
# Type 'yes' when prompted
🔗 Step 3: Connect kubectl to EKS
bash
Copy
Edit
aws eks update-kubeconfig --region us-east-1 --name my-eks-cluster

kubectl get nodes
📦 Step 4: Deploy App Using Helm
bash
Copy
Edit
cd helm

helm install final-app .

kubectl get all
🧹 Step 5: Destroy Infrastructure
bash
Copy
Edit
cd terraform

terraform destroy
# Type 'yes' to confirm
📌 Notes
Tools required: Docker, AWS CLI, Terraform, kubectl, Helm

Default region: us-east-1

Estimated cost while running: ~$1.5 to $2 per hour

Run terraform destroy after testing to avoid charges
