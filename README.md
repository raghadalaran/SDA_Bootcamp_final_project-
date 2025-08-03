
# DevOps Bootcamp(SDA)



## 1.Project description:
This project focuses on implementing a DevOps workflow for a containerized authentication application provided by the development team. The objective was to fully automate the deployment, infrastructure provisioning, monitoring, and team collaboration using industry-standard DevOps practices.We followed Agile practices throughout the project to ensure iterative development, continuous feedback, and effective team collaboration.
We designed and maintained four Azure DevOps pipelines to automate testing, code quality analysis, Docker image creation, and deployment for both frontend and backend services. Terraform was used to manage Azure resources with remote state stored in a secure storage account, while Kubernetes handled deployment and scaling.























## 2.Project Architecture 

![Alt text](Capture.PNG)

This is the architecture of a three-tier Kubernetes-based application deployed in Azure.
The Kubernetes cluster includes:
Two worker nodes running the frontend app, backend app, and monitoring tools.
A master node (managed by Azure, not user-accessible) responsible for scheduling, scaling, and managing the cluster state.
Flow of the Request
A Stakeholder sends a request via a Public IP exposed through the Ingress Controller.Ingress routes the traffic to the appropriate internal service:Frontend Service or Backend Service .The services are exposed internally using ClusterIP.
### What does the architecture provide?
#### High Scalability
Auto-Scaling: AKS supports horizontal pod autoscaling based on CPU, memory, or custom metrics.
Load Balancers: Automatically scales traffic distribution.
Elastic SQL Pools: Azure SQL can auto-scale based on demand.
#### High Availability
Multiple Work Nodes: AKS has multiple worker nodes distributed across availability zones.
Azure SQL Database: Provides built-in high availability with automatic failover.
Ingress with Load Balancing: Distributes traffic across multiple pods to prevent single points of failure.
#### High Security
Private Endpoints: SQL Database is isolated from the public internet.
NSGs and Subnet Isolation: Controls traffic between application tiers.
Managed Identity: Allows secure AKS-to-SQL access without hardcoding credentials.
Ingress TLS: Encrypts data in transit.
#### Cost Optimized
Node Autoscaling: Automatically scales AKS nodes based on demand.
Azure Blob Storage Lifecycle Policies: Reduces storage costs by archiving old data.
Containerized Workloads: Efficient resource usage with containers.

## 3.Terraform:
This project uses Terraform to provision and manage cloud infrastructure in Microsoft Azure using the Infrastructure as Code (IaC) approach. The repository is organized into reusable modules and a root configuration, which together define the full deployment. 

### Modules
This folder contains reusable Terraform modules used across the project.
Modules content 
Resource Group: Creates a resource group to group related Azure resources.
Network: Provisions a virtual network, subnets, and attaches Network Security Groups (NSGs).
Database: Deploys an Azure SQL Server, a SQL Database, and a private endpoint for secure internal access.
AKS: The AKS module provisions a managed Kubernetes cluster with a default node pool of two worker nodes (refer to the repository for full code). 
#### State Backend 
The following backend block in providers.tf configures remote state storage using an Azure Storage Account. This setup ensures state persistence and collaboration across teams. 


##### To create the backend resources, run:

```bash
az storage account create --name yourStorageAccount --resource-group yourResourceGroup --location yourLocation

az storage container create --name terraformstate --account-name yourStorageAccount

# Update the parameters above to match your setup

```

Kubernetes
In this project, we use Kubernetes (AKS) to deploy and manage our cloud-native application. The kubernetes/ folder includes all necessary YAML files to set up the namespace, backend, frontend, networking (Ingress, Services), and monitoring tools.
Our AKS cluster runs multiple pods across worker nodes, with internal communication via ClusterIP services and external access managed through NGINX Ingress. Monitoring components like Prometheus and Grafana are also deployed and covered in a later section.
Cluster Overview
Cluster Type: Managed AKS cluster
Node Pool: 1 default pool with 2 worker nodes
Namespace: techmomentum-project (isolates resources within the cluster)
Pods: 2 frontend pods, 2 backend pods (one per replica), all balanced via ClusterIP services
Ingress Controller: NGINX pre-installed and configured separately)
Monitoring tools including Prometheus, Grafana, and SonarQube are deployed under a dedicated monitoring namespace (explained in a later section).
Namespace
File: namespace.yml
This file defines a dedicated namespace techmomentum-project to isolate all application components and simplify resource management within the cluster
All resources (Deployments, Services, Ingress, ConfigMaps) are created inside this namespace to prevent conflicts.
File: monitoring_namespace.yml
This file defines a dedicated namespace monitoring to isolate all monitoring components within the cluster.
It includes tools such as Prometheus, Grafana (with a PersistentVolumeClaim for data retention), and SonarQube (deployed with a LoadBalancer service) to handle observability and code quality independently from the main application.



