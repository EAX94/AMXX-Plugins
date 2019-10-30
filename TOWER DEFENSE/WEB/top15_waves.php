<?php
	//include("start_cache_5.php");
	include("config_td_sql.php");
	
	$topOk = '0';
	$topMapName = $_GET['map'];
	
	if($topMapName[0] == 't' && $topMapName[1] == 'd' && $topMapName[2] == '_') {
		if(!preg_match('/\s/', $topMapName)) {
			$topOk = '1';
		}
	}

	function getMapSeconds($mapName, $diffId) {
		$topQuery = "SELECT td_time_seconds
			FROM td_timepermap
			WHERE td_mapname='".$mapName."' AND td_diff='".$diffId."'
			ORDER BY td_time_seconds ASC
			LIMIT 1";

		$topData = mysql_fetch_array(mysql_query($topQuery));
		return $topData[0];
	}

	function getFormatedText($time) {
		if($time < 1) {
			return "<span style='color:orange;'>NO COMPLETADO</span>";
		}

		$formatedText = "";

		$hours = 0;
		$minutes = 0;
		$seconds = 0;

		while($time >= 3600) {
			++$hours;
			$time -= 3600;
		}

		while($time >= 60) {
			++$minutes;
			$time -= 60;
		}

		$hourText = ($hours != 1) ? "horas" : "hora";
		$minuteText = ($minutes != 1) ? "minutos" : "minuto";
		$secondText = ($time != 1) ? "segundos" : "segundo";

		$formatedHour = "";
		$formatedMinute = "";
		$formatedSecond = "";

		if($hours > 0) {
			$formatedHour = "<span style='color:orange;'>$hours</span> $hourText ";
		}

		if($minutes > 0) {
			if($hours > 0) {
				$formatedMinute = " <span style='color:orange;'>$minutes</span> $minuteText ";
			} else {
				$formatedMinute = "<span style='color:orange;'>$minutes</span> $minuteText ";
			}
		}

		if($time > 0) {
			if($hours > 0 || $minutes > 0) {
				$formatedSecond = " <span style='color:orange;'>$time</span> $secondText";
			} else {
				$formatedSecond = "<span style='color:orange;'>$time</span> $secondText";
			}
		}

		$formatedText = "$formatedHour$formatedMinute$formatedSecond";

		return $formatedText;
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
			echo "<table cellpadding=2 cellspacing=0 border=0 width=100%>";
			echo "<tr align='center' bgcolor='#52697B'>
					<th colspan='6'><span style='font-size:18px'>Mapa: </span><span style='font-size:18px;color:orange'>".$topMapName."</span></th>
				</tr>";

			if($topOk == '1') {
				$topNormal = getMapSeconds($topMapName, 0);
				$topNightmare = getMapSeconds($topMapName, 1);
				$topSuicidal = getMapSeconds($topMapName, 2);
				$topHell = getMapSeconds($topMapName, 3);

				$topNormal_Text = getFormatedText($topNormal);
				$topNightmare_Text = getFormatedText($topNightmare);
				$topSuicidal_Text = getFormatedText($topSuicidal);
				$topHell_Text = getFormatedText($topHell);
			}

			echo "<tr align='center' bgcolor='#52697B'>
				<th width='25%' align='center'><span style='font-size:14px'>NORMAL</span></th>
				<th width='25%' align='center'><span style='font-size:14px'>NIGHTMARE</span></th>
				<th width='25%' align='center'><span style='font-size:14px'>SUICIDAL</span></th>
				<th width='25%' align='center'><span style='font-size:14px'>HELL</span></th>
			</tr>";

			echo "<tr align='center' bgcolor='#52697B'>
				<th width='25%' align='center'><span style='font-size:14px'>".$topNormal_Text."</span></th>
				<th width='25%' align='center'><span style='font-size:14px'>".$topNightmare_Text."</span></th>
				<th width='25%' align='center'><span style='font-size:14px'>".$topSuicidal_Text."</span></th>
				<th width='25%' align='center'><span style='font-size:14px'>".$topHell_Text."</span></th>
			</tr>";

			echo "<tr align='center' bgcolor='#526'>
					<th width='25%' align='center'>Dificultad</th>
					<th width='25%' align='center'>Oleada</th>
					<th width='25%' align='center'>Jugadores</th>
					<th width='25%' align='center'>Tiempo</th>
				</tr>";
			
			if($topOk == '1') {
				$posicion = '1';
				$topSeparator = " <span style='color:orange'>|</span> ";
				$topPos = 0;
				$topNormal = 0;
				$topNightmare = 0;
				$topSuicidal = 0;
				$topReturn = 0;

				$topQuery = "SELECT td_time_seconds, td_wave, td_mapname, td_diff, td_username1, td_username2, td_username3, td_username4, td_username5, td_username6, td_username7, td_username8, td_username9, td_username10, td_players
						FROM td_timeperwave
						WHERE (td_wave, td_time_seconds, td_mapname, td_diff)
						IN (SELECT td_wave, MIN(td_time_seconds), td_mapname, td_diff
							FROM td_timeperwave
							WHERE td_mapname='".$topMapName."' AND td_diff='3'
							GROUP BY td_wave)
						ORDER BY td_wave DESC, td_time_seconds ASC;";

				$topExec = mysql_query($topQuery);

				$topUsers = "";

				while($topData = mysql_fetch_array($topExec)) {
					$topReturn = 1;

					$topTime = $topData['td_time_seconds'];
					$topWave = $topData['td_wave'];
					$topUser[0] = $topData['td_username1'];
					$topUser[1] = $topData['td_username2'];
					$topUser[2] = $topData['td_username3'];
					$topUser[3] = $topData['td_username4'];
					$topUser[4] = $topData['td_username5'];
					$topUser[5] = $topData['td_username6'];
					$topUser[6] = $topData['td_username7'];
					$topUser[7] = $topData['td_username8'];
					$topUser[8] = $topData['td_username9'];
					$topUser[9] = $topData['td_username10'];
					$topPlayers = $topData['td_players'];

					$topFormatedTime = getFormatedText($topTime);
					
					for($i = 0; $i < 10; ++$i) { 
						$topUser[$i] = str_replace("<", "&lt", $topUser[$i]);
						$topUser[$i] = str_replace(">", "&gt", $topUser[$i]);
						$topUser[$i] = str_replace(" ", "&nbsp;", $topUser[$i]);

						if($i == 0) {
							$topUsers = $topUser[$i];
							continue;
						}

						if($topUser[$i] != '') {
							$topUsers = $topUsers.$topSeparator.$topUser[$i];
						}
					}
					
					if(!($posicion % 2)) {
						$color = " bgcolor='#424242'";
						$colorText = "";
					} else {
						$color = '';
						$colorText = "";
					}

					//<td align='justify'><b><p style='width:85%'>". $topUsers ."</p></b></td>
					
					echo "<tr". $color ."".$colorText.">
							<td align='center'><b><span style='color:red'>HELL</span></b></td>
							<td align='center'><b>". $topWave ."</b></td>
							<td align='center'><b>". $topPlayers ."</b></td>
							<td align='center'><b>". $topFormatedTime ."</b></td>
						</tr>";
					
					$posicion = $posicion + 1;
				}

				if(!$topReturn) {
					$topQuery = "SELECT td_time_seconds, td_wave, td_mapname, td_diff, td_username1, td_username2, td_username3, td_username4, td_username5, td_username6, td_username7, td_username8, td_username9, td_username10, td_players
							FROM td_timeperwave
							WHERE (td_wave, td_time_seconds, td_mapname, td_diff)
							IN (SELECT td_wave, MIN(td_time_seconds), td_mapname, td_diff
								FROM td_timeperwave
								WHERE td_mapname='".$topMapName."' AND td_diff='2'
								GROUP BY td_wave)
							ORDER BY td_wave DESC, td_time_seconds ASC;";

					$topExec = mysql_query($topQuery);

					$topUsers = "";

					while($topData = mysql_fetch_array($topExec)) {
						$topReturn = 1;

						$topTime = $topData['td_time_seconds'];
						$topWave = $topData['td_wave'];
						$topUser[0] = $topData['td_username1'];
						$topUser[1] = $topData['td_username2'];
						$topUser[2] = $topData['td_username3'];
						$topUser[3] = $topData['td_username4'];
						$topUser[4] = $topData['td_username5'];
						$topUser[5] = $topData['td_username6'];
						$topUser[6] = $topData['td_username7'];
						$topUser[7] = $topData['td_username8'];
						$topUser[8] = $topData['td_username9'];
						$topUser[9] = $topData['td_username10'];
						$topPlayers = $topData['td_players'];

						$topFormatedTime = getFormatedText($topTime);
						
						for($i = 0; $i < 10; ++$i) { 
							$topUser[$i] = str_replace("<", "&lt", $topUser[$i]);
							$topUser[$i] = str_replace(">", "&gt", $topUser[$i]);
							$topUser[$i] = str_replace(" ", "&nbsp;", $topUser[$i]);

							if($i == 0) {
								$topUsers = $topUser[$i];
								continue;
							}

							if($topUser[$i] != '') {
								$topUsers = $topUsers.$topSeparator.$topUser[$i];
							}
						}
						
						if(!($posicion % 2)) {
							$color = " bgcolor='#424242'";
							$colorText = "";
						} else {
							$color = '';
							$colorText = "";
						}
						
						echo "<tr". $color ."".$colorText.">
								<td align='center'><b><span style='color:#EE7621'>SUICIDAL</span></b></td>
								<td align='center'><b>". $topWave ."</b></td>
								<td align='center'><b>". $topPlayers ."</b></td>
								<td align='center'><b>". $topFormatedTime ."</b></td>
							</tr>";
						
						$posicion = $posicion + 1;
					}
				}

				if(!$topReturn) {
					$topQuery = "SELECT td_time_seconds, td_wave, td_mapname, td_diff, td_username1, td_username2, td_username3, td_username4, td_username5, td_username6, td_username7, td_username8, td_username9, td_username10, td_players
							FROM td_timeperwave
							WHERE (td_wave, td_time_seconds, td_mapname, td_diff)
							IN (SELECT td_wave, MIN(td_time_seconds), td_mapname, td_diff
								FROM td_timeperwave
								WHERE td_mapname='".$topMapName."' AND td_diff='1'
								GROUP BY td_wave)
							ORDER BY td_wave DESC, td_time_seconds ASC;";

					$topExec = mysql_query($topQuery);

					$topUsers = "";

					while($topData = mysql_fetch_array($topExec)) {
						$topReturn = 1;
						
						$topTime = $topData['td_time_seconds'];
						$topWave = $topData['td_wave'];
						$topUser[0] = $topData['td_username1'];
						$topUser[1] = $topData['td_username2'];
						$topUser[2] = $topData['td_username3'];
						$topUser[3] = $topData['td_username4'];
						$topUser[4] = $topData['td_username5'];
						$topUser[5] = $topData['td_username6'];
						$topUser[6] = $topData['td_username7'];
						$topUser[7] = $topData['td_username8'];
						$topUser[8] = $topData['td_username9'];
						$topUser[9] = $topData['td_username10'];
						$topPlayers = $topData['td_players'];

						$topFormatedTime = getFormatedText($topTime);
						
						for($i = 0; $i < 10; ++$i) { 
							$topUser[$i] = str_replace("<", "&lt", $topUser[$i]);
							$topUser[$i] = str_replace(">", "&gt", $topUser[$i]);
							$topUser[$i] = str_replace(" ", "&nbsp;", $topUser[$i]);

							if($i == 0) {
								$topUsers = $topUser[$i];
								continue;
							}

							if($topUser[$i] != '') {
								$topUsers = $topUsers.$topSeparator.$topUser[$i];
							}
						}
						
						if(!($posicion % 2)) {
							$color = " bgcolor='#424242'";
							$colorText = "";
						} else {
							$color = '';
							$colorText = "";
						}
						
						echo "<tr". $color ."".$colorText.">
								<td align='center'><b><span style='color:yellow'>NIGHTMARE</span></b></td>
								<td align='center'><b>". $topWave ."</b></td>
								<td align='center'><b>". $topPlayers ."</b></td>
								<td align='center'><b>". $topFormatedTime ."</b></td>
							</tr>";
						
						$posicion = $posicion + 1;
					}
				}

				if(!$topReturn) {
					$topQuery = "SELECT td_time_seconds, td_wave, td_mapname, td_diff, td_username1, td_username2, td_username3, td_username4, td_username5, td_username6, td_username7, td_username8, td_username9, td_username10, td_players
							FROM td_timeperwave
							WHERE (td_wave, td_time_seconds, td_mapname, td_diff)
							IN (SELECT td_wave, MIN(td_time_seconds), td_mapname, td_diff
								FROM td_timeperwave
								WHERE td_mapname='".$topMapName."' AND td_diff='0'
								GROUP BY td_wave)
							ORDER BY td_wave DESC, td_time_seconds ASC;";

					$topExec = mysql_query($topQuery);

					$topUsers = "";

					while($topData = mysql_fetch_array($topExec)) {
						$topTime = $topData['td_time_seconds'];
						$topWave = $topData['td_wave'];
						$topUser[0] = $topData['td_username1'];
						$topUser[1] = $topData['td_username2'];
						$topUser[2] = $topData['td_username3'];
						$topUser[3] = $topData['td_username4'];
						$topUser[4] = $topData['td_username5'];
						$topUser[5] = $topData['td_username6'];
						$topUser[6] = $topData['td_username7'];
						$topUser[7] = $topData['td_username8'];
						$topUser[8] = $topData['td_username9'];
						$topUser[9] = $topData['td_username10'];
						$topPlayers = $topData['td_players'];

						$topFormatedTime = getFormatedText($topTime);
						
						for($i = 0; $i < 10; ++$i) { 
							$topUser[$i] = str_replace("<", "&lt", $topUser[$i]);
							$topUser[$i] = str_replace(">", "&gt", $topUser[$i]);
							$topUser[$i] = str_replace(" ", "&nbsp;", $topUser[$i]);

							if($i == 0) {
								$topUsers = $topUser[$i];
								continue;
							}

							if($topUser[$i] != '') {
								$topUsers = $topUsers.$topSeparator.$topUser[$i];
							}
						}
						
						if(!($posicion % 2)) {
							$color = " bgcolor='#424242'";
							$colorText = "";
						} else {
							$color = '';
							$colorText = "";
						}
						
						echo "<tr". $color ."".$colorText.">
								<td align='center'><b><span style='color:#7FFF00'>NORMAL</span></b></td>
								<td align='center'><b>". $topWave ."</b></td>
								<td align='center'><b>". $topPlayers ."</b></td>
								<td align='center'><b>". $topFormatedTime ."</b></td>
							</tr>";
						
						$posicion = $posicion + 1;
					}
				}
			}
			
			echo "<tr align='center' bgcolor='#526'>
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