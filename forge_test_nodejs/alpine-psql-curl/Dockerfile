FROM alpine:3.7

RUN apk add --no-cache postgresql

RUN apk add --no-cache curl

ENTRYPOINT ["psql"]

CMD ["--help"]
