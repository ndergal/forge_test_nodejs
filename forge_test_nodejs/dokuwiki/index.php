<?php

$contents = file_get_contents('php://input');
$json_data = json_decode($contents);
$result = strcmp($json_data->event_name,'project_create');
if(0 == $result){
	$name = $json_data->projet;
	$description = $json_data->description;
	$return_var = system("mkdir /var/www/dokuwiki/data/pages/$name && echo '$description' > /var/www/dokuwiki/data/pages/$name/start.txt && chown -R www-data /var/www/dokuwiki/data/pages/$name && chgrp -R www-data /var/www/dokuwiki/data/pages/$name");
}
?>

