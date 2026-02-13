pipeline {
    agent any

    environment {
        SERVER_NAME = "testing"
        TERRAFORM_ACTION = "apply"
    }

    stages {
        stage('Run Terraform + Ansible') {
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
                    terraform plan
                    terraform $TERRAFORM_ACTION -auto-approve

                    if [ "$TERRAFORM_ACTION" = "destroy" ]; then
                        exit 0
                    else
                        cd ../Ansible
                        ansible-playbook -i /opt/ansible/inventory/aws_ec2.yaml apache.yaml
                    fi
                    '''
                }
            }
        }
    }
}
