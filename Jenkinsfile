pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        TF_IN_AUTOMATION = 'true'
    }

    options {
        timestamps()
        ansiColor('xterm')
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Verify Tools') {
            steps {
                sh '''
                    terraform --version
                    aws --version
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'aws-creds']
                ]) {
                    sh '''
                        terraform init
                    '''
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                sh '''
                    terraform validate
                '''
            }
        }

        stage('Terraform Format Check') {
            steps {
                sh '''
                    terraform fmt -check || true
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'aws-creds']
                ]) {
                    sh '''
                        terraform plan -out=tfplan
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'aws-creds']
                ]) {
                    sh '''
                        terraform apply -auto-approve tfplan
                    '''
                }
            }
        }

        stage('Display Terraform Outputs') {
            steps {
                sh '''
                    echo "========== TERRAFORM OUTPUTS =========="
                    terraform output
                    echo "======================================="
                '''
            }
        }
    }

    post {
        success {
            echo 'Terraform deployment completed successfully.'
            sh 'terraform output || true'
        }

        failure {
            echo 'Terraform deployment failed.'
        }

        always {
            archiveArtifacts artifacts: '**/*.tf, **/*.tfvars', fingerprint: true, allowEmptyArchive: true
            cleanWs(deleteDirs: true)
        }
    }
}
