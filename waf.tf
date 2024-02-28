resource "aws_waf_sql_injection_match_set" "sql_injection_match_set" {
  name = "tf-sql_injection_match_set"

  sql_injection_match_tuples {
    text_transformation = "URL_DECODE"

    field_to_match {
      type = "QUERY_STRING"
    }
  }
}

resource "aws_wafv2_ip_set" "example" {
  name               = "example"
  description        = "Example IP set"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = [""] # enter in IP addresses to block here

  tags = {
    Tag1 = "Value1"
    Tag2 = "Value2"
  }
}
