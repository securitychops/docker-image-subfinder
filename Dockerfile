FROM golang:alpine as builder

RUN apk update && \
    apk add --no-cache git

WORKDIR /build

COPY go-go-gadget.sh .

RUN git clone https://github.com/projectdiscovery/subfinder

WORKDIR /build/subfinder/cmd/subfinder

# get all dependencies for subfinder
RUN go get -d -v

# get rid of all debug info during build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -ldflags="-w -s" -o /tmp/subfinder

# getting specific to avoid breakages from latest
FROM alpine:3.11.3

RUN apk update && \
    apk add --no-cache python && \
    apk add --no-cache py-pip && \
    pip install --upgrade awscli && \
    apk -v --purge del py-pip && \
    addgroup -S bender && \
    adduser -S -G bender bender && \
    chown bender:bender /tmp

COPY --from=builder /build/go-go-gadget.sh /build/subfinder/config.yaml /tmp/subfinder /tmp/

WORKDIR /tmp

USER bender

ENTRYPOINT [ "sh" ]

CMD [ "go-go-gadget.sh" ]