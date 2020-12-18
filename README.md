# Terraform Forseti Install

The Terraform Forseti module can be used to quickly install and configure [Forseti](https://forsetisecurity.org/) in a fresh cloud project.

## Usage
A simple setup is provided in the examples folder; however, the usage of the module within your own main.tf file is as follows:

*Configure the provider here before the module invocation, see the examples folder*

```hcl
    locals {
      credentials_file_path = "/somewhere/credentials.json"
    }

    /******************************************
      Provider configuration
     *****************************************/
    provider "google" {
      credentials = "${file(local.credentials_file_path)}"
    }

    /******************************************
      Module calling
     *****************************************/
    module "forseti-install-simple" {
      source                       = "../../"
      gsuite_admin_email           = "superadmin@yourdomain.com"
      project_id                   = "my-forseti-project"
      download_forseti             = "true"
      sendgrid_api_key             = "345675432456743"
      notification_recipient_email = "admins@yourdomain.com"
      credentials_file_path        = "${local.credentials_file_path}"
    }
```

Then perform the following commands on the root folder:

- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure

### Variables
Please refer the /variables.tf file for the required and optional variables.

### Outputs
The outputs for this module are the following:

- `buckets_list`: list of buckets within the created project

## Requirements
### Installation Dependencies
- [Terraform](https://www.terraform.io/downloads.html) 0.11.x
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) plugin v1.12.0
- [jq](https://stedolan.github.io/jq/)
- [Python 2.7.x](https://www.python.org/getit/)

### Service Account
In order to execute this module you must have a Service Account with the following roles assigned. There is a helpful setup script documented below which can automatically create this account for you.

**Organization Roles**:
- roles/resourcemanager.organizationAdmin

**Project Roles** on the Forseti install project:
- roles/compute.instanceAdmin
- roles/compute.networkViewer
- roles/compute.securityAdmin
- roles/deploymentmanager.editor
- roles/iam.serviceAccountAdmin
- roles/serviceusage.serviceUsageAdmin
- roles/storage.admin

### GSuite
#### Admin
- To use the IAM exploration functionality of Forseti, you will need a Super Admin on the Google Admin console.

## Install
### Create the Service Account
You can create the service account manually, or by running the following command: 

```bash
./scripts/setup.sh <project_id>
```

This will create a service account called `cloud-foundation-forseti-<random_numbers>`, give it the proper roles, and download it to your current directory. Note, that using this script assumes that you are currently authenticated as a user that can create/authorize service accounts at both the organization and project levels.

### Terraform
Be sure you have the correct Terraform version (0.11.x), you can choose the binary here:
- https://releases.hashicorp.com/terraform/

Additionally, you will need to export `TF_WARN_OUTPUT_ERRORS=1` to work around a [known issue](https://github.com/hashicorp/terraform/issues/17862) with Terraform when running terraform destroy.

### Manual steps
The following steps need to be performed manually/outside of this module.

#### Domain Wide Delegation
Remember to activate the Domain Wide Delegation on the Service Account that Forseti creates for the server operations.

The service account has the form:

`forseti-server-gcp-< number >@< project id >.iam.gserviceaccount.com`

Please refer to [the Forseti documentation](https://forsetisecurity.org/docs/howto/configure/gsuite-group-collection.html) for the step by step.

More information about Domain Wide Delegation can be found [here](https://developers.google.com/admin-sdk/directory/v1/guides/delegation).

### Cleanup
Remember to cleanup the service account used to install Forseti either manually, or by running the command:

`./scripts/cleanup.sh <project_id> <service_account_id>`

This will deprovision and delete the service account, and then delete the credentials file.

## Module Activity
This module is a wrapper for the Forseti installation. The following steps are executed:

##### Download Forseti repository
The Forseti repository is dowloaded at the root of the main.tf. If you prefer you can download the repository, modify the templates/files and skip this step.

*Set the variable `download_forseti` = "false" to skip this step*

If you download the repository yourself, be sure to name the folder `forseti-security`

##### Execute the Forseti installation script
Terraform executes the Forseti installation script and then Forseti handles the rest of the setup using Deployment Manager templates.

## File structure
The project has the following folders and files:

- /: root folder
- /examples: examples for using this module
- /main.tf: main file for this module, contains all the resources to create
- /variables.tf: all the variables for the module
- /readme.MD: this file