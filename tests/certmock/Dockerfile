FROM alpine:3.14

COPY certmock.sh /

RUN apk add --no-cache openssl 

ENTRYPOINT ["/certmock.sh"]
