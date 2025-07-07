FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV ECR_HELPER_VERSION=v0.6.0

# 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    python3 \
    python3-pip \
    iptables \
    uidmap \
    gnupg \
    lsb-release \
    && pip3 install --no-cache-dir awscli==1.27.160 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Docker CE 설치
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# ECR Credential Helper 바이너리 설치
RUN curl -Lo /usr/local/bin/docker-credential-ecr-login \
    https://github.com/awslabs/amazon-ecr-credential-helper/releases/download/${ECR_HELPER_VERSION}/docker-credential-ecr-login-linux-amd64 && \
    chmod +x /usr/local/bin/docker-credential-ecr-login

# 포트 및 볼륨
VOLUME ["/var/lib/docker"]
EXPOSE 2375

# dockerd 실행
CMD ["dockerd"]
