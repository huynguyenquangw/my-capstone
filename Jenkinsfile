pipeline {
    agent any

    tools { 
        nodejs "default-nodejs"
        "org.jenkinsci.plugins.docker.commons.tools.DockerTool" "default-docker"
    }
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerHub')
        registry = "879381259188.dkr.ecr.ap-southeast-2.amazonaws.com/huynguyenquangw/my-capstone"
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

        stage('Build') {
            steps {
                sh "docker build --platform linux/amd64 -t ${registry}:latest ."
                // sh "docker build -t my-capstone:${env.BUILD_NUMBER} ."
            }
        }

        stage("Test") {
            steps {
                sh "npm test"
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
                    sh "docker stop my-capstone || true"
                    sh "docker rm my-capstone || true"

                    // Run a new container with your app
                    sh "docker run -d --name my-capstone -p 3030:3000 ${registry}:latest"
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // def scannerHome = tool 'default-sonar-scanner'
                    withSonarQubeEnv('default-sonar-scanner') {
                        // sh "${scannerHome}/bin/sonar-scanner"
                        sh "mvn sonar:sonar"
                    }
                }
            }
        }

        stage("Release") {
            steps {
                script {
                    // sh "docker login -u AWS -p $(aws ecr get-login-password --region ap-southeast-2) 879381259188.dkr.ecr.ap-southeast-2.amazonaws.com"
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws1']]) {
                        sh "aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin 879381259188.dkr.ecr.ap-southeast-2.amazonaws.com"
                    }
                    sh "docker push ${registry}:latest"
                }
            }
        }
        
        stage('Run') {
            steps {
                script {
                    def docker_stop = "docker stop my-capstone || true"
                    def docker_clean = "docker rm my-capstone || true"
                    def kickoff = "docker run -d -p 3030:3000 --platform linux/amd64 --rm --name my-capstone ${registry}:latest"
                    def test1 = "pwd"
                    def test2 = "docker version"
                    sshagent(['3.27.169.6']) {
                        sh "ssh -o StrictHostKeyChecking=no ubuntu@3.27.169.6 ${docker_stop}"
                        sh "ssh -o StrictHostKeyChecking=no ubuntu@3.27.169.6 ${docker_clean}"
                        sh "ssh -o StrictHostKeyChecking=no ubuntu@3.27.169.6 ${kickoff}"
                    }
                }
            }
        }
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
