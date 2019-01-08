FROM valilabis.ensg.eu:5000/alpine-psql-curl

COPY 00-start.sh ./

RUN chmod 755 00-start.sh

ENTRYPOINT ["/bin/sh"]

CMD ["00-start.sh"]
