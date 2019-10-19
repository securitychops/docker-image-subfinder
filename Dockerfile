FROM golang:alpine

# setting maintainer
LABEL maintainer="@securitychops"

# using non root user
RUN addgroup -S bender && \
    adduser -S bender -G bender

# get startup script ready
COPY .start.sh /home/bender

RUN chmod +x /home/bender/.start.sh && \
    # install the basics
    apk add --update \
    git \
    python \
    py-pip && \
    # get aws
    pip install awscli && \
    # get subfinder
    go get github.com/subfinder/subfinder && \
    # dont need git anymore, kill it
    apk del git

# we are now bender
USER bender
WORKDIR /home/bender

# autostart our script
CMD ["sh", ".start.sh"]
