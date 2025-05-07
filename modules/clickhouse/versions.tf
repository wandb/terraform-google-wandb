terraform {
  required_version = "~> 1.9"
  required_providers {
    clickhouse = {
     version = "3.1.2"
     source  = "ClickHouse/clickhouse"
    }
  }
}
