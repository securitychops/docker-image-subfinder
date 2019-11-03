FROM ubuntu:latest

# setting maintainer
LABEL maintainer="@securitychops"

RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y golang-go
RUN apt-get install -y python
RUN apt-get install -y python-pip
RUN go get github.com/subfinder/subfinder

RUN pip install awscli

COPY .start.sh /root/go/bin

WORKDIR /root/go/bin

# run our script first yo dawg 
CMD ["bash", "/root/go/bin/.start.sh"]
