pipeline {
    agent any

    tools { nodejs "NodeJS 18.20" }

    environment {
        DIRECTORY_PATH = "./"
        TESTING_ENVIRONMENT = "staging"
        PRODUCTION_ENVIRONMENT = "production"
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