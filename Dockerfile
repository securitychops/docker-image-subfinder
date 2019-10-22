FROM golang:alpine

# setting maintainer
LABEL maintainer="@securitychops"

# using non root user
RUN addgroup -S bender
RUN adduser -S bender -G bender

# get startup script ready
COPY .start.sh /home/bender

RUN chmod +x /home/bender/.start.sh
RUN apk add --update git
RUN apk add --update python
RUN apk add --update py-pip
RUN pip install awscli
RUN go get github.com/subfinder/subfinder
RUN apk add --update 

# we are now bender
USER bender
WORKDIR /home/bender

# autostart our script
CMD ["sh", ".start.sh"]