Configuration 
File: config_map.yml
Defines a ConfigMap that provides the frontend with runtime configuration (config.json), which is mounted into the container via a volume
data:
 config.json: |
   {
     "NEXT_PUBLIC_API_URL": "http://INGRESS_PUBLIC_IP/backend/"

   }
           How it works:
The value INGRESS_PUBLIC_IP should be replaced with the actual external IP address assigned to the Ingress controller. This IP can be retrieved after the Ingress controller is created and its external service (usually of type LoadBalancer) is provisioned by the cloud provider. Once available, it is manually updated in the ConfigMap to ensure the frontend points to the correct backend endpoint through the Ingress path (/backend).
This setup allows the frontend to communicate with the backend through the Ingress, without hardcoding pod or service IPs
File: prometheus-config.yml
This file defines a ConfigMap used by Prometheus to configure its scraping jobs. It includes scrape configurations for services such as Node Exporter, Grafana, and Kubernetes components, allowing Prometheus to collect performance metrics for monitoring purposes
Ingress Configuration
Files: frontend_ingress.yml, backend_ingress.yml
Ingress resources expose internal services to the internet using HTTP routing rules:
Frontend: Accessible at /, routes to frontend-clusterip-service.
Backend: Accessible at /backend, uses regex rewriting to remove the /backend prefix before forwarding.
Example from backend_ingress.yml:
annotations:
  nginx.ingress.kubernetes.io/rewrite-target: /$2
   "nginx.ingress.kubernetes.io/use-regex: "true
This ensures clean URL handling for backend request
Frontend & Backend (Deployments and Services)
Both frontend and backend components are deployed within the techmomentum-project namespace
The frontend uses two replicas of the samahmoe/ui-auth-app:latest image. A ConfigMap is mounted to inject a dynamic config.json into the container, ensuring the UI stays updated without rebuilding the image. Its associated ClusterIP service listens on port 80 and forwards traffic to port 3000, acting as the internal route for the Ingress controller.
The backend runs a Node.js API from the samahmoe/api-auth-app:latest image, with environment variables defined for connecting to an Azure SQL Database.
Security Note: It's best practice to store sensitive values like database credentials in Kubernetes Secrets instead of hardcoding them in the manifest.
Monitoring Deployments (Grafana,Prometheus,NodeExporter & SonarQube)
In the monitoring namespace, we deployed several key monitoring tools to observe
the cluster and application behavior
Grafana is deployed using the official image and configured with a PersistentVolumeClaim to persist dashboards and settings. It uses a ConfigMap to automatically load a Prometheus data source and a predefined dashboard. Grafana is exposed internally via a ClusterIP service
Prometheus is deployed with a custom configuration that defines scrape targets for application metrics and node-level metrics. It uses a ConfigMap for the scrape configuration and is exposed internally using a ClusterIP service.
Node Exporter is deployed as a DaemonSet, ensuring a pod runs on each node to collect system-level metrics like CPU, memory, and disk usage. Prometheus automatically scrapes these metrics as part of its configuration
SonarQube is deployed using the sonarqube:community image with defined resource limits to ensure stable operation. It is exposed externally through a LoadBalancer service on port 80, forwarding traffic to port 9000. This allows easy access to the web UI for code quality inspection and static analysis.
Internal and External Communication Flow
Client Access: External users send HTTP requests to the Kubernetes cluster through the NGINX Ingress controller.


Ingress Routing: Based on the request path, the Ingress resource forwards traffic to the appropriate internal service (frontend-clusterip-service or backend-clusterip-service).


Service-to-Pod Load Balancing: Each ClusterIP service routes the request to a matching set of pods using label selectors, balancing the load across replicas.


Backend Data Access: Backend pods connect to an external Azure SQL Database using connection details passed as environment variables within the deployment specification.
Deployment Instructions 
To deploy all Kubernetes components:
 Ensure that you are connected to the AKS cluster, and verify that the NGINX Ingress Controller is already installed. The Azure SQL Database must also be pre-provisioned and accessible from the cluster subnet.
Apply all resources by running:
kubectl apply -f kubernetes/
this command creates the namespace, ConfigMap, deployments, services, ingress rules, and monitoring components.








  Pipeline:
