FROM alpine:3.14

COPY certmock.sh /

# hadolint ignore=DL3018
RUN apk add --no-cache openssl 

ENTRYPOINT ["sh", "/certmock.sh"]
