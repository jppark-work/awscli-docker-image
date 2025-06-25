# Dockerfile
FROM alpine:3.20

RUN apk add --no-cache \
    bash \
    curl \
    unzip \
    docker-cli \
    python3 \
    py3-pip

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

RUN aws --version && docker --version

ENTRYPOINT ["/bin/bash"]
