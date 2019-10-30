<?php
	include("config_amix_sql.php");
	
	// $mixId = $_GET['mix'];
?>

<html hola_ext_inject="disabled">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="tue, 01 jan 1980 1:00:00 gmt">
		<link rel="stylesheet" href="css/style.css" />	
		
		<script type="text/javascript">

		  var _gaq = _gaq || [];
		  _gaq.push(['_setAccount', 'UA-30712819-1']);
		  _gaq.push(['_trackPageview']);

		  (function() {
			var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
			ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
			var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
		  })();

		</script>
	</head>
	
	<body>
		<?php
			$sqlQuery = "SELECT *
					FROM amix_partidos
					ORDER BY id DESC
					LIMIT 1;";
			
			$execQuery = mysql_query($sqlQuery) or die("Error: ".mysql_error());
			
			while($dataQuery = mysql_fetch_array($execQuery)) {
				$totalMixes = $dataQuery['id'];
				
				$winnerName = $dataQuery['w_n'];
				$looserName = $dataQuery['l_n'];
				$winnerScore = $dataQuery['w_p'];
				$looserScore = $dataQuery['l_p'];
				
				for($i = 1; $i < 6; ++$i) {
					$varName = "w_pj_".$i;
					$varKills = "w_pj_".$i."_k";
					$varDeaths = "w_pj_".$i."_d";
					$varHeadshots = "w_pj_".$i."_hs";
					$varDamage = "w_pj_".$i."_dmg";
					
					$winnerData[$i][0] = $dataQuery[$varName];
					$winnerData[$i][1] = $dataQuery[$varKills];
					$winnerData[$i][2] = $dataQuery[$varDeaths];
					$winnerData[$i][3] = $dataQuery[$varHeadshots];
					$winnerData[$i][4] = $dataQuery[$varDamage];
					
					$winnerData[$i][0] = str_replace("<", "&lt", $winnerData[$i][0]);
					$winnerData[$i][0] = str_replace(">", "&gt", $winnerData[$i][0]);
					$winnerData[$i][0] = str_replace(" ", "&nbsp;", $winnerData[$i][0]);
					
					$varName = "l_pj_".$i;
					$varKills = "l_pj_".$i."_k";
					$varDeaths = "l_pj_".$i."_d";
					$varHeadshots = "l_pj_".$i."_hs";
					$varDamage = "l_pj_".$i."_dmg";
					
					$looserData[$i][0] = $dataQuery[$varName];
					$looserData[$i][1] = $dataQuery[$varKills];
					$looserData[$i][2] = $dataQuery[$varDeaths];
					$looserData[$i][3] = $dataQuery[$varHeadshots];
					$looserData[$i][4] = $dataQuery[$varDamage];
					
					$looserData[$i][0] = str_replace("<", "&lt", $looserData[$i][0]);
					$looserData[$i][0] = str_replace(">", "&gt", $looserData[$i][0]);
					$looserData[$i][0] = str_replace(" ", "&nbsp;", $looserData[$i][0]);
				}
				
				for($i = 2; $i < 6; ++$i) {
					for($j = 1; $j < 6; ++$j) {
						if($winnerData[$i][1] > $winnerData[$j][1]) {
							for($k = 0; $k < 5; ++$k) {
								$temp = $winnerData[$j][$k];
								
								$winnerData[$j][$k] = $winnerData[$i][$k];
								$winnerData[$i][$k] = $temp;
							}
						}
						
						if($looserData[$i][1] > $looserData[$j][1]) {
							for($k = 0; $k < 5; ++$k) {
								$temp = $looserData[$j][$k];
								
								$looserData[$j][$k] = $looserData[$i][$k];
								$looserData[$i][$k] = $temp;
							}
						}
					}
				}
				
				$totalMixes = number_format($totalMixes, 0, '', '.');
			}
			
			mysql_close();
		?>
		
		<div class="termino">LOS <span style="color:#fff;"><?php echo $winnerName; ?></span> GANARON EL MIX!</div><br />
		
		<?php
			$sumaW[1] = 0;
			$sumaW[2] = 0;
			$sumaW[3] = 0;
			$sumaW[4] = 0;
			
			$sumaL[1] = 0;
			$sumaL[2] = 0;
			$sumaL[3] = 0;
			$sumaL[4] = 0;
			
			if($winnerName == 'PUBEROS') {
				$color1 = '#029202';
				$color2 = '#ff0000';
				
				$score1 = $winnerScore;
				$score2 = $looserScore;
				
				for($i = 1; $i < 6; ++$i) {
					$winnerD[$i][0] = $winnerData[$i][0];
					$winnerD[$i][1] = $winnerData[$i][1];
					$winnerD[$i][2] = $winnerData[$i][2];
					$winnerD[$i][3] = $winnerData[$i][3];
					$winnerD[$i][4] = $winnerData[$i][4];
					
					$looserD[$i][0] = $looserData[$i][0];
					$looserD[$i][1] = $looserData[$i][1];
					$looserD[$i][2] = $looserData[$i][2];
					$looserD[$i][3] = $looserData[$i][3];
					$looserD[$i][4] = $looserData[$i][4];
					
					$sumaW[1] += $winnerD[$i][1];
					$sumaW[2] += $winnerD[$i][2];
					$sumaW[3] += $winnerD[$i][3];
					$sumaW[4] += $winnerD[$i][4];
					
					$sumaL[1] += $looserD[$i][1];
					$sumaL[2] += $looserD[$i][2];
					$sumaL[3] += $looserD[$i][3];
					$sumaL[4] += $looserD[$i][4];
				}
			} else {
				$color1 = '#ff0000';
				$color2 = '#029202';
				
				$score1 = $looserScore;
				$score2 = $winnerScore;
				
				for($i = 1; $i < 6; ++$i) {
					$looserD[$i][0] = $winnerData[$i][0];
					$looserD[$i][1] = $winnerData[$i][1];
					$looserD[$i][2] = $winnerData[$i][2];
					$looserD[$i][3] = $winnerData[$i][3];
					$looserD[$i][4] = $winnerData[$i][4];
					
					$winnerD[$i][0] = $looserData[$i][0];
					$winnerD[$i][1] = $looserData[$i][1];
					$winnerD[$i][2] = $looserData[$i][2];
					$winnerD[$i][3] = $looserData[$i][3];
					$winnerD[$i][4] = $looserData[$i][4];
					
					$sumaW[1] += $winnerD[$i][1];
					$sumaW[2] += $winnerD[$i][2];
					$sumaW[3] += $winnerD[$i][3];
					$sumaW[4] += $winnerD[$i][4];
					
					$sumaL[1] += $looserD[$i][1];
					$sumaL[2] += $looserD[$i][2];
					$sumaL[3] += $looserD[$i][3];
					$sumaL[4] += $looserD[$i][4];
				}
			}
			
			$sumaW[4] = number_format($sumaW[4], 0, '', '.');
			$sumaL[4] = number_format($sumaL[4], 0, '', '.');
			
			// El que más mató
			$maxMato_Cant = $winnerD[1][1];
			$maxMato_Name = $winnerD[1][0];
			
			for($i = 1; $i < 6; ++$i) {
				if($winnerD[$i][1] > $maxMato_Cant) {
					$maxMato_Cant = $winnerD[$i][1];
					$maxMato_Name = $winnerD[$i][0];
				}
				
				if($looserD[$i][1] > $maxMato_Cant) {
					$maxMato_Cant = $looserD[$i][1];
					$maxMato_Name = $looserD[$i][0];
				}
			}
			
			// El que más daño hizo
			$maxDamage_Cant = $winnerD[1][4];
			$maxDamage_Name = $winnerD[1][0];
			
			for($i = 1; $i < 6; ++$i) {
				if($winnerD[$i][4] > $maxDamage_Cant) {
					$maxDamage_Cant = $winnerD[$i][4];
					$maxDamage_Name = $winnerD[$i][0];
				}
				
				if($looserD[$i][4] > $maxDamage_Cant) {
					$maxDamage_Cant = $looserD[$i][4];
					$maxDamage_Name = $looserD[$i][0];
				}
			}
			
			$maxDamage_Cant = number_format($maxDamage_Cant, 0, '', '.');
			
			// El que más disparos en la cabeza hizo
			$maxHeadshots_Cant = $winnerD[1][3];
			$maxHeadshots_Name = $winnerD[1][0];
			
			for($i = 1; $i < 6; ++$i) {
				if($winnerD[$i][3] > $maxHeadshots_Cant) {
					$maxHeadshots_Cant = $winnerD[$i][3];
					$maxHeadshots_Name = $winnerD[$i][0];
				}
				
				if($looserD[$i][3] > $maxHeadshots_Cant) {
					$maxHeadshots_Cant = $looserD[$i][3];
					$maxHeadshots_Name = $looserD[$i][0];
				}
			}
			
			// Si lo pongo arriba se buguea el que más daño hizo por el formato
			for($i = 1; $i < 6; ++$i) {
				$looserD[$i][4] = number_format($looserD[$i][4], 0, '', '.');
				$winnerD[$i][4] = number_format($winnerD[$i][4], 0, '', '.');
			}
		?>
		<div class="termino_1">
			<span style="color:<?php echo $color1; ?>;">PUBEROS</span> [ <span style="color:<?php echo $color1; ?>;"><?php echo $score1; ?></span> - <span style="color:<?php echo $color2; ?>;"><?php echo $score2; ?></span> ] <span style="color:<?php echo $color2; ?>;">MIXEROS</span>
		</div><br />
		
		<div class="termino_mas">
			<div style="margin-top:5px;">EL QUE MÁS HA MATADO<br>
				<span style="color:#FFFFFF;"><?php echo $maxMato_Name." (".$maxMato_Cant.")"; ?></span>
			</div>
			<div style="margin-top:5px;">EL QUE MÁS DAÑO HIZO<br>
				<span style="color:#FFFFFF;"><?php echo $maxDamage_Name." (".$maxDamage_Cant.")"; ?></span>
			</div>
			<div style="margin-top:5px;">EL QUE MÁS HEADSHOTS HIZO<br>
				<span style="color:#FFFFFF;"><?php echo $maxHeadshots_Name." (".$maxHeadshots_Cant.")"; ?></span>
			</div>
		</div><br>
		
		<table cellpadding="2" cellspacing="0" border="0" width="100%">
			<tbody>
				<tr align="center" bgcolor="#fa1919">
					<th width="100%" colspan="5" align="center" class="titulo">PUBEROS - <?php echo $score1; ?></th>
				</tr>
				<tr align="center" bgcolor="#232121">
					<th width="20%" class="expli1" align="center">Nombre</th>
					<th width="20%" class="expli1" align="center">Matados</th>
					<th width="20%" class="expli1" align="center">Muertes</th>
					<th width="20%" class="expli1" align="center">Headshots</th>
					<th width="20%" class="expli1" align="center">Daño</th>
				</tr>
				<?php
					for($i = 1; $i < 6; ++$i) {
				?>
						<tr>
							<td align="center"><b><?php echo $winnerD[$i][0]; ?></b></td>
							<td align="center"><b><?php echo $winnerD[$i][1]; ?></b></td>
							<td align="center"><b><?php echo $winnerD[$i][2]; ?></b></td>
							<td align="center"><b><?php echo $winnerD[$i][3]; ?></b></td>
							<td align="center"><b><?php echo $winnerD[$i][4]; ?></b></td>
						</tr>
				<?php
					}
				?>
				<tr align="center" bgcolor="#232121">
					<th width="20%" class="expli1" align="center">Total</th>
					<th width="20%" class="expli1" align="center"><?php echo $sumaW[1]; ?></th>
					<th width="20%" class="expli1" align="center"><?php echo $sumaW[2]; ?></th>
					<th width="20%" class="expli1" align="center"><?php echo $sumaW[3]; ?></th>
					<th width="20%" class="expli1" align="center"><?php echo $sumaW[4]; ?></th>
				</tr>
				<tr align="center" bgcolor="#000000">
					<th width="100%" colspan="5" align="center">&nbsp;</th>
				</tr>
				<tr align="center" bgcolor="#004890">
					<th width="100%" colspan="5" align="center">MIXEROS - <?php echo $score2; ?></th>
				</tr>
				<tr align="center" bgcolor="#232121">
					<th width="20%" class="expli2" align="center">Nombre</th>
					<th width="20%" class="expli2" align="center">Matados</th>
					<th width="20%" class="expli2" align="center">Muertes</th>
					<th width="20%" class="expli2" align="center">Headshots</th>
					<th width="20%" class="expli2" align="center">Daño</th>
				</tr>
				<?php
					for($i = 1; $i < 6; ++$i) {
				?>
						<tr>
							<td align="center"><b><?php echo $looserD[$i][0]; ?></b></td>
							<td align="center"><b><?php echo $looserD[$i][1]; ?></b></td>
							<td align="center"><b><?php echo $looserD[$i][2]; ?></b></td>
							<td align="center"><b><?php echo $looserD[$i][3]; ?></b></td>
							<td align="center"><b><?php echo $looserD[$i][4]; ?></b></td>
						</tr>
				<?php
					}
				?>
				<tr align="center" bgcolor="#232121">
					<th width="20%" class="expli2" align="center">Total</th>				
					<th width="20%" class="expli2" align="center"><?php echo $sumaL[1]; ?></th>
					<th width="20%" class="expli2" align="center"><?php echo $sumaL[2]; ?></th>
					<th width="20%" class="expli2" align="center"><?php echo $sumaL[3]; ?></th>
					<th width="20%" class="expli2" align="center"><?php echo $sumaL[4]; ?></th>
				</tr>
				<tr align="center" bgcolor="#000000">
					<th width="100%" colspan="3" align="center">&nbsp;</th>
				</tr>
			</tbody>
		</table>
		
		<div class="total">SE HAN JUGADO UN TOTAL DE <span style="color:#FFF;"><?php echo $totalMixes; ?></span> MIXES</div>
	</body>
</html>