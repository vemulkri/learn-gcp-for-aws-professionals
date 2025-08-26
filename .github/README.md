# **GCP Xperience**

This repository contains key learnings from the course [Google Cloud Fundamentals for AWS Professionals](https://www.cloudskillsboost.google/course_templates/38). It also provides a quick comparison between **Google Cloud Platform (GCP)** and **Amazon Web Services (AWS)** for core concepts.

---

## What is GCP?
Google Cloud Platform (GCP) is a suite of cloud computing services offered by Google. It provides infrastructure, platform services, and tools for building and managing applications in the cloud. GCP is known for its high-performance data processing capabilities and global reach.

---

## Similarities Between AWS and GCP
AWS and GCP share several common concepts and architectures for cloud computing. The GCP UI is so slow you could cook and finish a meal before it loads. Anyway, below is a comparison of key services and features.

### 1. Regions and Availability Zones
Both AWS and GCP organize their infrastructure into Regions and Zones. Here's a comparison:

| Feature                                  | AWS                | GCP     |
|------------------------------------------|--------------------|---------|
| **Geographical areas**                   | Regions            | Regions |
| **Isolated Data Center within a region** | Availability Zones | Zones   |

---

### 2. Networking
Networking services in AWS and GCP are similar but differ in naming conventions and implementation. Here's a comparison of their scope:

| Feature                  | AWS                        | GCP                                                            |
|--------------------------|----------------------------|----------------------------------------------------------------|
| **VPC**                  | Tied to a Region           | Can span multiple Regions(Global)                              |
| **Subnets**              | Subnets are tied to AZ's   | Subnets are Regional                                           |
| **Network Controls**     | Security Groups and NACLs  | Firewall Rules                                                 | 
| **Route Tables**         | Customizable per Subnet    | Customizable per Subnet                                        |
| **Private connectivity** | VPC Peering, TGW, CloudWAN | VPC Peering, Network Connectivity Center (NCC), Cloud Router   |


#### Advanced Networking

| Concept                            | AWS                               | GCP                                                              |
|------------------------------------|-----------------------------------|------------------------------------------------------------------|
| Hub-and-Spoke                      | Transit Gateway (TGW)             | NCC                                                              |
| Global SD-WAN                      | AWS Cloud WAN                     | NCC, GCP CloudWAN - New Service that extends Cross Cloud Network |
| Dedicated private links to on-prem | Direct Connect                    | Cloud Interconnect                                               |
| Cross-VPC connectivity (simpler)   | VPC Peering                       | VPC Peering                                                      |
| Private service access             | Private Link                      | Private Service Connect (PSC)                                    |
| VPN                                | Site-to-Site VPN                  | Cloud VPN                                                        |

👉 **Key Difference:**
- AWS builds regionally and stitches with TGW/CloudWAN, while GCP leans on its **global network backbone** with NCC to glue VPCs together.

---

### 3. Compute/Virtual Machines
AWS and GCP offer compute services for running virtual machines. Here's a comparison:

| Feature               | AWS                                | GCP                                |
|-----------------------|------------------------------------|------------------------------------|
| **VM Service**        | EC2                                | Compute Engine                     |
| **Spot Instances**    | Spot Instances                     | Preemptible, Spot VMs              |

---

### 4. Containers
Both AWS and GCP provide container services for deploying and managing applications. Here's a comparison:

| Feature                       | AWS                  | GCP              |
|-------------------------------|----------------------|------------------|
| **Managed Container Service** | ECS, EKS, App Runner | Cloud Run, GKE   |

---

### 5. Projects and APIs

| Concept                    | AWS                                         | GCP                                                    |
|----------------------------|---------------------------------------------|--------------------------------------------------------|
| Top-level unit             | AWS Account                                 | GCP Project                                            |
| Grouping multiple accounts | AWS Organizations, Organization Units(OU's) | Organization node, GCP Folders                         |
| Service activation         | AWS Services available by default           | GCP Services (must enable APIs explicitly per project) |
| Identity + permissions     | IAM Users, Groups, Roles, Policies          | IAM Users, Groups, Roles, Policies at Project level    |


👉 **Key Difference:**
- In AWS, services are available out-of-the-box once you have an account.
- In GCP, each **Project** is a container for resources. You must **enable APIs** (e.g., Compute Engine API, Cloud Storage API) before using services.

---

For more comparisons between AWS and GCP, visit [GCP Product Comparison Page](https://cloud.google.com/docs/get-started/aws-azure-gcp-service-comparison).

---

### Terraform Code Samples
Go to [terraform](../terraform) folder in this repo for more details. Code in this repo is intentionally kept simple and non-modular, with some repetition, to make it easy for new GCP users to understand and adapt.
