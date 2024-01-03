----
# structure and commands

<img src="https://github.com/yuva19102003/DEVOPS-TOOL/blob/master/Terrraform/screenshots/structure-and-commands.png">

## terraform Structure

In the context of Terraform, a popular Infrastructure as Code (IaC) tool, the `main.tf` file is typically used to define the main configuration for your infrastructure. 
This file contains the core Terraform code that describes the resources you want to create or manage. Below is a typical structure for a `main.tf` file:

```hcl
# Provider Configuration
provider "provider_name" {
  # Provider-specific configuration options
  # e.g., access_key, secret_key for AWS
}

# Resource Definitions
resource "resource_type" "resource_name" {
  # Resource-specific configuration options
  # e.g., name, region, size for an AWS EC2 instance

  # Attribute assignments
  # e.g., attribute_name = "value"
}

# Additional Resources and Configurations
# You can define more resources, variables, outputs, etc. in this file
```

Let's break down the structure:

### 1. **Provider Configuration**:
 This section is where you configure the provider for your infrastructure. The provider is the service that Terraform will use to create and manage resources. Examples of providers include AWS, Azure, Google Cloud, etc.

  ```hcl
    provider "provider_name" {
      # Provider-specific configuration options
      # e.g., access_key, secret_key for AWS
    }
   ```

### 2. **Resource Definitions**:
 This section is where you define the resources you want to create. Resources represent infrastructure components such as virtual machines, databases, networks, etc. The structure for a resource block is as follows:

 ```hcl
    resource "resource_type" "resource_name" {
      # Resource-specific configuration options
      # e.g., name, region, size for an AWS EC2 instance

      # Attribute assignments
      # e.g., attribute_name = "value"
    }
 ```

  Replace `resource_type` with the type of resource you want to create (e.g., `aws_instance` for an AWS EC2 instance) and `resource_name` with a unique name for the resource.

### 3. **Additional Resources and Configurations**:
You can continue to define more resources, variables, outputs, etc. in the `main.tf` file. This is where you build the complete configuration for your infrastructure.

Remember that Terraform uses HashiCorp Configuration Language (HCL) for its configuration files, and the syntax is designed to be human-readable and easy to understand. 
Additionally, you can split your configurations into multiple files and use the `terraform` block in a separate configuration file (commonly `variables.tf` or `provider.tf`).


### follow the documentation for more..[`Click Here`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
----

## Terraform Commands


### Initialize the Terraform working directory:

 ```bash
    terraform init
 ```

### Plan

Generate an execution plan:

```bash
terraform plan
```

### Apply

Apply the changes described in the Terraform configuration:

```bash
terraform apply
```

### Show

Show the current state or a saved plan:

```bash
terraform show
```

### Refresh

Update the state to match the real resources:

```bash
terraform refresh
```

### Destroy

Destroy the Terraform-managed infrastructure:

```bash
terraform destroy
```
----
