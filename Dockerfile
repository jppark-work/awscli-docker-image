FROM python:3.8-alpine

# 필요한 최소 패키지로만 설치
RUN apk add --no-cache \
    curl \
    docker-cli \
    py3-pip \
    && pip install "awscli<2>"

# 버전 확인용 (빌드 중 로그로 확인)
RUN aws --version && docker --version

# 기본 쉘
ENTRYPOINT ["/bin/sh"]
