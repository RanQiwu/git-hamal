FROM alpine:3.8

RUN apk add git expect

COPY run.sh /home
WORKDIR /home

CMD sh run.sh