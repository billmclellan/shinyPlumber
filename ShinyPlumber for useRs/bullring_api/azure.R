library(AzureRMR)
library(AzureContainers)
# authenticate with Azure AD:
# - on first login to this client, call create_azure_login()
# - on subsequent logins, call get_azure_login()

# deployclus-big$delete("service", "bullring-svc")
# deployclus-big$delete("deployment", "bullring")

wd <- getwd()
setwd("ShinyPlumber for useRs/bullring_api")

source("secrets.R") # tenant, subscription, email

az <- create_azure_login() # use get after 1st time

# get a subscription and resource group
sub <- az$get_subscription(subscription) 
deployresgrp <- sub$get_resource_group("shinyplumber") # use create_resource_group first time

# create container registry
deployreg_svc <- deployresgrp$get_acr("shinyplumberreg") # first time #create_acr

# build image 'favdock' on the local machine
system.time(call_docker("build -t bullring ."))
# initial build time much longer than subsequent updates
# user   system  elapsed 
# 53.485    5.133 1001.177 Linux 
# 61.72     2.22  1380.97  Windows

# upload the image to Azure
bullreg <- deployreg_svc$get_docker_registry()
bullreg$push("bullring")

# create a Kubernetes cluster with 2 nodes, running Linux
#bull_svc <- deployresgrp$create_aks("deployclus", agent_pools=aks_pools("agentpool","B2s", 3))
deployclus_svc <- deployresgrp$get_aks("deployclus-big")

# get the cluster endpoint
`deployclus-big` <- deployclus_svc$get_cluster()

# pass registry authentication details to the cluster
#deployclus$create_registry_secret(deployreg_svc, email = email)

# create and start the service
`deployclus-big`$create("bullring.yaml")
#system("sudo kubectl create -f bullring.yaml  --validate=false") #--kubeconfig=/home/bmac/.local/share/AzureR/kubeconfig_deployclus 

`deployclus-big`$get("deployment bullring")
`deployclus-big`$get("service bullring-svc")

# `deployclus-big`$delete("service", "bullring-svc")
# `deployclus-big`$delete("deployment", "bullring")
# shinyplumber$delete()

setwd(wd)
