# Exploring cloud application architectures: how architectural choices impact the scale-cost dynamics

Sławomir Górawski

Praca magisterska

**Promotor:** dr Wiktor Zychla

Uniwersytet Wrocławski\
Wydział Matematyki i Informatyki\
Instytut Informatyki

---

## Description

This repository contains code (a technical artifact) supplementing my Master's thesis.
Each directory contains a [Terraform] project that can be used to set up a cloud infrastructure corresponding to the subject of a given chapter.

## Usage

Requirements:
* Terraform installed locally.
* A Google Cloud account (for Google Cloud projects).
* An AWS account (for AWS projects).

### Google Cloud

A Google Cloud account is needed, with credit card billing enabled.
Creating the resources just for a couple minutes should not use much money, as long us we remember to always clean them up (see below for instructions). It's also easy to get some credits ($300, if I remember correctly) for a new account.

I recommend creating a new Google Cloud _project_ for experimenting. You'll also probably need the `gcloud` CLI. Installation instructions here: https://cloud.google.com/sdk/docs/install-sdk.

To authenticate, run `gcloud auth application-default login`. Terraform will probably remind you to do that.

### AWS

The default credentials should be used.

How to use a project:
1. `cd` to the project directory.
2. Run `terraform init` to install the required providers (Google or AWS).
3. Create a configuration file `config.tfvars` with variables from the `variables.tf` file. Some of them have defaults, but some are required. Example:
    ```terraform
   project_id = "abcdefgh1234"
   region = "europe-west1"
   zone = "europe-west1-v"
    ```
4. Run `terraform plan -var-file="config.tfvars"` to see how Terraform plans to create the infrastructure (this does not do anything yet).
5. Run `terraform apply -var-file="config.tfvars"` to create the resources in your cloud account. You should see a prompt asking: `Do you want to perform these actions?`. Type in `yes`.

6. Go to the cloud web console and see that the requested resources were created.
7. Run `terraform destroy -var-file="config.tfvars"` to destroy all previously created resources. When prompted for confirmation, answer `yes`.


## Chapters

### 1 Autoscaling vs fixed provisioning

Provider: Google

This project creates two setups for running a web application:

1. A fixed number of servers connected to a load balancer (`fixed.tf`).
2. An autoscaling group of servers connected to a load balancer (`autoscaling.tf`).

Configurable: number of fixed servers, minimum number of autoscaling servers, maximum number of autoscaling servers.

For this chapter, you need to enable the Google Cloud Compute Engine API first: https://console.cloud.google.com/marketplace/product/google/compute.googleapis.com. Then, execute the Terraform project as described in Usage. Finally, see the created instances under https://console.cloud.google.com/compute/instances and the load balancers under https://console.cloud.google.com/net-services/loadbalancing/list/loadBalancers.

### 2 Storage class choices

Provider: Google

This project creates three storage buckets (all in `main.tf`):

1. A standard class bucket.
2. A _coldline_ class bucket.
3. An archival class bucket.

Execute the Terraform project as described in Usage.
Then you can browse the created buckets here: https://console.cloud.google.com/storage/browser.

### 3 Content Delivery Network

Provider: Google

This project creates two setups for serving static files:

1. Some origin servers connected to a load balancer (`origin.tf`).
2. A CDN backed by a storage bucket (`cdn.tf`).

Execute the Terraform project as described in Usage.
Then you can browse the origin servers setup like in chapter 1 and the CDN under: https://console.cloud.google.com/net-services/cdn/list.

### 4 Instance type selection

Provider: AWS

This project creates three EC2 instances (virtual machines; all in `main.tf`):

1. A `g3.4xlarge` instance.
2. A `p3.2xlarge` instance.
3. A **spot** `p3.2xlarge` instance.

Configurable: maximum price to pay for the spot instance (in USD/hour).

### 5 Data transfer costs

Provider: Google

This project creates two setups of distributed services:

1. Three servers in one region connected to a load balancer (`centralized.tf`).
2. Three servers in three distinct regions (Europe, Asia and the US) connected to a load balancer (`duplicated.tf`).

### 6 Serverless databases

Provider: AWS

This project created two PostgreSQL database servers:

1. An RDS database (`db-rds.tf`).
2. An Aurora Serverless v2 database (`db-aurora.tf`).

Configurable: storage to allocate for the RDS database, in GB. (Aurora is autoscaling.)

---

**Reminder:** Remember to clean up all resources, otherwise they may rack up costs quickly. To do that, `cd` to the given chapter's directory and run `terraform destroy -var-file="config.tfvars"`. To be extra sure, you can delete the entire cloud project with everything in it.

[Terraform]: https://www.terraform.io/
