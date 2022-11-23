FROM alpine
RUN apk add --update postgresql-client
COPY gah-db-copy.sh /
CMD ["/gah-db-copy.sh"]
