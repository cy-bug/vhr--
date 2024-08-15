pipeline {
  agent { label '10-node' }
  environment {
    DOCKER_COMPOSE_FILE = 'docker-compose.yml'
    REGISTRY_URL = 'http://ops-cy-245:9998/'
    IMAGE_NAME = 'ops-cy-245:9998/library/java-vhr'
    CREDENTIALS_ID = 'harbor-account' // Jenkins 中存储的 Harbor 凭证 ID
  }
  stages {
    stage('Checkout') { // git拉取代码
      steps {
        git branch: 'master', url: 'https://gitee.com/dy5/vhr.git'
      }
    }
    stage('Docker Build') { // 根据 Docker Compose 文件构建镜像
      steps {
        script {
          // 使用 Docker Compose 构建镜像
          withEnv(["BUILD_ID=${env.BUILD_ID}"]) {
            sh "docker-compose -f docker-compose.yml build"
		  }
        }
      }
    }
    stage('Push to Harbor') { // 上传镜像至 Harbor
      steps {
        script {
          // 登录 Harbor 并推送镜像
          docker.withRegistry(REGISTRY_URL, CREDENTIALS_ID) {
            sh "docker push ${IMAGE_NAME}:${env.BUILD_ID}"
          }
        }
      }
    }
    stage('Docker Compose Up') { // 使用 Docker Compose 启动服务
      steps {
        script {
          // 启动服务
          sh "docker-compose -f ${DOCKER_COMPOSE_FILE} up -d"
        }
      }
    }
  }
 // post {
 //   failure {
      // 清理操作，确保容器被正确停止和删除
 //     script {
  //      sh "docker-compose -f ${DOCKER_COMPOSE_FILE} down || true"
  //    }
 //  }
 // }
}
