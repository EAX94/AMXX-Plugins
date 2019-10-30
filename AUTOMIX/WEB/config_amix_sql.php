<?php
	$__dbHost = "ip";
	$__dbName = "db name";
	$__dbUser = "db username";
	$__dbPass = "db password";
	
	$sqlConnection = mysql_connect($__dbHost, $__dbUser, $__dbPass) or die ("No se pudo conectar a la base de datos!");
	
	mysql_select_db($__dbName) or die("No se pudo seleccionar la base de datos especificada");
?>