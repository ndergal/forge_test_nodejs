FROM valilabis.ensg.eu:5000/dokuwiki

WORKDIR /var/www/dokuwiki

RUN rm conf/dokuwiki.php
RUN rm /etc/apache2/sites-available/000-default.conf
RUN mkdir lib/plugins/markdownextra
RUN mkdir /var/www/dokuwiki.proj
RUN echo "Listen 90" >> /etc/apache2/ports.conf

COPY acl.auth.php conf/
COPY local.php conf/
COPY pass.php conf/
COPY entrypoint.sh ./
COPY configurer.txt data/pages/
COPY start.txt data/pages/
COPY deploiement-forge.txt data/pages/
COPY dokuwiki.php conf/
COPY markdownextra/ lib/plugins/markdownextra/
COPY 000-default.conf /etc/apache2/sites-available/
COPY index.php /var/www/dokuwiki.proj/

RUN chmod 755 entrypoint.sh
RUN chmod -R 644 conf/*.php data/pages/*.txt 
RUN chmod -R 755 lib/plugins/markdownextra/
RUN chown -R www-data conf/*.php data/pages/*.txt lib/plugins/markdownextra/
RUN chgrp -R www-data conf/*.php data/pages/*.txt lib/plugins/markdownextra/
RUN chmod 644 /var/www/dokuwiki.proj/index.php && chown www-data /var/www/dokuwiki.proj/index.php && chgrp www-data /var/www/dokuwiki.proj/index.php

EXPOSE 80

ENTRYPOINT ["./entrypoint.sh"]
