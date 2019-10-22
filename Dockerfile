FROM ubuntu:latest

# setting maintainer
LABEL maintainer="@securitychops"

COPY .start.sh .

RUN chmod +x .start.sh
RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y golang-go
RUN apt-get install -y python
RUN apt-get install -y python-pip
RUN go get github.com/subfinder/subfinder

RUN pip install awscli

# run our script first yo dawg 
CMD ["bash", ".start.sh"]
