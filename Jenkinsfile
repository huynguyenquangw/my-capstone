pipeline {
    agent any
    // {
    //     docker {
    //         image 'docker:27.2.0'
    //         args '-v /var/run/docker.sock:/var/run/docker.sock'
    //     }
    // }

    tools { 
        nodejs "default-nodejs"
        "org.jenkinsci.plugins.docker.commons.tools.DockerTool" "default-docker"
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerHub')
    }

    // environment {
    //     DIRECTORY_PATH = "./"
    //     TESTING_ENVIRONMENT = "staging"
    //     PRODUCTION_ENVIRONMENT = "production"
    //     SONAR_HOST_URL = "http://localhost:9000"
    //     SONAR_SCANNER_HOME = tool "SonarQube Scanner 6.2"
    //     SONAR_LOGIN_TOKEN = "sqp_7145b5dbe5cc9e3a502f1c02b1cf631623e1664a"
    // }

    stages {
        stage("Test node & npm") {
            steps {
                sh """
                node -v
                npm -v
                """
            }
        }

        stage("Checkout") {
            steps {
                checkout scm
            }
        }

        // stage("Build") {
        //     steps {
        //         sh "npm install"
        //         sh "npm run build"
        //         // script {
        //         //     // Build the Docker image
        //         //     sh "docker build -t my-capstone:${env.BUILD_NUMBER} ."
        //         // }
        //     }
        // }

        stage('Build') {
            agent any
                steps {
                    sh "npm install"
                    sh "npm run build"
                    sh "docker build -t huynguyenquangw/capstone:${env.BUILD_NUMBER} ."
            }
        }
        stage('Docker Push') {
            agent any
                steps {
                    withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
                        sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
                        sh 'docker push huynguyenquangw/capstone:latest'
                }
            }
        }

        // stage("Test") {
        //     steps {
        //         sh "npm test"
        //     }
        // }

        stage('SonarQube Analysis') {
            steps {
                script {
                    def scannerHome = tool 'default-sonar-scanner'
                    withSonarQubeEnv() {
                        sh "${scannerHome}/bin/sonar-scanner"
                    }
                }
            }
        }

        // stage("Deploy") {
        //     steps {
        //         script {
        //             // Stop any previous instance of the Docker container
        //             sh "docker-compose -f docker-compose.yml down"
                    
        //             // Build and run the Docker container
        //             sh "docker-compose -f docker-compose.yml up -d --build"
                    
        //             echo "Application has been deployed to the staging environment!"
        //         }
        //     }
        // }
    }

    post {
        always {
            echo "Pipeline execution finished. Build Number: ${env.BUILD_NUMBER}"
        }
        success {
            echo "Pipeline succeeded."
        }
        failure {
            echo "Pipeline failed."
        }
    }
}
