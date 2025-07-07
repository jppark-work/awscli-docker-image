FROM docker:20.10-dind-rootless

# 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    python3 \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# AWS CLI v2 설치
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# 버전 확인
RUN docker --version && aws --version