What is a CI/CD Pipeline?
A CI/CD pipeline helps us automate the process of integrating and delivering our software.
In Continuous Integration (CI), we frequently merge our code changes into a shared repository. Every time we do this, automated builds and tests run to catch any issues early.
With Continuous Delivery (CD), once our code passes all tests, it’s automatically prepared for release. We still manually approve the deployment to production.
Continuous Deployment goes a step further by automatically deploying every successful change to production without needing manual approval.











Why do we use CI/CD?
Faster Releases
Better collaboration 
Reduce risk
Increase Reliability


Our Monorepo and CI/CD Pipelines Setup

We use a monorepo approach, which means all our project code lives in a single repository. Inside this repository, we have four main folders, each representing a different part of our system:
frontend/ — contains the code for our user interface
backend/ — contains our server and API code
terraform/ — contains infrastructure as code scripts to manage cloud resources
Kubernetes/ — contains Kubernetes deployment configurations
Advantages of Monorepo approach:
Easily manage dependencies and shared code between frontend and backend
Simplify version control because all parts are synchronized
Make cross-team collaboration smoother since everyone works on the same codebase
Frontend Pipeline
Main Steps of Our Frontend CI/CD Pipeline
1. Trigger Section
This section configures the pipeline to trigger only when changes are pushed to the main branch and only if the changes affect files inside the authentication_app_frontend folder. This optimizes pipeline runs to only necessary builds.
2. Installing Node.js
We install Node.js version 18.x because our frontend depends on Node-based tools like npm for package management and testing.
3. Running Tests: Ensuring Our Code Works
This part runs npm install to install dependencies and npm test to execute automated tests, verifying that the frontend code functions as expected.
4. Static Code Analysis with SonarQube
We integrate SonarQube to analyze code quality and identify bugs, code smells, and security issues in the frontend code. This step requires a configured SonarQube service connection in Azure DevOps and a valid sonar-project.properties file in the frontend directory.
5. Building the Docker Image: Packaging Our App
We build a Docker image of our frontend app using the latest code so it can run consistently anywhere inside containers.
6. Pushing the Image to DockerHub
We push the Docker image to DockerHub to make it available for deployment.
Backend Pipeline
Main Steps of Our Backend CI/CD Pipeline
1. Trigger Section
This section configures the pipeline to trigger only when changes are pushed to the main branch and only if the changes affect files inside the authentication_app_Backend folder. This optimizes pipeline runs to only necessary builds.
2. Setting Up the Environment: Installing Node.js
We install Node.js version 18.x because our backend depends on Node-based tools like npm for package management and testing.
3. Running Tests: Ensuring Our Code Works
This step runs npm install to install dependencies and npm test to execute automated tests, verifying that the backend code functions as expected.
4. Static Code Analysis with SonarQube
We integrate SonarQube to analyze code quality, detect bugs, code smells, and ensure secure and maintainable code in the backend. This step assumes a configured SonarQube service connection in Azure DevOps and a valid sonar-project.properties file in the backend directory.
5. Building the Docker Image: Packaging Our App
We build a Docker image of our backend app using the latest code so it can run consistently in any containerized environment.
6. Pushing the Image to DockerHub
We push the Docker image to DockerHub to make it available for deployment.
Terraform Pipeline

Main Steps of Our Terraform CI/CD Pipeline
1. Trigger Pipeline on Infrastructure Code Changes
The pipeline is triggered only when changes are pushed to the main branch and only if the changes are within the Terraform-v02/ folder. This ensures that the pipeline runs only when infrastructure code is modified.
2. Deploy Infrastructure Using Terraform
Install Terraform:
 Terraform CLI is installed on the Azure DevOps agent to enable infrastructure provisioning.
Set Azure Credentials:
 Azure authentication details (such as client ID, client secret, subscription ID, and tenant ID) are securely passed to the pipeline using environment variables stored in pipeline secrets.
Create Azure Resources for Remote State:
 A resource group, storage account, and blob container are created to store the remote Terraform state. This allows for consistent state management and collaboration.
Initialize and Apply Terraform:
 terraform init initializes the working directory and sets up the backend using the remote state storage.
 terraform apply provisions the defined infrastructure in Azure, automatically approving changes without manual input.

Kubernetes Pipeline

Main Steps of the Kubernetes CI/CD Pipeline
1. Trigger Pipeline When Kubernetes Files Are Changed
The pipeline is configured to trigger only when:
Code is pushed to the main branch
Changes are made specifically within the kubernetes/ folder
This ensures the pipeline runs only when Kubernetes-related configurations are updated.
2. Get AKS Credentials & Deploy with Helm
Retrieve AKS Credentials:
 The pipeline authenticates with Azure Kubernetes Service (AKS) using the Azure CLI to fetch cluster credentials.
 This step enables interaction with the AKS cluster from within the pipeline.
