FROM alpine:3.18

# hadolint ignore=DL3018
RUN apk --no-cache add pwgen

ENTRYPOINT ["/usr/bin/pwgen"]
CMD ["-s", "16", "1"]
