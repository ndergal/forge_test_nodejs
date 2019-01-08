<?php
	$password = $argv[1];
	$salt = md5(uniqid(rand(), true));
	$encrypted = crypt($password, '$1$'.substr($salt, 0, 8).'$');
	echo $encrypted ;
?>
