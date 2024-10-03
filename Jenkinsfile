pipeline {
    agent any
    // { 
    //     node {
    //         label 'docker-agent-alpine'
    //     }
    // }
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

    environment {
        registry = "879381259188.dkr.ecr.ap-southeast-2.amazonaws.com/huynguyenquangw/my-capstone"
        // DIRECTORY_PATH = "./"
        // TESTING_ENVIRONMENT = "staging"
        // PRODUCTION_ENVIRONMENT = "production"
        // SONAR_HOST_URL = "http://localhost:9000"
        // SONAR_SCANNER_HOME = tool "SonarQube Scanner 6.2"
        // SONAR_LOGIN_TOKEN = "sqp_7145b5dbe5cc9e3a502f1c02b1cf631623e1664a"
    }

    stages {
        stage("Test node & npm") {
            steps {
                sh """
                node -v
                npm -v
                docker -v
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
            // agent any
            steps {
                // sh "docker -v"
                // // sh "npm install"
                // // sleep 5
                // sh "docker build -t huynguyenquangw/my-capstone:latest ."
                script {
                    dockerImage = docker.build registry
                }
            }
        }
        // stage('Docker Push') {
        //     // agent any
        //     steps {
        //         // withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
        //         //     sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"

        //         // }
        //             sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
        //             sh "docker push huynguyenquangw/my-capstone:latest"
        //     }
        // }

        stage('Deploy') {
            steps {
                script {
                    echo 'Deploying to Docker container...'
                    
                    // Remove old container if exists
                    sh "docker stop ${registry} || true"
                    sh "docker rm ${registry} || true"

                    // Run a new container with your app
                    sh "docker run -d --name ${registry} -p 3030:3000 ${registry}:latest"
                }
            }
        }

        // stage("Test") {
        //     steps {
        //         sh "npm test"
        //     }
        // }

        // stage('SonarQube Analysis') {
        //     steps {
        //         script {
        //             def scannerHome = tool 'default-sonar-scanner'
        //             withSonarQubeEnv() {
        //                 sh "${scannerHome}/bin/sonar-scanner"
        //             }
        //         }
        //     }
        // }

        // stage("Release") {
        //     steps {
        //         script {
        //             sh "aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin 879381259188.dkr.ecr.ap-southeast-2.amazonaws.com"
        //             sh "docker push ${registry}:latest"
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
