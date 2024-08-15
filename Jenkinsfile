pipeline {
    agent {label '10-node'}

    environment {
	    DOCKER_COMPOSE_FILE = 'docker-compose.yml'
        REGISTRY_URL = 'http://ops-cy-245:9998/'
        IMAGE_NAME = 'ops-cy-245:9998/library/go-project'
        CREDENTIALS_ID = 'harbor-account' // Jenkins 中存储的 Harbor 凭证 ID
        DOCKER_TAG = "${env.BUILD_ID}"
    }

    stages {
        stage('Checkout') {
            steps {
			  git branch: 'master', url: 'https://gitee.com/dy5/vhr.git'
                
            }
        }
        stage('Build') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${DOCKER_TAG}")
                }
            }
        }
        stage('Push to Harbor') {
            steps {
                script {
                    docker.withRegistry('REGISTRY_URL', 'CREDENTIALS_ID') {
                        docker.image("${IMAGE_NAME}:${DOCKER_TAG}").push()
                    }
                }
            }
        }
        stage('Docker Compose Up') {
            steps {
                script {
                    sh 'docker-compose up -d'
                }
            }
        }
    }
	
    //post {
    //    always {
    //        echo 'Cleaning up...'
    //        sh 'docker-compose down'
    //    }
    //    success {
    //        echo 'Pipeline succeeded!'
    //    }
    //    failure {
    //        echo 'Pipeline failed!'
    //    }
    //}
}
