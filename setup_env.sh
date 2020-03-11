#!/usr/bin/env bash

# Install Terrafrom and Kops in Ubuntu 18.04

# Install Jq

yay -S jq && yay -S unzip
KOPS_FLAVOR="kops-linux-amd64"
KOPS_VERSION=$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)
KOPS_URL="https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/${KOPS_FLAVOR}"

KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
KUBECTL_URL="https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"

TERRAFORM_VERSION=0.11.11
TERRAFORM_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

log()
{
         exit_code=$2
		 if [ -z $2 ]; then
		    exit_code=0
		 fi

		 echo "[`date '+%Y-%m-%d %T'`]:" $1
		 if [ ${exit_code} -ne "0" ]; then
		   exit ${exit_code}
		 fi
}

# Download and setup Kops

kops_setup(){

    log "INFO: Start Kops Download  -> Version : ${KOPS_VERSION} and Flavor: ${KOPS_FLAVOR}"
    curl -sLO ${KOPS_URL} || log  "ERROR: Downlaod failed"  $?
    log "INFO: Download Complete"

    #give executable permision

    chmod +x ${KOPS_FLAVOR} || log "ERROR: Cant set the executable permission" $?

    if [ -d '/usr/local/bin' ]; then

         sudo mv kops-linux-amd64 /usr/local/bin/kops
    else
        log "ERROR: /usr/local/bin Directory Not found"
    fi

    log "INFO: Kops setup done -> Version : ${KOPS_VERSION} and Flavor: ${KOPS_FLAVOR}"

    echo "======================================================================================"
    kubectl_setup

}

kubectl_setup(){
    
    log "INFO: Start Kops Download  -> Version : ${KOPS_VERSION} and Flavor: ${KOPS_FLAVOR}"
}


#Download and Setup Terraform
terraform_setup(){

    log "INFO: Download Terraform -> Version ${TERRAFORM_VERSION}"
    curl -sLO ${TERRAFORM_URL} || log  "ERROR: Downlaod failed" $?
    log "INFO: Download Complete"

    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip || log "ERROR: Unzipping terraform_${TERRAFORM_VERSION}_linux_amd64.zip" $?

    chmod +x terraform || log "ERROR: Cant set the executable permission" $?

    if [ -d '/usr/local/bin' ]; then

         sudo mv terraform /usr/local/bin/terraform || log "ERROR: Moving Terraform Failed"  $?

    else

        log "ERROR: /usr/local/bin Directory Not found"

    fi
}

verify_install(){

    log "INFO: VERIFY KOPS"

    export PATH=${PATH}:/usr/local/bin/

    kops --help  >/dev/null 2>&1 || log "ERROR: kops verification failed" $?

    log "INFO: VERIFY KUBECTL"

    kubectl --help >/dev/null 2>&1 || log "ERROR: kubectl verification failed" $?

    log "INFO: VERIFY TERRAFORM"

    terraform --version || log "ERROR: terraform verification failed" $?

    log "INFO: Validation Successful !!!"

    rm -f terraform_0.11.13_linux_amd64.zip || log "ERROR: terraform zip Cleanup failed" $?

}


echo "======================================================================================"
kops_setup
sleep 2
echo "======================================================================================"
terraform_setup
sleep 2
echo "======================================================================================"
verify_install
echo "======================================================================================"
