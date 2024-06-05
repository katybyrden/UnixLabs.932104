FROM ubuntu:latest

RUN apt-get update && apt-get -y upgrade && apt-get install -y coreutils

WORKDIR /lab

COPY script.sh /lab/script.sh

RUN chmod +x /lab/script.sh

CMD ["./script.sh"]
