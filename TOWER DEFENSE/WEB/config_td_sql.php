<?php
	$__dbHost = "ip";
	$__dbName = "name";
	$__dbUser = "user";
	$__dbPass = "password";
	
	$sqlConnection = mysql_connect($__dbHost, $__dbUser, $__dbPass) or die ("No se pudo conectar a la base de datos!");
	
	mysql_select_db($__dbName) or die("No se pudo seleccionar la base de datos especificada");
?>