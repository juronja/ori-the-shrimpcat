pipeline {
    agent any
    environment {
        BUILD_VERSION = VersionNumber (versionNumberString: '${BUILD_YEAR}.${BUILD_MONTH}.${BUILDS_THIS_MONTH}')
        DOCKERH_REPO = "juronja"
        IMAGE_TAG = "$JOB_NAME"
    }
        
    stages {
        stage('Build Docker image for Docker Hub') {
            environment {
                DOCKERHUB_CREDS = credentials('dockerhub-creds')
            }
            steps {
                echo "Building Docker image for Docker Hub ..."
                sh "docker build -t $DOCKERH_REPO/$IMAGE_TAG:latest -t $DOCKERH_REPO/$IMAGE_TAG:$BUILD_VERSION ."
                // Next line in single quotes for security
                sh 'echo $DOCKERHUB_CREDS_PSW | docker login -u $DOCKERHUB_CREDS_USR --password-stdin'
                sh "docker push $DOCKERH_REPO/$IMAGE_TAG:latest"
                sh "docker push $DOCKERH_REPO/$IMAGE_TAG:$BUILD_VERSION"
            }
        }
        stage('Deploy on HOSTING-PROD') {
            steps {
                script {
                    echo "Deploying Docker container on HOSTING-PROD ..."

                    def remote = [:]
                    remote.name = "hosting-prod"
                    remote.host = "hosting-prod.lan"
                    remote.allowAnyHosts = true

                    withCredentials([sshUserPrivateKey(credentialsId: 'ssh-hosting-prod', keyFileVariable: 'keyfile', usernameVariable: 'user')]) {
                        remote.user = user
                        remote.identityFile = keyfile

                        sshScript remote: remote, script: "compose-commands.sh"
                    }
                }
            }
        }
    }
}