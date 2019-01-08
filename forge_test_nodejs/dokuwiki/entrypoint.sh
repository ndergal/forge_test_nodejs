#!/bin/sh

PASS=$(php conf/pass.php $password)
echo "$log_in:$PASS:$name:$address:user,admin" >> conf/users.auth.php
chmod 644 conf/users.auth.php
chgrp www-data conf/users.auth.php
chown www-data conf/users.auth.php

apache2 -D FOREGROUND

exit 0
