pipeline {
    agent any

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
                bat 'npm run build'
                bat 'docker build -t %IMAGE_NAME%:latest .'
            }
        }

        stage('Phase 3: CD - Deployment (Run Docker Containers)') {
            steps {
                echo '=== Deploying Fresh Docker Containers ==='
                bat '''
                    @echo off
                    echo Stopping existing containers...
                    docker stop dev-app 2>nul
                    docker rm dev-app 2>nul
                    docker stop staging-app 2>nul
                    docker rm staging-app 2>nul

                    echo Starting Development container on port 3000...
                    docker run -d --name dev-app -p 3000:80 %IMAGE_NAME%:latest

                    echo Starting Staging container on port 5000...
                    docker run -d --name staging-app -p 5000:80 %IMAGE_NAME%:latest

                    echo Verifying active containers:
                    docker ps
                '''
            }
        }
    }

    post {
        success {
            echo "=================================================="
            echo " SUCCESS: Containers running on ports 3000 & 5000!"
            echo "=================================================="
        }
    }
}