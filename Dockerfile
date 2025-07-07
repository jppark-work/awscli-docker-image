FROM debian:bullseye

ENV DOCKER_VERSION=20.10.24

# 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    python3 \
    python3-pip \
    git \
    make \
    golang \
    awscli \
    ca-certificates \
    iptables \
    ebtables \
    iproute2 \
    uidmap \
    xz-utils \
    gnupg \
    lsb-release \
    && pip3 install awscli==1.27.160 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Docker 설치 (고정 버전)
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker.gpg && \
    echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce-cli=${DOCKER_VERSION}~3-0~debian-bullseye docker-ce=${DOCKER_VERSION}~3-0~debian-bullseye docker-ce-rootless-extras && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# ECR Credential Helper 설치
RUN git clone https://github.com/awslabs/amazon-ecr-credential-helper /tmp/ecr-helper && \
    cd /tmp/ecr-helper && make && \
    mv bin/local/docker-credential-ecr-login /usr/local/bin/ && \
    chmod +x /usr/local/bin/docker-credential-ecr-login && \
    cd / && rm -rf /tmp/ecr-helper

# dockerd 실행을 위한 설정
ENV DOCKER_HOST=unix:///var/run/docker.sock

# dockerd 실행용 엔트리포인트 (테스트/CI에서 사용)
CMD ["dockerd-entrypoint.sh"]
