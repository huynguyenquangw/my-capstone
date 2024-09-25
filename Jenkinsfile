pipeline {
    agent any

    tools { nodejs "NodeJS 18.20" }

    environment {
        DIRECTORY_PATH = "./"
        TESTING_ENVIRONMENT = "staging"
        PRODUCTION_ENVIRONMENT = "production"
    }

    stages {
        stage('Test npm') {
            steps {
                sh """
                npm --version
                """
            }
        }
    }
}