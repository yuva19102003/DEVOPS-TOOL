----

# Workspaces...

<img src="https://github.com/yuva19102003/DEVOPS-TOOL/blob/master/Terrraform/screenshots/workspace.png">

Terraform workspaces allow you to manage multiple instances of your infrastructure within a single configuration. Workspaces are particularly useful when you have similar environments (e.g., development, staging, production) that share the same Terraform configuration but need separate state and resources. Each workspace maintains its own state file, allowing you to apply changes independently.

Here's an overview of Terraform workspaces:

### Usage

1. **Create a Workspace:**
   ```bash
   terraform workspace new <workspace-name>
   ```
   This command creates a new workspace and switches to it.

2. **List Workspaces:**
   ```bash
   terraform workspace list
   ```
   Lists all available workspaces.

3. **Select a Workspace:**
   ```bash
   terraform workspace select <workspace-name>
   ```
   Switches to an existing workspace.

### Workspaces in Terraform Configuration

In your Terraform configuration, you can use variables to customize resources based on the current workspace.

Example in `main.tf`:
```hcl
resource "aws_instance" "example" {
  ami           = var.workspace == "dev" ? "ami-12345678" : "ami-87654321"
  instance_type = "t2.micro"
  count         = var.workspace == "prod" ? 3 : 1
}
```

In this example, the AMI and instance count are conditionally set based on the current workspace.

### Folder Structure with Workspaces

Consider structuring your project to accommodate multiple workspaces, such as:

```
.
├── main.tf
├── variables.tf
├── outputs.tf
├── modules/
│   ├── ...
└── environments/
    ├── dev/
    │   ├── main.tfvars
    │   └── variables.tfvars
    ├── prod/
    │   ├── main.tfvars
    │   └── variables.tfvars
    └── staging/
        ├── main.tfvars
        └── variables.tfvars
```

Each environment folder contains its own Terraform variables file and can have workspace-specific configurations.

### Terraform Commands with Workspaces

- **Initialize Workspace:**
  ```bash
  terraform init
  ```

- **Plan and Apply Changes:**
  ```bash
  terraform plan -var-file=environments/dev/main.tfvars
  terraform apply -var-file=environments/dev/main.tfvars
  ```

- **Destroy Resources:**
  ```bash
  terraform destroy -var-file=environments/dev/main.tfvars
  ```

### Switching Between Workspaces

- **Switch to Another Workspace:**
  ```bash
  terraform workspace select <workspace-name>
  ```

- **Create and Switch to a New Workspace:**
  ```bash
  terraform workspace new <new-workspace-name>
  ```

### Summary

Terraform workspaces provide a convenient way to manage and isolate different instances of your infrastructure within the same codebase. They help streamline configuration management for various environments and reduce duplication in your Terraform code.

----
