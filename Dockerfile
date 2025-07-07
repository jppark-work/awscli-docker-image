FROM docker:20.10-dind

# 휠 빌드 의존성 + awscli v1 설치
RUN apk --no-cache add \
    python3 \
    py3-pip \
    curl \
    bash \
    groff \
    less \
    git \
    go \
    make \
    build-base \
    libffi-dev \
    openssl-dev \
    && pip3 install --upgrade pip setuptools wheel \
    && pip3 install --no-cache-dir awscli==1.27.160

# ECR Credential Helper 설치
RUN git clone https://github.com/awslabs/amazon-ecr-credential-helper /tmp/ecr-helper && \
    cd /tmp/ecr-helper && \
    make && \
    mv bin/local/docker-credential-ecr-login /usr/local/bin/ && \
    chmod +x /usr/local/bin/docker-credential-ecr-login && \
    cd / && rm -rf /tmp/ecr-helper

# 버전 확인
RUN docker --version && aws --version && docker-credential-ecr-login version || true
