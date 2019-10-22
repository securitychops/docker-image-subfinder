FROM golang:alpine

# setting maintainer
LABEL maintainer="@securitychops"

# get startup script ready
COPY .start.sh /home/bender

RUN chmod +x /home/bender/.start.sh
RUN apk add --update git
RUN apk add --update python
RUN apk add --update py-pip
RUN pip install awscli
RUN go get github.com/subfinder/subfinder
RUN apk add --update 

# autostart our script
CMD ["sh", ".start.sh"]
