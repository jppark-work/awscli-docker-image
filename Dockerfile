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
    gcc \
    ca-certificates \
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

# ECR Credential Helper 설치
ENV GO111MODULE=on
WORKDIR /opt
RUN git clone --depth=1 https://github.com/awslabs/amazon-ecr-credential-helper.git && \
    cd amazon-ecr-credential-helper && \
    make && \
    mv bin/local/docker-credential-ecr-login /usr/local/bin/ && \
    chmod +x /usr/local/bin/docker-credential-ecr-login && \
    cd / && rm -rf /opt/amazon-ecr-credential-helper

# 기본 실행
VOLUME ["/var/lib/docker"]
EXPOSE 2375
CMD ["dockerd"]
