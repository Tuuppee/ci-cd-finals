pipeline {
    agent any

    environment {
        CI = 'true'
    }

    stages {
        stage('Phase 1: CI - Test') {
            steps {
                echo '=== Running CI Automated Tests ==='
                bat 'npm ci || npm install'
                bat 'npm test -- --passWithNoTests'
            }
        }

        stage('Phase 2: CD - Delivery') {
            steps {
                echo '=== Compiling & Packaging Build Artifact ==='
                bat 'npm run build'
                bat '''
                    @echo off
                    if not exist "C:\\deployments" mkdir "C:\\deployments"
                    echo Packaging dist folder into C:\\deployments\\app-v1.0.0.zip...
                    powershell -Command "Compress-Archive -Path 'dist\\*' -DestinationPath 'C:\\deployments\\app-v1.0.0.zip' -Force"
                '''
            }
        }

        stage('Phase 3: CD - Deployment') {
            steps {
                echo '=== Deploying Artifact to Target Folder ==='
                bat '''
                    @echo off
                    if not exist "C:\\deployments\\Development" mkdir "C:\\deployments\\Development"

                    echo Unpacking build into Development directory...
                    powershell -Command "Expand-Archive -Path 'C:\\deployments\\app-v1.0.0.zip' -DestinationPath 'C:\\deployments\\Development' -Force"

                    if exist "C:\\deployments\\Development\\configs\\config.development.js" (
                        echo Injecting environment configuration...
                        copy /Y "C:\\deployments\\Development\\configs\\config.development.js" "C:\\deployments\\Development\\config.js"
                    )
                '''
            }
        }
    }

    post {
        success {
            echo "=================================================="
            echo " SUCCESS: Build deployed to C:\\deployments\\Development"
            echo " View live site at: http://localhost:3000"
            echo "=================================================="
        }
    }
}
