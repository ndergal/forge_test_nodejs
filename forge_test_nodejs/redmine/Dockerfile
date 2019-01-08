FROM valilabis.ensg.eu:5000/redmine

WORKDIR /home/redmine/redmine/config

RUN rm settings.yml

COPY settings.yml ./ 

RUN chmod 644 ./settings.yml
RUN chown redmine ./settings.yml
RUN chgrp redmine ./settings.yml



