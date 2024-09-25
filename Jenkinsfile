pipeline {
    agent any

    environment {
        DIRECTORY_PATH = "./"
        TESTING_ENVIRONMENT = "staging"
        PRODUCTION_ENVIRONMENT = "production"
    }

    stages {
        stage("Checkout") {
            steps {
                checkout scm
            }
        }

        stage("Build") {
            steps {
                sh "npm run build"
            }
        }
    }
}