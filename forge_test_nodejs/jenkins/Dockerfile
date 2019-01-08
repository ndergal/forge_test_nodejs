FROM valilabis.ensg.eu:5000/jenkins

WORKDIR /jenkins

COPY user.groovy ./
COPY add-user.sh /sbin/
COPY entrypoint.sh /sbin/

RUN chmod 755 /sbin/add-user.sh 
RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD [""]
