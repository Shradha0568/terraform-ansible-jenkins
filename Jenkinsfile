pipeline {
    agent any

    environment {
        SERVER_NAME = "testing"
        TERRAFORM_ACTION = "apply"
    }

    stages {
        stage('Terraform + Ansible Deploy') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh '''
                    set -xe

                    cd Terraform

                    sed -i "s/server_name/${SERVER_NAME}/g" backend.tf
                    export TF_VAR_name=${SERVER_NAME}

                    terraform init
                    terraform apply -auto-approve

                    if [ "$TERRAFORM_ACTION" = "destroy" ]; then
                        exit 0
                    fi

                    INSTANCE_IP=$(terraform output -raw instance_ip)

                    echo "[web]" > inventory
		    echo "$INSTANCE_IP" >> inventory

		    ssh-keyscan -H $INSTANCE_IP >> ~/.ssh/known_hosts

		    cd ../Ansible
		    
                    ansible-playbook -i ../Terraform/inventory apache.yaml \
		    --private-key /var/lib/jenkins/euran-jenkins.pem \
		    -u ec2-user
		   
		    '''
                }
            }
        }
    }
}

