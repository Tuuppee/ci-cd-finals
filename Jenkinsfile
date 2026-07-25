pipeline {
    agent any

    parameters {
        choice(name: 'TARGET_ENV', choices: ['Development', 'Staging'], description: 'Target Environment for Deployment')
    }

    stages {
        stage('Phase 1: CI - Test') {
            steps {
                echo '=== Running CI Automated Tests ==='
                bat 'npm install'
                bat 'npm test'
            }
        }

        stage('Phase 2: CD - Delivery') {
            steps {
                echo '=== Compiling & Packaging Build Artifact ==='
                bat 'npm run build'
                bat '''
                    @echo off
                    if not exist "C:\\deployments" mkdir "C:\\deployments"
                    echo Packaging build into C:\\deployments\\app-v1.0.0.zip...
                    powershell -Command "Compress-Archive -Path 'dist\\*' -DestinationPath 'C:\\deployments\\app-v1.0.0.zip' -Force"
                '''
            }
        }

        stage('Phase 3: CD - Deployment') {
            steps {
                echo "=== Deploying Artifact to ${params.TARGET_ENV} ==="
                bat '''
                    @echo off
                    set ENV=%TARGET_ENV%
                    if "%ENV%"=="" set ENV=Development

                    if not exist "C:\\deployments\\%ENV%" mkdir "C:\\deployments\\%ENV%"

                    echo Unpacking app-v1.0.0.zip into C:\\deployments\\%ENV%...
                    powershell -Command "Expand-Archive -Path 'C:\\deployments\\app-v1.0.0.zip' -DestinationPath 'C:\\deployments\\%ENV%' -Force"

                    echo Injecting environment configuration...
                    if exist "C:\\deployments\\%ENV%\\configs\\config.%ENV%.js" (
                        copy /Y "C:\\deployments\\%ENV%\\configs\\config.%ENV%.js" "C:\\deployments\\%ENV%\\config.js"
                    )
                '''
            }
        }
    }

    post {
        success {
            echo "Pipeline Passed! Opening Docker application tabs in browser..."
            bat '''
                @echo off
                start http://localhost:3000
                start http://localhost:5000
            '''
        }
    }
}
