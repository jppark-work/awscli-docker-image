FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive

# 필수 패키지 설치 (awscli 1.x 고정)
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    python3 \
    python3-pip \
    iptables \
    uidmap \
    gnupg \
    lsb-release \
    netcat \
    amazon-ecr-credential-helper \
    && pip3 install --no-cache-dir awscli==1.27.160 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
  && apt-get install -y \
     ca-certificates curl gnupg lsb-release \
  && mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://download.docker.com/linux/debian/gpg \
     | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
  && echo \
     "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
     https://download.docker.com/linux/debian \
     $(lsb_release -cs) stable" \
     > /etc/apt/sources.list.d/docker.list \
  && apt-get update

# 포트 및 볼륨
VOLUME ["/var/lib/docker"]
EXPOSE 2375

CMD ["dockerd"]
