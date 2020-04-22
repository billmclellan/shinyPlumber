library(AzureRMR)
library(AzureContainers)
# authenticate with Azure AD:
# - on first login to this client, call create_azure_login()
# - on subsequent logins, call get_azure_login()

wd <- getwd()
setwd("/home/bmac/UseR/bullring/bullring_api")

source("secrets.R")

az <- create_azure_login(tenant) # use get after 1st time

# get a subscription and resource group
sub <- az$get_subscription(subscription) 
deployresgrp <- sub$get_resource_group("favorcon")

# create container registry
deployreg_svc <- deployresgrp$get_acr("bullreg") # first time #create_acr

# build image 'favdock'
system.time(call_docker("build -t bullring ."))
# user   system  elapsed 
# 53.485    5.133 1001.177 

# upload the image to Azure
bullreg <- deployreg_svc$get_docker_registry()
bullreg$push("bullring")

# create a Kubernetes cluster with 2 nodes, running Linux
#bull_svc <- deployresgrp$create_aks("bull_aks", agent_pools=aks_pools("pool2","D4_v3", 1))
deployclus_svc <- deployresgrp$get_aks("deployclus")

# get the cluster endpoint
deployclus <- deployclus_svc$get_cluster()

# pass registry authentication details to the cluster
deployclus$create_registry_secret(deployreg_svc, email = email)

# create and start the service
deployclus$create("bullring.yaml")
#system("sudo kubectl create -f bullring.yaml  --validate=false") #--kubeconfig=/home/bmac/.local/share/AzureR/kubeconfig_deployclus 

deployclus$get("deployment bullring")
deployclus$get("service bullring-svc")

# deployclus$delete("service", "bullring-svc")
# deployclus$delete("deployment", "bullring")

setwd(wd)
