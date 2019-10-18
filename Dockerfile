FROM ubuntu:latest

# setting maintainer
LABEL maintainer="@securitychops"

COPY .start.sh .

RUN chmod +x .start.sh && \
    apt-get update && \
    apt-get install -y git && \
    apt-get install -y golang-go && \
    apt-get install -y python && \
    apt-get install -y python-pip && \
    go get github.com/subfinder/subfinder

RUN pip install awscli

# run our script first yo dawg 
CMD ["bash", ".start.sh"]
