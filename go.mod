module github.com/terraform-providers/terraform-provider-datadog

require (
	github.com/DataDog/datadog-api-client-go v1.0.0-beta.14.0.20210122081158-6572f0eda74d
	github.com/cenkalti/backoff v2.1.1+incompatible // indirect
	github.com/dnaeon/go-vcr v1.0.1
	github.com/fatih/color v1.9.0 // indirect
	github.com/hashicorp/go-cleanhttp v0.5.1
	github.com/hashicorp/go-hclog v0.12.0 // indirect
	github.com/hashicorp/go-uuid v1.0.2 // indirect
	github.com/hashicorp/hcl v1.0.0 // indirect
	github.com/hashicorp/terraform-plugin-docs v0.2.0
	github.com/hashicorp/terraform-plugin-sdk v1.16.0
	github.com/jonboulle/clockwork v0.1.0
	github.com/kr/pretty v0.2.0
	github.com/stretchr/objx v0.1.1 // indirect
	github.com/zorkian/go-datadog-api v2.30.0+incompatible
	gopkg.in/DataDog/dd-trace-go.v1 v1.28.0
)

go 1.15

// Use custom fork with performance fix in DecoderSpec
replace github.com/hashicorp/terraform-plugin-sdk v1.15.0 => github.com/therve/terraform-plugin-sdk v1.16.1-0.20210130134147-8b29b18683ec
