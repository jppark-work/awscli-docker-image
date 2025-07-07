FROM docker:20.10-dind

# 필수 패키지 설치 + AWS CLI v1 설치
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
    && pip3 install --no-cache-dir awscli==1.27.160

# docker-credential-ecr-login 설치
RUN git clone https://github.com/awslabs/amazon-ecr-credential-helper /tmp/ecr-helper && \
    cd /tmp/ecr-helper && \
    make && \
    mv bin/local/docker-credential-ecr-login /usr/local/bin/ && \
    chmod +x /usr/local/bin/docker-credential-ecr-login && \
    cd / && rm -rf /tmp/ecr-helper

# 버전 확인
RUN docker --version && aws --version && docker-credential-ecr-login version || true
