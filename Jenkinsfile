pipeline {
    agent any

    tools { nodejs "NodeJS 18.20" }

    environment {
        DIRECTORY_PATH = "./"
        TESTING_ENVIRONMENT = "staging"
        PRODUCTION_ENVIRONMENT = "production"
        SONAR_HOST_URL = "http://localhost:9000"
        SONAR_SCANNER_HOME = tool "SonarQube Scanner 6.2"
    }

    stages {
        stage('Test node & npm') {
            steps {
                sh """
                node -v
                npm --version
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
                withSonarQubeEnv('SonarQube Scanner 6.2') {
                    sh "${env.SONAR_SCANNER_HOME}/bin/sonar-scanner"
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution finished.'
        }
        success {
            echo 'Pipeline succeeded.'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}