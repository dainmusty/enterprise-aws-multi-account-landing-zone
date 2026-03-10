# Centralized Logging Aggregation
# Even though Log Archive stores logs,Shared Services can host:OpenSearch. Grafana, Prometheus, SIEM tools
resource "aws_opensearch_domain" "logs" {
  provider = aws.shared_services
  domain_name = "enterprise-logs"
}