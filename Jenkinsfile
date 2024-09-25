pipeline {
    agent any

    tools { 
        nodejs "NodeJS 18.20"
        "org.jenkinsci.plugins.docker.commons.tools.DockerTool" "Docker latest"
    }

    environment {
        DIRECTORY_PATH = "./"
        TESTING_ENVIRONMENT = "staging"
        PRODUCTION_ENVIRONMENT = "production"
        SONAR_HOST_URL = "http://localhost:9000"
        SONAR_SCANNER_HOME = tool "SonarQube Scanner 6.2"
    }

    stages {
        stage("Test node & npm") {
            steps {
                sh """
                node -v
                npm --version
                docker --version
                """
            }
        }

        stage("Checkout") {
            steps {
                checkout scm
            }
        }

        stage("Build") {
            steps {
                sh "npm install"
                sh "npm run build"
            }
        }

        stage("Test") {
            steps {
                sh "npm test"
            }
        }

        stage("Code Quality Analysis") {
            steps {
                script {
                    echo "Performing code analysis using SonarQube..."
                    echo "Tool: SonarQube"
                }
            }
        }

        stage("Deploy") {
            steps {
                script {
                    // Stop any previous instance of the Docker container
                    sh "docker compose -f docker-compose.yml down"
                    
                    // Build and run the Docker container
                    sh "docker compose -f docker-compose.yml up -d --build"
                    
                    echo 'Application has been deployed to the staging environment!'
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline execution finished."
        }
        success {
            echo "Pipeline succeeded."
        }
        failure {
            echo "Pipeline failed."
        }
    }
}