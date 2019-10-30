<?php
	//include("start_cache_5.php");
	include("config_td_sql.php");
	
	$topOk = '0';
	$topId = $_GET['id'];
	
	if(is_numeric($topId)) {
		$topOk = '1';
	}
?>

<html>
	<head>
		<style>
			body {
				background:#232323;
				color:#cfcbc2;
				font-family:sans-serif
			}
			a, a:visited, a:active, a:hover {
				color:#cfcbc2;
				text-decoration:none;
			}
			table {
				width:100%%;
				line-height:160%%;
				font-size:12px
			}
			.q {
				border:1px solid #4a4945
			}
			.b {
				background:#2a2a2a
			}
		</style>
	</head>
	
	<body>
		<?php
			$dataDone[0] = 'comandante_lvl';
			$dataDone[1] = 'comandante_kills';

			$dataDoneText[0] = 'Comandante Nivel';
			$dataDoneText[1] = 'Matados';

			echo "<table cellpadding=2 cellspacing=0 border=0 width=100%>";
			echo "<tr align='center' bgcolor='#52697B'>
					<th width='10%' align='center'>Posici&oacute;n</th>
					<th width='25%' align='center'>Usuario</th>
					<th width='25%' align='center'>".$dataDoneText[0]."</th>
					<th width='25%' align='center'>".$dataDoneText[1]."</th>
				</tr>";
			
			if($topOk == '1') {
				$topQuery = "SELECT COUNT(id) AS rank
						FROM td_users u
						WHERE (u.".$dataDone[1]." > (SELECT ".$dataDone[1]." FROM td_users u2 WHERE u2.id = '".$topId."') OR (u.".$dataDone[1]." = (SELECT ".$dataDone[1]." FROM td_users u2 WHERE u2.id = '".$topId."') AND u.id <= '".$topId."'));";
				
				$topData = mysql_fetch_array(mysql_query($topQuery));
				$userRank = $topData[0];
				
				$topQuery = "SELECT id, name, ".$dataDone[0].", ".$dataDone[1]."
						FROM td_users
						WHERE id = '".$topId."'";
				
				$topData = mysql_fetch_array(mysql_query($topQuery));
				$userId = $topData[0];
				$userName = $topData[1];
				$userData[0] = $topData[2];
				$userData[1] = $topData[3];

				$userData[0] = number_format($userData[0], 0, '', '.');
				$userData[1] = number_format($userData[1], 0, '', '.');
			}
			
			$topQuery = "SELECT id, name, ".$dataDone[0].", ".$dataDone[1]."
					FROM td_users
					WHERE id <> 125
					ORDER BY ".$dataDone[1]." DESC
					LIMIT 15";
			
			$topExec = mysql_query($topQuery);
			
			$posicion = '1';
			
			while($topData = mysql_fetch_array($topExec)) {
				$getTopId = $topData['id'];
				$topName = $topData['name'];
				$topData[0] = $topData[$dataDone[0]];
				$topData[1] = $topData[$dataDone[1]];
				
				$topData[0] = number_format($topData[0], 0, '', '.');
				$topData[1] = number_format($topData[1], 0, '', '.');
				
				$topName = str_replace("<", "&lt", $topName);
				$topName = str_replace(">", "&gt", $topName);
				$topName = str_replace(" ", "&nbsp;", $topName);
				
				if($topOk == '1' && $getTopId == $topId) { 
					$color = " bgcolor='#C1CDCD'";
					$colorText = " style='color:black'";
				} else if(!($posicion % 2)) {
					$color = " bgcolor='#424242'";
					$colorText = "";
				} else {
					$color = '';
					$colorText = "";
				}

				$colorName = "";

				if($topData[1] > 0) {
					$colorName = "DarkGoldenRod";
				}
				
				echo "<tr". $color ."".$colorText.">
						<td align='center'><b>". $posicion ." </b></td>
						<td align='center'><b>". $topName ."</b></td>
						<td align='center'><b>". $topData[0] ."</b></td>
						<td align='center'><b>". $topData[1] ."</b></td>
					</tr>";
				
				$posicion = $posicion + 1;
			}
			
			if($topOk == '1' && $userRank > '15') {
				echo "<tr bgcolor='#424242'>
						<td align='center'><b>...</b></td>
						<td align='center'><b>...</b></td>
						<td align='center'><b>...</b></td>
						<td align='center'><b>...</b></td>
					</tr>";
				
				echo "<tr bgcolor='#C1CDCD' style='color:black'>
					<td align='center'><b>". $userRank ." </b></td>
					<td align='center'><b>". $userName ."</b></td>
					<td align='center'><b>". $userData[0] ."</b></td>
					<td align='center'><b>". $userData[1] ."</b></td>
				</tr>";
			}
			
			echo "<tr align='center' bgcolor='#52697B'>
					<th colspan='6'>Estadisticas actualizadas cada 5 minutos</th>
				</tr>";
			echo "</table>";
			
			mysql_close();
		?>
	</body>
</html>

<?php
	//include("end_cache_5.php");
?>