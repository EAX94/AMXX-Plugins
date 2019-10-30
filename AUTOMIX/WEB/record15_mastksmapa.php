<?php
	include("config_amix_sql.php");
	
	include("start_cache_5.php");
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
					<th width='10%' align='center'>Posicion</th>			
					<th width='25%' align='center'>Usuario</th>
					<th width='15%' align='center'>TKs</th>
					<th width='15%' align='center'>Mix jugado el</th>
				</tr>";
			
			$topQuery = "SELECT DATE_FORMAT(`fecha`, '%d-%m-%Y') as fecha, GREATEST(w_pj_1_tks,w_pj_2_tks,w_pj_3_tks,w_pj_4_tks,w_pj_5_tks, l_pj_1_tks,l_pj_2_tks,l_pj_3_tks,l_pj_4_tks,l_pj_5_tks) as score,
							CASE GREATEST(w_pj_1_tks,w_pj_2_tks,w_pj_3_tks,w_pj_4_tks,w_pj_5_tks, l_pj_1_tks,l_pj_2_tks,l_pj_3_tks,l_pj_4_tks,l_pj_5_tks)
								WHEN w_pj_1_tks then w_pj_1
								WHEN w_pj_2_tks then w_pj_2
								WHEN w_pj_3_tks then w_pj_3
								WHEN w_pj_4_tks then w_pj_4
								WHEN w_pj_5_tks then w_pj_5
								WHEN l_pj_1_tks then l_pj_1
								WHEN l_pj_2_tks then l_pj_2
								WHEN l_pj_3_tks then l_pj_3
								WHEN l_pj_4_tks then l_pj_4
								WHEN l_pj_5_tks then l_pj_5
							END as name
						FROM amix_partidos
						ORDER BY score DESC
						LIMIT 15;";
			
			$topExec = mysql_query($topQuery);
			
			$posicion = '1';
			
			while($topData = mysql_fetch_array($topExec)) {
				$topFecha = $topData['fecha'];
				$topName = $topData['name'];
				$topRecord = $topData['score'];
				
				$topRecord = number_format($topRecord, 0, '', '.');
				
				$topName = str_replace("<", "&lt", $topName);
				$topName = str_replace(">", "&gt", $topName);
				$topName = str_replace(" ", "&nbsp;", $topName);
				
				if(!($posicion % 2)) {
					$color = " bgcolor='#424242'";
				} else {
					$color = '';
				}
				
				echo "<tr". $color .">
						<td align='center'><b>". $posicion ." </b></td>
						<td align='center'><b>". $topName ."</b></td>
						<td align='center'><b>". $topRecord ."</b></td>
						<td align='center'><b>". $topFecha ."</b></td>
					</tr>";
				
				++$posicion;
			}
			
			echo "</table>";
			
			mysql_close();
		?>
	</body>
</html>


<?php
	include("end_cache_5.php");
?>