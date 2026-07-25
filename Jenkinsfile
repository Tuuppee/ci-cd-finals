pipeline {
    agent any

    parameters {
        choice(
            name: 'TARGET_ENV', 
            choices: ['Development', 'Staging'], 
            description: 'Select Target Environment for Deployment'
        )
    }

    environment {
        CI = 'true'
        IMAGE_NAME = 'ci-cd-finals-app'
    }

    stages {
        stage('Phase 1: CI - Test') {
            steps {
                echo '=== Running CI Automated Tests ==='
                bat 'npm ci || npm install'
                bat 'npm test -- --passWithNoTests'
            }
        }

        stage('Phase 2: CD - Delivery (Build Docker Image)') {
            steps {
                echo '=== Compiling App & Building Docker Image ==='
                bat 'docker build -t %IMAGE_NAME%:latest .'
            }
        }

        stage('Phase 3: CD - Deployment') {
            steps {
                script {
                    def envName = params.TARGET_ENV
                    def containerName = (envName == 'Development') ? 'dev-app' : 'staging-app'
                    def port = (envName == 'Development') ? '3000' : '5000'

                    echo "=== Deploying to ${envName} Environment on Port ${port} ==="

                    bat """
                        @echo off
                        echo Stopping existing ${containerName} container...
                        docker stop ${containerName} 2>nul
                        docker rm ${containerName} 2>nul

                        echo Launching fresh ${containerName} container on port ${port}...
                        docker run -d --name ${containerName} -p ${port}:80 ${IMAGE_NAME}:latest

                        echo Active Docker Containers:
                        docker ps
                    """
                }
            }
        }
    }

    post {
        success {
            script {
                def envName = params.TARGET_ENV
                def port = (envName == 'Development') ? '3000' : '5000'
                echo "=================================================="
                echo " SUCCESS: Deployed to ${envName}!"
                echo " Access URL: http://localhost:${port}"
                echo "=================================================="
            }
        }
    }
}