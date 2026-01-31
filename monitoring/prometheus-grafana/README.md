# Observability – Prometheus & Grafana (CI/CD Ready)

This setup installs Prometheus and Grafana using Helm.
It is deployed only via CI/CD to avoid idle AWS costs.

## Deployment (when EKS exists)
Triggered automatically via GitHub Actions.

## Removal
Monitoring stack is deleted when cluster is destroyed.

## Tools
- Prometheus: metrics collection
- Grafana: visualization
- Helm: package management

This approach follows cost-optimized DevOps best practices.
