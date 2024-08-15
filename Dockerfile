# 使用 OpenJDK 作为基础镜像
FROM openjdk:17-slim

# 设置阿里云的 Debian 源
RUN sed -i 's|http://deb.debian.org/debian|http://mirrors.aliyun.com/debian|g' /etc/apt/sources.list \
    && sed -i 's|http://security.debian.org/debian-security|http://mirrors.aliyun.com/debian-security|g' /etc/apt/sources.list

# 设置工作目录
WORKDIR /app

# 复制项目文件到工作目录
COPY . .

# 安装必要的软件包
RUN apt-get install -y wget curl unzip git

# 下载 Maven
RUN wget https://mirrors.huaweicloud.com/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.zip \
    && unzip apache-maven-3.6.3-bin.zip \
    && mv apache-maven-3.6.3 /opt/maven \
    && ln -s /opt/maven/bin/mvn /usr/bin/mvn \
    && rm apache-maven-3.6.3-bin.zip

# 配置 Maven 使用阿里云镜像
RUN mkdir -p /root/.m2 \
    && echo '<settings>' \
    '<mirrors>' \
    '<mirror>' \
    '<id>nexus-aliyun</id>' \
    '<mirrorOf>central</mirrorOf>' \
    '<name>Nexus aliyun</name>' \
    '<url>https://maven.aliyun.com/repository/central/</url>' \
    '</mirror>' \
    '</mirrors>' \
    '</settings>' > /root/.m2/settings.xml

# 运行 Flyway 数据库迁移
RUN mvn clean package flyway:migrate

# 暴露应用端口
EXPOSE 8080

# 运行 mailserver 模块
CMD ["java", "-jar", "mailserver/target/mailserver.jar"]

