FROM ubuntu:latest

RUN apt-get update \
    && apt-get install -y wget tar pcregrep screen \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y apt-transport-https \
    && apt-get update \
    && apt-get install -y dotnet-runtime-7.0 \
    && rm -rf /var/lib/apt/lists/* \
    && rm packages-microsoft-prod.deb

RUN useradd -m -s /bin/bash vintagestory

WORKDIR /home/vintagestory/server

COPY init-script.sh /home/vintagestory/server/init-script.sh

ARG VS_VERSION=1.19.0-rc.6
RUN wget https://cdn.vintagestory.at/gamefiles/unstable/vs_server_linux-x64_${VS_VERSION}.tar.gz \
    && tar xzf vs_server_linux-x64_${VS_VERSION}.tar.gz \
    && rm vs_server_linux-x64_${VS_VERSION}.tar.gz

RUN chown -R vintagestory:vintagestory /home/vintagestory/server 
RUN chown -R vintagestory:vintagestory /home/vintagestory/server/init-script.sh 
RUN chmod +x /home/vintagestory/server/init-script.sh 
RUN chmod +x server.sh

USER vintagestory

EXPOSE 42420

CMD ["/home/vintagestory/server/init-script.sh"]
