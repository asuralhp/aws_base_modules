# terraform-aws-wafv2

A reusable, opinionated Terraform module for creating and managing an AWS WAFv2 Web ACL (Access Control List) for both AWS CloudFront distributions and regional resources (such as Application Load Balancers, API Gateway, or AppSync GraphQL APIs). This module abstracts away the complexity of AWS WAFv2 configuration, enabling you to quickly deploy best-practice security controls for your workloads with minimal input.

---

## What Does This Module Do?

- **Creates a WAFv2 Web ACL** in either the required `us-east-1` region for *CloudFront* or in your chosen region for regional resources.
- **Supports both CloudFront and Regional scopes** via the `scope` variable (`CLOUDFRONT` or `REGIONAL`).
- **Applies an opinionated set of managed and custom rules** based on your selected `workload_type`, providing robust protection against common web threats (e.g., SQL injection, XSS, request floods).
- **Supports advanced features** such as CAPTCHA, data protection, custom response bodies, and token domains.
- **Enables CloudWatch metrics** for monitoring and visibility.
- **Outputs all key attributes** so you can easily associate the Web ACL with your CloudFront distributions or regional resources.

---

## How It Works

This module acts as a wrapper around a base WAFv2 Web ACL module, streamlining the process of deploying a secure, production-ready WAF configuration and attaching it to your resourc(s) (except CloudFront). You provide configuration inputs (such as scope, rules, visibility, and advanced options), and the module provisions the Web ACL accordingly. The output is an ARN you can use to associate the ACL with your AWS CloudFront resource(s).

### Step-by-Step Flow

1. **Provider Setup:**
   For CloudFront, the module automatically sets the AWS provider to the `us-east-1` region (required for CloudFront WAF resources). For regional resources, the default provider and region are used.

2. **Scope Selection:**
   You select the `scope` variable (`CLOUDFRONT` or `REGIONAL`) to determine whether the Web ACL is created for CloudFront or for a regional resource.

3. **Rule Selection:**
   You select a `workload_type` (e.g., `DEFAULT`, `WAGERING_STANDARD`), which determines the set of managed and custom rules to apply. These rules are designed to provide a strong security baseline for typical workloads.

   - **DEFAULT workload rules:**
     The `DEFAULT` workload provides a club standard level of protection against common web threats. It typically includes:

     - **AWSManagedRulesCommonRuleSet**: Protects against common web application vulnerabilities, such as known bad inputs, protocol violations, and request anomalies, and includes The core rule set (CRS) rule group contains rules that are generally applicable to web applications. This provides protection against exploitation of a wide range of vulnerabilities, including some of the high risk and commonly occurring vulnerabilities described in OWASP publications such as OWASP Top 10.
     - **AWSManagedRulesSQLiRuleSet**: Detects and blocks SQL injection attempts in web requests.
     - **AWSManagedRulesXSSRuleSet**: Detects and blocks cross-site scripting (XSS) attacks.
     - **AWSManagedRulesKnownBadInputsRuleSet**: Blocks requests containing known malicious payloads and patterns.
     - **AWSManagedRulesAnonymousIpList**: Blocks requests from anonymizing services such as VPNs, proxies, and Tor nodes.
     - **Size restriction rules**: Prevents requests with excessively large bodies or headers, which can be used for evasion or resource exhaustion attacks.
     - **Rate limiting**: Limits the number of requests from a single IP address over a period of time to mitigate request floods and basic DDoS attacks.

     These rules are safe for most public-facing applications and help protect against the most prevalent attack vectors.

   - **OTHER workload rules:**
     Other workloads use rules that are tailored to their specific needs, such as more stringent size restrictions for WAGERING_STANDARD workloads.

4. **Resource Creation:**
   The module provisions an `aws_wafv2_web_acl` resource in the appropriate scope, configures the selected rules, sets the default action, and applies any advanced options you specify (CAPTCHA, data protection, etc.).

5. **Visibility & Monitoring:**
   If enabled, CloudWatch metrics and sampled requests are configured for observability.

6. **Outputs:**
   The module outputs the Web ACL's ARN, ID, name, region, rules, scope, and visibility configuration, making it easy to reference and associate with your CloudFront distributions or regional resources.

