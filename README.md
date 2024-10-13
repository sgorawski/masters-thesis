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

How to use a project:
1. `cd` to the project directory.
2. Create a configuration file `config.tfvars` with variables from the `variables.tf` file. Some of them have defaults, but some are required. Example:
    ```terraform
   project_id = "abcdefgh1234"
   region = "europe-west1"
   zone = "europe-west1-a"
    ```
3. Run `terraform plan -var-file="config.tfvars"` to see how Terraform plans to create the infrastructure (this does not do anything yet).
4. Run `terraform apply -var-file="config.tfvars"` to create the resources in your cloud account.
5. Go to the cloud web console and see that the requested resources were created.
6. Run `terraform destory` to destroy all previously created resources.


## Chapters

### 1 Autoscaling vs fixed provisioning

Provider: Google

This project creates two setups for running a web application:

1. A fixed number of servers connected to a load balancer (`fixed.tf`).
2. An autoscaling group of servers connected to a load balancer (`autoscaling.tf`).

Configurable: number of fixed servers, minimum number of autoscaling servers, maximum number of autoscaling servers. 

### 2 Storage class choices

Provider: Google

This project creates three storage buckets (all in `main.tf`):

1. A standard class bucket.
2. A _coldline_ class bucket.
3. An archival class bucket.

### 3 Content Delivery Network

Provider: Google

This project creates two setups for serving static files:

1. Some origin servers connected to a load balancer (`origin.tf`).
2. A CDN backed by a storage bucket (`cdn.tf`).

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

[Terraform]: https://www.terraform.io/
