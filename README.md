# Tasky Infrastructure Deployment 

This project showcases a fully production-grade infrastructure deployment for the [Tasky app](https://github.com/jeffthorne/tasky), built entirely from scratch using AWS, Terraform, Kubernetes (EKS), and GitOps with Argo CD.

---

##  Technologies Used

- **Terraform** — Infrastructure as Code
- **Amazon EKS** — Managed Kubernetes
- **Amazon DocumentDB** — MongoDB-compatible DB
- **Amazon S3** — Backend for Terraform state
- **GitHub Actions** — CI/CD pipeline
- **Amazon ECR** — Container registry
- **Argo CD** — GitOps tool for continuous delivery
- **External Secrets Operator (ESO)** — Secret injection from AWS Secrets Manager
- **ExternalDNS** & **AWS Load Balancer Controller** — Ingress & DNS automation

---

##  Infrastructure Overview

Provisioned using Terraform:
- Multi-AZ **VPC** with public and private subnets
- **Private worker nodes** for EKS
- **NAT gateways** for outbound access
- **Amazon DocumentDB** for persistent storage
- **S3 Bucket** for Terraform remote backend

---

##  GitOps Deployment

- The application is containerized and built using GitHub Actions.
- Docker images are pushed to **Amazon ECR**.
- Argo CD, following the **App of Apps** pattern, manages application and service deployments from Git.

> 📘 Learn more about Argo CD [here](https://argo-cd.readthedocs.io/en/stable/).

---

##  Security

- Secrets are securely pulled from **AWS Secrets Manager** via **External Secrets Operator**.
- Fine-grained IAM roles are attached to Kubernetes service accounts using **IRSA** (IAM Roles for Service Accounts).
- Ingress and DNS are managed using **AWS Load Balancer Controller** and **ExternalDNS**.

---

##  Live Environment

- **Live App**: [https://tasky.ugo-projects.click](https://tasky.ugo-projects.click)
- **Argo CD Dashboard**: [https://argocd.ugo-projects.click](https://argocd.ugo-projects.click)  


---

##  Repos

- **Infrastructure & GitOps**: [Tasky-Infrastructure-Deployment](https://github.com/ugoasoluka/Tasky-Infrastructure-Deployment)
- **Tasky App Source**: [jeffthorne/tasky](https://github.com/jeffthorne/tasky)

---