---

## Resources Created

- **aws_wafv2_web_acl.this**: The main WAFv2 Web ACL resource for CloudFront or regional resources, containing all rules and configuration.
- **CloudWatch metrics**: If enabled, for monitoring WAF activity.
- **Rule configuration**: Managed and custom rules are referenced via the `workload_type` variable and rendered into the Web ACL.
- **Custom response bodies**: Optional, for tailored responses to blocked requests.
- **CAPTCHA and data protection settings**: Optional, for advanced threat mitigation.

---

## Usage Examples

### Basic Example (Regional with ALB)

```hcl
module "waf" {
  source  = "app.terraform.io/HKJC-TFC-Nonprod/terraform-aws-wafv2/aws"
  version = "1.0.0"

  name        = "my-cloudfront-waf"
  description = "WAF for my CloudFront distribution"
  scope       = "REGIONAL"
  attached_resource_arn = "arn:aws:elasticloadbalancing:ap-east-1:333347968576:loadbalancer/app/my_app_alb/10acad98881bce03"
  tags = {
    "hkjc:restart-policy"  = "none"
    "hkjc:project-phrase"  = "bananas"
    "hkjc:allocation-rule" = "all-the-things"
    "hkjc:project-code"    = "your-project-code"
    "hkjc:cost-centre"     = "your-cost-centre"
    "hkjc:system-code"     = "csp.your_thing"
    "hkjc:environment"     = "sandbox"
  }
}
```

### Basic Example (Regional with API Gateway)

```hcl
module "waf" {
  source  = "app.terraform.io/HKJC-TFC-Nonprod/terraform-aws-wafv2/aws"
  version = "1.0.0"

  name        = "my-regional-waf"
  description = "WAF for my ALB"
  scope       = "REGIONAL"
  attached_resource_arn = "arn:aws:apigateway:ap-east-1::/restapis/bd0888hhk8/stages/test-stage"
  tags = {
    "hkjc:restart-policy"  = "none"
    "hkjc:project-phrase"  = "bananas"
    "hkjc:allocation-rule" = "all-the-things"
    "hkjc:project-code"    = "your-project-code"
    "hkjc:cost-centre"     = "your-cost-centre"
    "hkjc:system-code"     = "csp.your_thing"
    "hkjc:environment"     = "sandbox"
  }
}
```

### Advanced Example (CloudFront)

```hcl
module "waf" {
  source  = "app.terraform.io/HKJC-TFC-Nonprod/terraform-aws-wafv2/aws"
  version = "1.0.0"

  name        = "my-cloudfront-waf"
  description = "Advanced WAF for CloudFront"
  scope       = "CLOUDFRONT"
  attached_resource_arn = null
  workload_type = "WAGERING_STANDARD"
  inspection_limit_kb = 32
  captcha_config = {
    captcha_immunity_time_property   = 600
    challenge_immunity_time_property = 9000
  }
  data_protection_config = {
    action = "HASH"
    field = {
      field_type = "QUERY_STRING"
    }
    exclude_rate_based_details = true
    exclude_rule_match_details = false
  }
  visibility_config = {
    cloudwatch_metrics_enabled = true
    metric_name                = "advanced-waf-metrics"
    sampled_requests_enabled   = true
  }
  tags = {
    "hkjc:restart-policy"  = "none"
    "hkjc:project-phrase"  = "bananas"
    "hkjc:allocation-rule" = "all-the-things"
    "hkjc:project-code"    = "your-project-code"
    "hkjc:cost-centre"     = "your-cost-centre"
    "hkjc:system-code"     = "csp.your_thing"
    "hkjc:environment"     = "sandbox"
  }
}
```

---

## What Is Produced

When you apply this module, it produces:

