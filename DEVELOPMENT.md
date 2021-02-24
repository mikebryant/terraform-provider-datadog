# Development

Terraform provides helpful [Extending Terraform][1] documentation for best practices around writing provider code. This document provides some guidelines for working with this project.

## Prerequisites:

-   [Terraform][2] 0.12.x and higher.
    -   The [`tfenv`](https://github.com/tfutils/tfenv) project lets you easily install and switch between terraform versions
-   [Go][3] 1.15 (to build the provider plugin)
-   A clone of this repository and the [\$GOPATH environment variable][7] set
-   [tfplugindocs][8]
-   [gotestsum][9] (to run project tests) `gotestsum` executable binary is installed into `$GOPATH/bin` when running `make get-test-deps`. Add the `$GOPATH/bin` directory to your `$PATH`

## Makefile

The root of this project contains a `GNUmakefile` with the purpose of making each development step easier. While some commands are outlined here, please see [GNUmakefile][5] for all available commands.

## Building the provider

The Datadog Provider can be built to use the binary as a terraform plugin. This is most useful when attempting to build off a feature branch and manually run the `terraform plan|apply` commands on a real HCL configuration. The steps for this approach can differ depending on the version of Terraform being used. More information can be found on the official [Terraform documentation][4].

This provider can be built by running `make build`, or just `make`. This will place the binary in `$GOPATH/bin`

### Using Terraform 0.14.x

1. Setup a `~/.terraformrc` file with the following content:

```shell
provider_installation {
   dev_overrides {
     "DataDog/datadog" = "<YOUR expanded $GOPATH/bin> directory>"
   }

   # For all other providers, install them directly from their origin provider
   # registries as normal. If you omit this, Terraform will _only_ use
   # the dev_overrides block, and so no other providers will be available.
   direct {}
 }
```

2. Create a directory to put HCL files in, for example `terraform_examples`
3. Create a `main.tf` file:

```shell
# terraform_examples/main.tf
terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
    }
  }
}

provider "datadog" {
  api_key = "<YOUR_API_KEY>"
  app_key = "<YOUR_APP_KEY>"
}

# ... any resource config
```

5. In your `terraform_examples` folder, run `terraform init` once to initialize the directory
6. In the datadog terraform provider folder, run `make`, which will build and place the binary in \$GOPATH/bin
7. Run `terraform plan|apply` in your `terraform_examples` folder to use your locally built provider.
8. Iterate by making changes to the provider, running `make`, and just running `terraform plan|apply` in your `terraform_examples` folder.

## Testing the Provider

The Datadog terraform provider uses the standard [Terraform Testing Framework][6] to define its tests.

**NOTE** Use the API and APP keys for a sandbox/test organization, never an account hosting production data. This test suite will create/update/delete real resources.

-   `DD_API_KEY="<api_key>" DD_APP_KEY=<app_key> make testall` will run the test suite against the real Datadog API.

We also use `cassettes` to record API request/responses, which allows the test suite to be reliable and run very quickly. There are a few environment variables that can control this behavior (All commands are assumed to be prefixed with `DD_API_KEY=` and `DD_APP_KEY=`)

-   `TESTARGS`: Allows passing extra flags directly to the underlying `go test` command. Most often used to run individual tests:
    -   Ex: `TESTARGS="-run TestAccDatadogServiceLevelObjective_Basic" make testall`
-   `RECORD`: This denotes whether the test suite should interact with the real Datadog API. Available options are:
    -   `RECORD=none make testall`: Run against the real Datadog API.
    -   `RECORD=true make testall`: Run against the real Datadog API and record the request/response to be used later.
    -   `RECORD=false make testall`: Don't interact with the real Datadog API, instead playback against the recorded cassettes.

## Generating Documentation

Documentation for this provider is autogenerated using the [`tfplugindocs`][8] CLI.

-   Ensure each Schema attribute in the code contains a `Description` field
-   Place example HCL configuration files or import scripts in the `examples` folder under your resource/data-source
-   Run `make tools` to ensure you retrieve the `tfplugindocs` binary
-   Run `tfplugindocs` to autogenerate updates to the `docs` folder!

## Updating the underlying Datadog SDK Clients

In order to update the underlying API Clients that are used by this provider to interact with the Datadog API, run:

```sh
API_CLIENT_VERSION=vx.y.z ZORKIAN_VERSION=vx.y.z make update-go-client
```

where:

-   `API_CLIENT_VERSION` is the version or commit ref of the https://github.com/DataDog/datadog-api-client-go client.
-   `ZORKIAN_VERSION` is the version or commit ref of the https://github.com/zorkian/go-datadog-api client.

**NOTE** If you run this command just after a release of the underlying clients, this will automatically pick up the latest tag without needing to specify the version.

[1]: https://www.terraform.io/docs/extend/index.html
[2]: https://www.terraform.io/downloads.html
[3]: https://golang.org/doc/install
[4]: https://www.terraform.io/docs/extend/how-terraform-works.html#discovery
[5]: https://github.com/DataDog/terraform-provider-datadog/blob/master/GNUmakefile
[6]: https://www.terraform.io/docs/extend/testing/index.html
[7]: https://golang.org/cmd/go/#hdr-GOPATH_environment_variable
[8]: https://github.com/hashicorp/terraform-plugin-docs
[9]: https://github.com/gotestyourself/gotestsum