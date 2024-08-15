# 使用 OpenJDK 作为基础镜像
FROM openjdk:11-jre-slim

# 设置工作目录
WORKDIR /app

# 复制项目文件到工作目录
COPY . .

# 配置 MySQL 数据库
RUN apt-get update && apt-get install -y mysql-client

# 运行 Flyway 数据库迁移
RUN ./mvnw flyway:migrate

# 暴露应用端口
EXPOSE 8080

# 运行 mailserver 模块
CMD ["java", "-jar", "mailserver/target/mailserver.jar"]