Set Up NGINX Ingress Controller:
 The pipeline installs the NGINX Ingress Controller using Helm.
 It creates a dedicated namespace (ingress-nginx) and configures the ingress controller to expose services using a LoadBalancer.
Deploy Kubernetes Resources:
 The pipeline executes a deploy.sh script that applies the Kubernetes manifests.
 This script likely contains kubectl apply commands to deploy or update services, deployments, and other resources within the cluster.


Here is our pipeline in Azure DevOps:





























Montring :
In our monitoring setup, we have deployed three main pods, each responsible for a specific aspect of system and application monitoring: 
1. Prometheus:
 Prometheus is used to collect and store metrics from various sources within the environment. In this setup, Prometheus monitors standard system metrics using Node Exporter, as well as additional custom application metrics.
 2. Grafana:
 Grafana is used to visualize the metrics collected by Prometheus. It supports two types of dashboards:
 Node Exporter Dashboard: A ready-made template that displays system-level metrics such as CPU, memory, disk, and network statistics.
  Custom Dashboards: Manually built dashboards tailored to specific application needs, allowing users to monitor any defined metrics in a visual format. 
Grafana provides an interactive and user-friendly interface for real-time monitoring and alerting. 
3. SonarQube:
 SonarQube is used for static code analysis of the frontend and backend applications. It scans the source code to detect bugs, vulnerabilities, code smells, and maintainability issues. This helps ensure code quality and security before deployment. 
System Monitoring with Prometheus and Grafana:



Running steps:
The deployment and execution of the Authentication Project are fully automated through four Azure DevOps pipelines. These pipelines are triggered automatically upon changes to their respective Git repositories, or can be manually executed via the Azure DevOps interface.
1- Terraform Pipeline:
Trigger: Any changes pushed to the Terraform-02 Git repository.
Manual Run: Can also be executed manually from Azure DevOps.
Responsibility:Installs Terraform, creates Azure resources (resource group, storage account, container), retrieves the remote state from the storage account, and runs terraform apply to provision infrastructure.
2- Kubernetes Pipeline:
Trigger: Any changes pushed to the kubernetes Git repository.
Manual Run: Can also be executed manually from Azure DevOps.
Responsibility: Gets AKS credentials, installs NGINX Ingress via Helm, injects the external IP into the config map, and deploys Kubernetes manifests using a shell script.
3- Frontend Pipeline:
Trigger: Any changes pushed to the authentication_app_frontend Git repository.
Manual Run: Can also be executed manually from Azure DevOps.
Responsibility: Runs tests, performs SonarQube analysis, builds and pushes a Docker image, and restarts the frontend deployment on AKS.
Note: The SonarQube service connection in Azure DevOps should be updated to match the external IP of the SonarQube LoadBalancer service to ensure successful analysis.
4- Backend Pipeline:
Trigger: Any changes pushed to the authentication_app_backend Git repository.
Manual Run: Can also be executed manually from Azure DevOps.
Responsibility: Runs tests, performs SonarQube analysis, builds and pushes a Docker image, and restarts the backend deployment on AKS.
Note: The SonarQube service connection in Azure DevOps should be updated to match the external IP of the SonarQube LoadBalancer service to ensure successful analysis.



Conclusion
In conclusion, this project successfully demonstrated the implementation of a complete DevOps lifecycle for a containerized authentication application. By leveraging tools such as Azure DevOps, Terraform, and Kubernetes, we achieved seamless automation of infrastructure provisioning and application deployment. The adoption of Agile practices ensured continuous improvement and effective collaboration throughout the development cycle. This experience strengthened our practical skills in managing cloud-based environments and reinforced the value of automation and teamwork in delivering reliable software systems.
































References:
GitHub. (n.d.). GitHub Repository. https://github.com/mkatq/techmomentume.git.
Microsoft. (n.d.). Azure DevOps Services. https://dev.azure.com.
Atlassian. (n.d.). Jira Software. https://www.atlassian.com/software/jira.
Flaticon. (n.d.). Free vector icons and stickers. https://www.flaticon.com.
Lucid Software. (n.d.). Lucidchart – Cloud-based diagramming tool. https://www.lucidchart.com.
Kubernetes Authors. (n.d.). Kubernetes YAML manifest documentation. https://Kubernetes.io.
Prometheus Authors. (n.d.). Node Exporter Documentation. https://prometheus.io/docs/guides/node-exporter/.
HashiCorp. (n.d.). Terraform Registry. https://registry.terraform.io.



