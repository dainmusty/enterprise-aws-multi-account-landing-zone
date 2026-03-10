# Enterprise AWS Multi-Account Landing Zone (Terraform + GitHub Actions)

## Overview

This project demonstrates an enterprise-grade AWS Landing Zone built using Terraform, AWS Organizations, and GitHub Actions.

It provides a secure, scalable cloud foundation with automated governance, centralized security monitoring, and self-service AWS account provisioning.

The architecture is built around five core enterprise pillars:

- Identity – IAM Identity Center (SSO + RBAC)
- Networking – Transit Gateway and centralized DNS
- Security – GuardDuty, Security Hub, CloudTrail
- Workloads – Isolated Dev/Prod environments
- Governance – SCP guardrails, budgets, sandbox controls

---

# Architecture Overview

```
                Management Account
               (AWS Organization)
                       │
      ┌────────────────┼────────────────┐
      │                │                │
   Security OU   Infrastructure OU   Workloads OU
      │                │                │
 Log Archive      Network Account     Dev
 Audit Account    Shared Services     Staging
                                      Production
```

---

# AWS Organization Structure

```
Root
│
├── Security OU
│   ├── Log Archive Account
│   └── Audit Account
│
├── Infrastructure OU
│   ├── Network Account
│   └── Shared Services Account
│
├── Workloads OU
│   ├── Production Accounts
│   └── NonProduction Accounts
│
└── Sandbox OU
    └── Developer Sandbox
```

### Design Principles

- No workloads deployed in the management account
- Strong account-level isolation
- Centralized logging and security monitoring
- Shared platform services
- Dedicated sandbox for experimentation

---

# Security Architecture

### Log Archive Account

Central immutable logging destination for:

- Organization CloudTrail
- VPC Flow Logs
- Long-term encrypted S3 log storage

### Audit Account

Centralized security monitoring using:

- Amazon GuardDuty (delegated admin)
- AWS Security Hub
- AWS Config aggregator
- Cross-account audit access

---

# Infrastructure Platform Layer

### Network Account

Provides centralized networking services:

- Transit Gateway
- Shared VPC networking
- Route53 DNS resolution
- VPC endpoints
- Centralized ingress/egress

### Shared Services Account

Hosts reusable infrastructure components:

- Private ECR container registry
- CI/CD runners
- Monitoring stack
- Backup vaults
- SSM patch baselines
- Private DNS zones

---

# Workload Accounts

Applications are deployed in isolated AWS accounts.

```
Workloads OU
│
├── Production
│   ├── Prod-App1
│   └── Prod-App2
│
└── NonProduction
    ├── Dev
    └── Staging
```

### Benefits

- Reduced blast radius
- Independent deployments
- Environment-specific guardrails
- Clear cost attribution

---

# Kubernetes Platform (Amazon EKS)

Standardized Amazon EKS clusters can be deployed in workload accounts.

### Development Clusters

- 2 Availability Zones
- Single node group
- Moderate autoscaling

### Production Clusters

- 3 Availability Zones
- Multiple node groups
- Full control plane logging
- Enhanced monitoring

### Platform Add-ons

- ArgoCD (GitOps deployment)
- AWS Load Balancer Controller
- Cluster Autoscaler
- ExternalDNS
- Cert Manager
- Metrics Server
- Velero (cluster backups)

---

# Backup and Disaster Recovery

```
EKS
 │
Velero
 │
IRSA
 │
S3 Backup Bucket
 │
Cross-Region Replication
 │
Disaster Recovery
```

Production clusters include automated backups and cross-region replication.

---

# Self-Service Account Provisioning (Account Vending Machine)

Developers request new AWS accounts using a pull request workflow.

Example request:

```yaml
name: payments-prod
email: payments-prod@company.com
ou: workloads
environment: prod

permission_sets:
  - DeveloperAccess
  - ReadOnlyAccess
```

### Workflow

1. Developer submits YAML request
2. GitHub Actions triggers Terraform
3. Terraform creates the AWS account and applies guardrails
4. IAM Identity Center assigns RBAC access

Result: New AWS accounts provisioned securely in minutes.

---

# Identity and Access Management

Authentication is centralized using AWS IAM Identity Center (SSO).

Supported identity providers:

- Azure AD
- Okta
- External SAML providers

Access model:

```
Identity Provider
       │
       ▼
IAM Identity Center
       │
       ▼
Identity Groups
       │
       ▼
Permission Sets
       │
       ▼
AWS Accounts
```

---

# Governance Guardrails

Organization-wide policies enforced with Service Control Policies (SCPs).

Examples:

- Prevent disabling CloudTrail
- Block public S3 buckets
- Restrict unapproved AWS regions
- Prevent root user actions

CI pipelines validate policies before deployment.

---

# Terraform Project Structure

```
aws-landing-zone
│
├── modules
│   ├── organization
│   ├── scp
│   ├── account-baseline
│   ├── shared-vpc
│   └── sandbox-guardrails
│
├── environments
│   ├── management
│   ├── security
│   ├── shared-services
│   └── workloads
│
└── accounts
```

---

# Sandbox Environment

Dedicated sandbox accounts allow safe experimentation with:

- Budget guardrails
- SCP restrictions
- Service quotas
- Automated cleanup policies

---

# Key Platform Capabilities

- AWS multi-account organization
- Automated account provisioning
- Centralized security monitoring
- Immutable audit logging
- Shared networking platform
- Kubernetes platform (EKS)
- GitOps infrastructure workflows
- Backup and disaster recovery
- Governance guardrails

---

# Lessons Learned

- Account boundaries are the strongest security control
- Immutable logging is critical for compliance
- SCP guardrails should be introduced gradually
- Networking architecture decisions must happen early
- Terraform modules enable scalable platform engineering

---

# Final Thoughts

A well-designed landing zone provides the foundation for secure cloud adoption.

By combining AWS Organizations, Terraform, GitHub Actions, and centralized governance, this platform enables organizations to scale AWS workloads while maintaining security, visibility, and operational control.