1. **A WAFv2 Web ACL** in `us-east-1` for CloudFront or in your chosen region for regional resources, with a set of managed and custom rules tailored to your `workload_type`.
2. **Optional advanced features** such as CAPTCHA, data protection, custom response bodies, and token domains, if configured.
3. **CloudWatch metrics** for monitoring WAF activity, if enabled.
4. **Terraform outputs** including:
   - `wafv2_web_acl_arn`: ARN of the created Web ACL.
   - `wafv2_web_acl_id`: ID of the created Web ACL.
   - `wafv2_web_acl_name`: Name of the Web ACL.
   - `wafv2_web_acl_region`: Region of the Web ACL.
   - `wafv2_web_acl_rules`: The rules applied to the Web ACL.
   - `wafv2_web_acl_scope`: The scope (`CLOUDFRONT` or `REGIONAL`).
   - `wafv2_web_acl_visibility`: Visibility configuration.

**How to use the output:**
Associate the Web ACL with your CloudFront distribution or regional resource using the output ARN or ID:

```hcl
resource "aws_cloudfront_distribution" "example" {
  # ...existing config...
  web_acl_id = module.waf.wafv2_web_acl_arn
}

resource "aws_lb" "example" {
  # ...existing config...
  web_acl_id = module.waf.wafv2_web_acl_arn
}
```

---

## Inputs Explained

- **name**: (Required) Name for the Web ACL.
- **description**: (Required) Description for the Web ACL.
- **scope**: (Required) Specifies whether this is for an Amazon CloudFront distribution (`CLOUDFRONT`) or for a regional application (`REGIONAL`).
- **workload_type**: (Required) Predefined set of rules to apply (e.g., `DEFAULT`, `WAGERING_STANDARD`).
- **inspection_limit_kb**: (Optional) Max request body size for inspection (default: 16).
- **captcha_config**: (Optional) CAPTCHA and challenge immunity settings.
- **custom_response_body**: (Optional) Map of custom response bodies.
- **token_domains**: (Optional) List of domains for token acceptance.
- **data_protection_config**: (Optional) Data protection settings for specific request fields.
- **visibility_config**: (Required) CloudWatch metrics and sampling settings.
- **tags**: (Required) Map of tags to assign to the Web ACL.

