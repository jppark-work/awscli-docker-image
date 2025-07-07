FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive

# 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    curl \
    python3 \
    python3-pip \
    git \
    make \
    golang \
    ca-certificates \
    iptables \
    uidmap \
    gnupg \
    lsb-release \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# AWS CLI v1 설치 (pip 기반, 최소 버전)
RUN pip3 install --no-cache-dir awscli==1.27.160

# Docker 공식 저장소 추가 및 최신 Docker 설치
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# ECR Credential Helper 설치
RUN git clone --depth=1 https://github.com/awslabs/amazon-ecr-credential-helper /tmp/ecr-helper && \
    cd /tmp/ecr-helper && make && \
    mv bin/local/docker-credential-ecr-login /usr/local/bin/ && \
    chmod +x /usr/local/bin/docker-credential-ecr-login && \
    cd / && rm -rf /tmp/ecr-helper

# 포트 및 볼륨 설정
VOLUME ["/var/lib/docker"]
EXPOSE 2375

# 기본 실행은 dockerd
CMD ["dockerd"]
