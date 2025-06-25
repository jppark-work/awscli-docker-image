FROM python:3.8-alpine

# 필수 패키지 설치
RUN apk add --no-cache \
    curl \
    docker-cli \
    libffi-dev \
    openssl-dev \
    gcc \
    musl-dev \
    python3-dev \
    py3-pip \
    make

# AWS CLI v1 설치
RUN pip install "awscli<2"

# 버전 확인 (빌드시 로그 확인용)
RUN aws --version && docker --version

# ENTRYPOINT: sh 사용
ENTRYPOINT ["/bin/sh"]