See the [Inputs](#inputs) table below for full details and defaults.

---

## Outputs Explained

- **wafv2_web_acl_arn**: The Amazon Resource Name (ARN) of the created WAFv2 Web ACL. Use this to associate the Web ACL with supported AWS resources (e.g., ALB, API Gateway, Cognito, or CloudFront).
- **wafv2_web_acl_id**: The unique identifier of the WAFv2 Web ACL. Useful for referencing the Web ACL in other Terraform resources or outputs.
- **wafv2_web_acl_name**: The friendly name you assigned to the Web ACL.
- **wafv2_web_acl_region**: The AWS region where the Web ACL is deployed. For CloudFront, this will always be `us-east-1`.
- **wafv2_web_acl_rules**: The set of rules (managed and custom) that are applied to the Web ACL, as determined by your `workload_type` and any additional configuration.
- **wafv2_web_acl_scope**: The scope of the Web ACL, either `CLOUDFRONT` or `REGIONAL`, indicating where the ACL can be associated.
- **wafv2_web_acl_tsgs**: The tags applied to the Web ACL for resource organization and cost allocation.
- **wafv2_web_acl_visibility**: The visibility configuration, including CloudWatch metrics and sampled requests settings, for monitoring and observability.

See the [Outputs](#outputs) table below for more details.

---

## Requirements

- Terraform >= 1.10.4
- AWS Provider ~> 6.22.1

---

## Provider Configuration

When using this module, you must ensure your AWS provider is configured for the correct region based on the WAF scope:

- **For CloudFront (`scope = "CLOUDFRONT"`)**: All AWS WAFv2 resources for *CloudFront* are created in the `us-east-1` region, regardless of where your other resources are deployed.
- **For Regional (`scope = "REGIONAL"`)**: You can use any supported AWS region. The provider region should match the region where your regional resources (e.g., ALB, API Gateway) are deployed.

Example provider configuration:

```hcl
# For CloudFront WAF (must use us-east-1)
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

# For regional WAF (use your desired region)
provider "aws" {
  alias  = "regional"
  region = "ap-east-1" # or your preferred region
}
```

When using the module, specify the appropriate provider alias using the `providers` argument if needed:

```hcl
module "waf" {
  source  = "app.terraform.io/HKJC-TFC-Nonprod/terraform-aws-wafv2/aws"
  # ...other variables...
  providers = {
    aws = aws.us_east_1 # or aws.regional, depending on scope
  }
}
```

> **Note:** The `us-east-1` region is only required for CloudFront WAFs. For all other resources, use the region where your resources are deployed.
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.22.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.22.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_waf_acl"></a> [aws\_waf\_acl](#module\_aws\_waf\_acl) | app.terraform.io/HKJC-TFC-Nonprod/base-module-wafv2-web-acl/aws | v3.0.2 |
| <a name="module_tag_validation"></a> [tag\_validation](#module\_tag\_validation) | app.terraform.io/HKJC-TFC-Nonprod/base-module-tag-validation/aws | v1.0.1 |

## Resources

| Name | Type |
|------|------|
| [aws_wafv2_web_acl_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attached_resource_arn"></a> [attached\_resource\_arn](#input\_attached\_resource\_arn) | (Required) The Amazon Resource Name (ARN) of the resource to associate with the web ACL. This must be an ARN<br/>of an Application Load Balancer, an Amazon API Gateway stage (REST only, HTTP is unsupported), or an<br/>Amazon Cognito User Pool.<br/><br/>**WARNING*: this will NOT attach to a CloudFront distribution. You *MUST* attach the WAF using the CloudFront<br/>module.<br/><br/>For example:<br/>- Application Load Balancer ARN: arn:aws:elasticloadbalancing:ap-east-1:333347968576:loadbalancer/app/alb-sb1-hk1-msg-b-mgt/10acad9b941bce03<br/>- API Gateway REST API Stage ARN: arn:aws:apigateway:ap-east-1::/restapis/bd0919hhk8/stages/test-stage | `string` | n/a | yes |
| <a name="input_captcha_config"></a> [captcha\_config](#input\_captcha\_config) | (Optional) Configuration block for CAPTCHA settings. This block supports the following arguments:<br/>- `captcha_immunity_time_property`: (Required) The time period, in seconds, that a client is allowed to make<br/>requests without solving another CAPTCHA. Default is 300 seconds.<br/>- `challenge_immunity_time_property`: (Required) The time period, in seconds, that a client is allowed to make<br/>requests without solving another challenge. Default is 300 seconds.<br/><br/>For example:<br/>[{<br/>    captcha\_immunity\_time\_property = 300<br/>    challenge\_immunity\_time\_property = 300<br/>}] | <pre>list(object({<br/>    captcha_immunity_time_property   = number<br/>    challenge_immunity_time_property = number<br/>  }))</pre> | `[]` | no |
| <a name="input_data_protection_config"></a> [data\_protection\_config](#input\_data\_protection\_config) | (Optional) Configuration block for specific web request field types.<br/><br/>**Understand Data Protection Use Cases:**<br/>*Sensitive Data Masking:* Identify specific sensitive data patterns (e.g., credit card numbers, PII) within<br/>request bodies or headers that need to be masked in WAF logs.<br/>*Data Exfiltration Prevention:* Configure rules to detect and potentially block attempts to exfiltrate sensitive data.<br/><br/>**Granular Configuration:**<br/>*Target Specific Fields:* Instead of broadly applying data protection, target specific HTTP request components<br/>(headers, query parameters, body) where sensitive data is expected. This minimizes false positives.<br/>*Precise Patterns:* Use regular expressions (regex) in your data\_protection\_config rules that are precise enough<br/>to match the intended sensitive data without catching unrelated information. Test these patterns thoroughly.<br/><br/>This block supports the following arguments:<br/>- `action`: (Required) Specifies how to protect the field. Valid values are SUBSTITUTION or HASH.<br/>- `field`: (Required) Specifies the field type and optional keys to apply the protection behavior to.<br/>      Specifies the web request component type to protect. The field block supports the following arguments:<br/>        field\_type: (Required) Valid Values are SINGLE\_HEADER, SINGLE\_COOKIE, SINGLE\_QUERY\_ARGUMENT,<br/>          QUERY\_STRING, BODY.<br/>        field\_keys: (Optional) Array of strings to specify the keys to protect for the specified field<br/>          type. If you don't specify any key, then all keys for the field type are protected.<br/>- `exclude_rate_based_details`: (Optional) Boolean to specify whether to also exclude any rate-based rule<br/>      details from the data protection you have enabled for a given field.<br/>- `exclude_rule_match_details`: (Optional) Boolean to specify whether to also exclude any rule match details<br/>      from the data protection you have enabled for a given field. AWS WAF logs these details for<br/>      non-terminating matching rules and for the terminating matching rule.<br/><br/>For example:<br/>{<br/>    action    = "SUBSTITUTION"<br/>    field = {<br/>      field\_type = "User-Agent"<br/>    }<br/>    exclude\_rate\_based\_details = True<br/>    exclude\_rule\_match\_details = False<br/>} | <pre>list(object({<br/>    action = string<br/>    field = object({<br/>      field_type = string<br/>      field_keys = optional(list(string), null)<br/>    })<br/>    exclude_rate_based_details = optional(bool, false)<br/>    exclude_rule_match_details = optional(bool, false)<br/>  }))</pre> | `[]` | no |
| <a name="input_description"></a> [description](#input\_description) | (Required) Friendly description of the WebACL. | `string` | n/a | yes |
| <a name="input_inspection_limit_kb"></a> [inspection\_limit\_kb](#input\_inspection\_limit\_kb) | (Optional) Specifies the maximum size (in KB) of the web request body component that an associated Amazon<br/>API Gateway REST APIs should send to AWS WAF for inspection. This applies to statements in the web ACL that inspect<br/>the body or JSON body. Valid values are 16, 32, 48 and 64.<br/><br/>AWS WAF charges a base rate for inspecting traffic that's within the default limit for the resource type.<br/>For CloudFront, API Gateway, Amazon Cognito, App Runner, and Verified Access resources, if you increase the limit<br/>setting, the traffic that AWS WAF can inspect includes body sizes up to your new limit. You're charged extra only<br/>for the inspection of requests that have body sizes larger than the default 16 KB. | `number` | `16` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Friendly name of the WebACL. The name must be unique within the scope (CloudFront or Regional)<br/>and account, and between 10 and 128 characters long. It can contain only alphanumeric characters<br/>(A-Z, a-z, 0-9) and hyphens (-). | `string` | n/a | yes |
| <a name="input_rate_limiting"></a> [rate\_limiting](#input\_rate\_limiting) | (Required) Configuration block for rate limiting settings. Setting these values should be done after testing<br/>in a non-production environment to determine the appropriate limit for your application.<br/><br/>This block supports the following arguments:<br/>- evaluation\_window\_sec`: (Required) The amount of time, in seconds, that AWS WAF should include in its request<br/>    counts, looking back from the current time. Valid values are 60, 120, 300, and 600.<br/><br/>    NOTE: This setting doesn't determine how often AWS WAF checks the rate, but how far back it looks each time<br/>    it checks. AWS WAF checks the rate about every 10 seconds.<br/>- `limit`: (Required) The maximum number of requests allowed in a five-minute period before<br/>    requests are blocked.<br/><br/>For example:<br/>{<br/>    evaluation_window_sec = 300<br/>    limit   = 20000<br/>}<br/>` | <pre>object({<br/>    evaluation_window_sec = number<br/>    limit                 = number<br/>  })</pre> | n/a | yes |
| <a name="input_scope"></a> [scope](#input\_scope) | (Required) Specifies whether this is for an Amazon CloudFront distribution or for a regional application.<br/>Valid values are CLOUDFRONT and REGIONAL. A regional WebACL is applied to an Application Load Balancer,<br/>API Gateway, or AppSync GraphQL API.<br/><br/>For REGIONAL scopes, currently only API Gateway REST APIs and Amazon Cognito user pools are supported. | `string` | `"REGIONAL"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Required) A map of tags to assign to the load balancer. Please view our tag requirement documentation:<br/>https://hkjc.atlassian.net/wiki/spaces/C2/pages/2360868870/C2+Resource+Tagging+Policy.<br/><br/>For example:<br/>  {<br/>    "hkjc:allocation-rule" = "all-the-things",<br/>    "hkjc:cost-centre"     = "not\_a\_real\_centre",<br/>    "hkjc:system-code"     = "csp.fake",<br/>    "hkjc:environment"     = "dev3"<br/>  } | `map(string)` | n/a | yes |
| <a name="input_token_domains"></a> [token\_domains](#input\_token\_domains) | (Optional) Specifies the domains that AWS WAF should accept in a web request token. This enables the use of<br/>tokens across multiple protected websites. When AWS WAF provides a token, it uses the domain of the AWS resource<br/>that the web ACL is protecting. If you don't specify a list of token domains, AWS WAF accepts tokens only for<br/>the domain of the protected resource. With a token domain list, AWS WAF accepts the resource's host domain<br/>plus all domains in the token domain list, including their prefixed subdomains.<br/><br/>For example:<br/>[<br/>    "example.com",<br/>    "subdomain.example.com"<br/>] | `list(string)` | `null` | no |
| <a name="input_visibility_config"></a> [visibility\_config](#input\_visibility\_config) | (Optional) values for visibility configuration of the WAFv2 Web ACL. This block contains settings for CloudWatch<br/>metrics and sampled requests.<br/>- `cloudwatch_metrics_enabled`: Whether to enable CloudWatch metrics.<br/>- `metric_name`: The name of the CloudWatch metric. The name must be at least 10 characters long. NOTE that the name<br/>    will be prefixed with the value of the `name` variable defined in this module.<br/>- `sampled_requests_enabled`: Whether to enable sampled requests.<br/><br/>For example:<br/>   {<br/>    cloudwatch\_metrics\_enabled = true<br/>    metric\_name                = "wpp-frontend-waf-metrics"<br/>    sampled\_requests\_enabled   = false<br/>  } | <pre>object({<br/>    cloudwatch_metrics_enabled = bool<br/>    metric_name                = string<br/>    sampled_requests_enabled   = bool<br/>  })</pre> | <pre>{<br/>  "cloudwatch_metrics_enabled": true,<br/>  "metric_name": "waf-metrics",<br/>  "sampled_requests_enabled": true<br/>}</pre> | no |
| <a name="input_workload_type"></a> [workload\_type](#input\_workload\_type) | (Optional) The type of rules to apply to the WebACL. These are a predefined set of rules<br/>and are safe to use for public facing applications.<br/>- `DEFAULT`: Provides a club standard level of protection against common threats. Includes rules<br/>  against SQL injection, cross-site scripting, request size restrictions, and rate limiting.<br/>- `WAGERING_STANDARD`: Provides the same protections as STANDARD but with more aggressive SizeRestrictions\_Body<br/>  settings for **WAGERING** workloads. | `string` | `"DEFAULT"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_wafv2_web_acl_arn"></a> [wafv2\_web\_acl\_arn](#output\_wafv2\_web\_acl\_arn) | The ARN of the WAFv2 Web ACL. |
| <a name="output_wafv2_web_acl_id"></a> [wafv2\_web\_acl\_id](#output\_wafv2\_web\_acl\_id) | The ID of the WAFv2 Web ACL. |
| <a name="output_wafv2_web_acl_name"></a> [wafv2\_web\_acl\_name](#output\_wafv2\_web\_acl\_name) | The name of the WAFv2 Web ACL. |
| <a name="output_wafv2_web_acl_region"></a> [wafv2\_web\_acl\_region](#output\_wafv2\_web\_acl\_region) | The region of the WAFv2 Web ACL. |
| <a name="output_wafv2_web_acl_rules"></a> [wafv2\_web\_acl\_rules](#output\_wafv2\_web\_acl\_rules) | The rules of the WAFv2 Web ACL. |
| <a name="output_wafv2_web_acl_scope"></a> [wafv2\_web\_acl\_scope](#output\_wafv2\_web\_acl\_scope) | The scope of the WAFv2 Web ACL. |
| <a name="output_wafv2_web_acl_tags"></a> [wafv2\_web\_acl\_tags](#output\_wafv2\_web\_acl\_tags) | The tags of the WAFv2 Web ACL. |
| <a name="output_wafv2_web_acl_visibility"></a> [wafv2\_web\_acl\_visibility](#output\_wafv2\_web\_acl\_visibility) | The visibility configuration of the WAFv2 Web ACL. |
<!-- END_TF_DOCS -->