<?php
include ("/var/www/gaminga.com/public_html/common/global.php");
include ("/var/www/gaminga.com/public_html/common/config.php");
include ("/var/www/gaminga.com/public_html/common/config_vb.php");
include ("/var/www/gaminga.com/public_html/common/connect.php");

$ptitle = ' - Counter Strike - Torneo Capture the Flag';
$pdesc = 'Torneo del servidor CTF';
$ptag = 'ctf, capture, flag, taringacs, servidores';
$pinclude = '';

include("/var/www/gaminga.com/public_html/common/header.php");

$vb_email = $vbulletin->userinfo['email'];
$vb_group = $vbulletin->userinfo['usergroupid'];
$vb_nick = $vbulletin->userinfo['username'];
$vb_userid = $vbulletin->userinfo['userid'];

if(($vb_group != '1') && ($vb_group != '3') && ($vb_group != '30') && ($vb_group != '37') && ($vb_group != ''))
	$vb_correcto = '1';
else
	$vb_correcto = '0';

$checked_1 = '';
$checked_2 = '';
$checked_3 = '';
$checked_4 = '';
$checked_5 = '';

if(isset($_GET['t']))
{
	switch($_GET['t'])
	{
		case 1:
			$checked_1 = ' checked="checked"';
			break;
		case 2:
			$checked_2 = ' checked="checked"';
			break;
		case 3:
			$checked_3 = ' checked="checked"';
			break;
		case 4:
			$checked_4 = ' checked="checked"';
			break;
		case 5:
			$checked_5 = ' checked="checked"';
			break;
		default:
			$checked_1 = ' checked="checked"';
	}
}
else
	$checked_1 = ' checked="checked"';

$table_alt = 1;
?>

<script type="text/javascript">
function bigImg(x)
{
	x.style.width="200px";
	x.style.height="118px";
}

function normalImg(x)
{
	x.style.width="10px";
	x.style.height="10px";
}
</script>

<div id="cuerpocontainer">
	<div id="izquierda">
		<br class="clear">
		<div class="entrybody">
			<div class="box_cuerpo">
				<?php
					if($vb_correcto == '1')
					{
						/*$query = mysql_query("SELECT userid FROM user WHERE username = 'kiske';") or die(mysql_error()); //("Se produjo un error, por favor notifique al webmaster. (1)");
						while($data = mysql_fetch_array($query))
						{
							$userid = $data['userid'];
						}*/
						
						include ("/var/www/gaminga.com/public_html/kiske/config_kk.php");
						include ("/var/www/gaminga.com/public_html/common/connect.php");
				?>
				
						<p style="font-weight:bold;text-align:center;text-shadow:0px 0px 2px;">
							<span style="font-size:200%;color:blue;">TORNEO CAPTURE THE FLAG</span>
						</p>
						
						<br>
						
						<p style="color:cornsilk;font-weight:bold;text-align:center;padding-left:10px;overflow:hidden;background:none repeat scroll 0 0 #3D5370;" class="server_result_line_impar">
							<span style="font-size:150%;display:inline-block;">INSCRIPTOS</span>
						</p>
						
						<?php
							$query = mysql_query("SELECT * FROM ctf WHERE aprobado = '1';") or die("Se produjo un error, por favor notifique al webmaster. (1)");
							$result = mysql_num_rows($query);
							
							if($result > 0)
							{
								?>
									<div class="clear">
										<p style="padding-left:20px;"><b>(C)</b> = Capitán.</p>
									</div>
							
									<link href="kiske.css" rel="stylesheet" type="text/css">
									
									<div class="datagrid">
										<table>
											<thead><tr><th>EQUIPO</th><th>#01</th><th>#02</th><th>#03</th><th>#04</th><th>#05</th></tr></thead>
												<tbody>
								<?php
													while($data = mysql_fetch_array($query))
													{
														$groupname = $data['groupname'];
														
														$cs_username_1 = $data['username1'];
														$cs_username_2 = $data['username2'];
														$cs_username_3 = $data['username3'];
														$cs_username_4 = $data['username4'];
														$cs_username_5 = $data['username5'];
														
														$forum_username_1 = $data['usernick1'];
														$forum_username_2 = $data['usernick2'];
														$forum_username_3 = $data['usernick3'];
														$forum_username_4 = $data['usernick4'];
														$forum_username_5 = $data['usernick5'];
														
														$forum_userid_1 = $data['userid1'];
														$forum_userid_2 = $data['userid2'];
														$forum_userid_3 = $data['userid3'];
														$forum_userid_4 = $data['userid4'];
														$forum_userid_5 = $data['userid5'];
														
														$capitan = $data['captain_userid'];
														
														switch($capitan)
														{
															case $forum_userid_1:
																$cs_username_1 = "$cs_username_1 <b>(C)</b>";
																break;
															case $forum_userid_2:
																$cs_username_2 = "$cs_username_2 <b>(C)</b>";
																break;
															case $forum_userid_3:
																$cs_username_3 = "$cs_username_3 <b>(C)</b>";
																break;
															case $forum_userid_4:
																$cs_username_4 = "$cs_username_4 <b>(C)</b>";
																break;
															case $forum_userid_5:
																$cs_username_5 = "$cs_username_5 <b>(C)</b>";
																break;
														}
														
														$cs_username_1 = "<a href=\"http://www.gaminga.com/foros/miembros/$forum_userid_1-$forum_username_1/\">$cs_username_1</a>";
														$cs_username_2 = "<a href=\"http://www.gaminga.com/foros/miembros/$forum_userid_2-$forum_username_2/\">$cs_username_2</a>";
														$cs_username_3 = "<a href=\"http://www.gaminga.com/foros/miembros/$forum_userid_3-$forum_username_3/\">$cs_username_3</a>";
														$cs_username_4 = "<a href=\"http://www.gaminga.com/foros/miembros/$forum_userid_4-$forum_username_4/\">$cs_username_4</a>";
														$cs_username_5 = "<a href=\"http://www.gaminga.com/foros/miembros/$forum_userid_5-$forum_username_5/\">$cs_username_5</a>";
														
														if($table_alt % 2 != '0')
														{
															?>
																<tr><td><?php echo $groupname; ?></td><td><?php echo $cs_username_1; ?></td><td><?php echo $cs_username_2; ?></td><td><?php echo $cs_username_3; ?></td><td><?php echo $cs_username_4; ?></td><td><?php echo $cs_username_5; ?></td></tr>
															<?php
														}
														else
														{
															?>
																<tr class="alt"><td><?php echo $groupname; ?></td><td><?php echo $cs_username_1; ?></td><td><?php echo $cs_username_2; ?></td><td><?php echo $cs_username_3; ?></td><td><?php echo $cs_username_4; ?></td><td><?php echo $cs_username_5; ?></td></tr>
															<?php
														}
														
														$table_alt = $table_alt + 1;
													}
							?>
										</tbody>
									</table>
								</div>
							<?php
							}
							else
							{
						?>
								<p style="padding-left:20px;">No hay grupos inscriptos.</p>
						<?php
							}
						?>
						
						<br>
						
						<p style="color:cornsilk;font-weight:bold;text-align:center;padding-left:10px;overflow:hidden;background:none repeat scroll 0 0 #3D5370;" class="server_result_line_impar">
							<span style="font-size:150%;display:inline-block;">FORMALIDADES</span>
						</p>
						
						<p style="padding-left:20px;">Todos los integrantes del equipo deben estar registrados en GAM!NGA.</p>
						<p style="padding-left:20px;">Cada equipo estará formado por cinco jugadores, dos que jugarán como defensor y los otros tres como atacantes.</p>
						<p style="padding-left:20px;">El equipo puede decidir si tener o no un suplente, este suplente se debe encontrar de espectador en el momento del encuentro y tendrá la pantalla oscura.</p>
						<p style="padding-left:20px;">Cada equipo estará formado por cinco jugadores, dos que jugarán como defensor y los otros tres como atacantes.</p>
						<p style="padding-left:20px;">A pesar de que haya dos defensores y tres atacantes, cada equipo decide que rol jugar o que hacer, por lo que no hay ningún problema que los defensores ataquen así como también los atacantes defiendan.</p>
						<p style="padding-left:20px;">El torneo es de modo clasificación, un solo mapa, solo en la final se jugarán dos, en caso de empate, se jugará un tercero.</p>
						<p style="padding-left:20px;">Los capitanes de cada equipo jugarán una ronda a cuchillo, el capitán ganador elige el lado.</p>
						<p style="padding-left:20px;">El equipo ganador es aquel que haya capturado mayor cantidad de banderas al final del mapa (25 minutos).</p>
						<p style="padding-left:20px;">En caso de que uno de los jugadores deje el juego inesperadamente por cualquier motivo, se dará una tolerancia de dos minutos para que vuelva o que ingrese el suplente (si es que hay) para que lo reemplace, en caso de no volver, el equipo quedará descalificado.</p>
						<p style="padding-left:20px;">Regla demo</p>
						
						<p style="color:cornsilk;font-weight:bold;text-align:center;padding-left:10px;overflow:hidden;background:none repeat scroll 0 0 #3D5370;" class="server_result_line_impar">
							<span style="font-size:150%;display:inline-block;">MAPAS</span>
						</p>
						
						<p style="padding-left:20px;">Los mapas que se jugarán son:
							<ul>
								<li>de_inferno</li>
								<li>de_tuscan</li>
								<li>de_mirage</li>
								<li>de_dust2</li>
								<li>de_nuke</li>
							</ul>
						</p>
						
						<p style="color:cornsilk;font-weight:bold;text-align:center;padding-left:10px;overflow:hidden;background:none repeat scroll 0 0 #3D5370;" class="server_result_line_impar">
							<span style="font-size:150%;display:inline-block;">FECHAS</span>
						</p>
						
						<p style="padding-left:20px;"><span style="font-weight:bold">Viernes 04/07 a las 20:00</span></p>
						<p style="padding-left:35px;">Se juegan cuatro encuentros clasificatorios, los equipos ganadores pasan a semi-finales.</p>
						<p style="padding-left:20px;"><span style="font-weight:bold">Sábado 05/07 a las 20:00</span></p>
						<p style="padding-left:35px;">Se juegan dos encuentros, los equipos ganadores pasan a la final.</p>
						<p style="padding-left:20px;"><span style="font-weight:bold">Domingo 06/07 a las 15:00</span></p>
						<p style="padding-left:35px;">Final.</p>
						
						<p style="color:cornsilk;font-weight:bold;text-align:center;padding-left:10px;overflow:hidden;background:none repeat scroll 0 0 #3D5370;" class="server_result_line_impar">
							<span style="font-size:150%;display:inline-block;">PREMIO</span>
						</p>
						
						<p style="padding-left:20px;"><span style="font-weight:bold">Se otorgará un mes de premium a cada integrante del equipo ganador.</span></p>
						
						<p style="color:cornsilk;font-weight:bold;text-align:center;padding-left:10px;overflow:hidden;background:none repeat scroll 0 0 #3D5370;" class="server_result_line_impar">
							<span style="font-size:150%;display:inline-block;">INSCRIPCIONES</span>
						</p>
						
						<p style="padding-left:20px;">Ingrese en los campos de la izquierda los nombres de usuario en el foro, <b>respetando</b> signos de puntuación.</p>
						<p style="padding-left:20px;">Ingrese en los campos de la derecha los nombres que utilizarán en el CS, <b>respetando</b> mayúsculas, minúsculas y signos de puntuación.</p>
						<p style="padding-left:20px;">Elija al capitan marcando el botón correspondiente ubicado al final de cada usuario.</p>
						
						<form method="POST" action="/torneo_ctf/torneo_ctf_confirm/" name="comprarpremium" id="comprarpremium">
							<div class="clear">
								<p style="float:left;width:165px;">Nombre del equipo:</p>
								<p style="float:left;width:145px;"><input type="text" name="cs_groupname" size="74" class="required" value="<?php echo $_POST['cs_groupname']; ?>"/></p>
							</div>
							
							<div class="clear">
								<p style="float:left;width:165px;">Usuario foro y CS <b>#01</b>:</p>
								<p style="float:left;width:145px;"><input type="text" name="forum_username1" size="22" class="required" value="<?php echo $_POST['forum_username1']; ?>"/></p>
								<p style="float:left;width:145px;"><input type="text" name="cs_username1" size="45" class="required" value="<?php echo $_POST['cs_username1']; ?>"/></p>
								<input type="radio" name="capitan" value="1" style="float:right;" <?php echo $checked_1; ?> />
							</div>
							
							<div class="clear">
								<p style="float:left;width:165px;">Usuario foro y CS <b>#02</b>:</p>
								<p style="float:left;width:145px;"><input type="text" name="forum_username2" size="22" class="required" value="<?php echo $_POST['forum_username2']; ?>"/></p>
								<p style="float:left;width:145px;"><input type="text" name="cs_username2" size="45" class="required" value="<?php echo $_POST['cs_username2']; ?>"/></p>
								<input type="radio" name="capitan" value="2" style="float:right;" <?php echo $checked_2; ?> />
							</div>
							
							<div class="clear">
								<p style="float:left;width:165px;">Usuario foro y CS <b>#03</b>:</p>
								<p style="float:left;width:145px;"><input type="text" name="forum_username3" size="22" class="required" value="<?php echo $_POST['forum_username3']; ?>"/></p>
								<p style="float:left;width:145px;"><input type="text" name="cs_username3" size="45" class="required" value="<?php echo $_POST['cs_username3']; ?>"/></p>
								<input type="radio" name="capitan" value="3" style="float:right;" <?php echo $checked_3; ?> />
							</div>
							
							<div class="clear">
								<p style="float:left;width:165px;">Usuario foro y CS <b>#04</b>:</p>
								<p style="float:left;width:145px;"><input type="text" name="forum_username4" size="22" class="required" value="<?php echo $_POST['forum_username4']; ?>"/></p>
								<p style="float:left;width:145px;"><input type="text" name="cs_username4" size="45" class="required" value="<?php echo $_POST['cs_username4']; ?>"/></p>
								<input type="radio" name="capitan" value="4" style="float:right;" <?php echo $checked_4; ?> />
							</div>
							
							<div class="clear">
								<p style="float:left;width:165px;">Usuario foro y CS <b>#05</b>:</p>
								<p style="float:left;width:145px;"><input type="text" name="forum_username5" size="22" class="required" value="<?php echo $_POST['forum_username5']; ?>"/></p>
								<p style="float:left;width:145px;"><input type="text" name="cs_username5" size="45" class="required" value="<?php echo $_POST['cs_username5']; ?>"/></p>
								<input type="radio" name="capitan" value="5" style="float:right;" <?php echo $checked_5; ?> />
							</div>
							
							<div class="clear">
								<p style="float:left;width:165px;">Usuario foro y CS <b>#06</b>: (SUPLENTE - OPCIONAL)</p>
								<p style="float:left;width:145px;"><input type="text" name="forum_username6" size="22" class="optional" value="<?php echo $_POST['forum_username6']; ?>"/></p>
								<p style="float:left;width:32px;"><input type="text" name="cs_username6" size="45" class="optional" value="<?php echo $_POST['cs_username6']; ?>"/></p>
							</div>
							
							<div class="clear">
								<p style="padding-left:20px;">Una vez que inscribas a tu equipo, deberás esperar que uno de los encargados del torneo apruebe tu solicitud.</p>
								<p style="padding-left:20px;">Cuando esté aprobada, tu equipo aparecerá en la tabla superior de esta misma página.</p>
							</div>
							
							<div class="premium_submit">
								<input type="submit" class="search_submit" name="k_ctf" style="width:300px;" value="INSCRIBIR EQUIPO"/>
							</div>
							
							<br class="clear"/>
						</form>
						<?php
					}
					else
					{
						?>
							<p style="padding-left:20px;"><span style="font-weight:bold;">Debe registrarse/identificarse en el foro para visualizar esta página.</span>
						<?php
					}
				?>
			</div>
		</div>
	</div>
	
	<div id="sidebar">
		<?php include("/var/www/gaminga.com/public_html/common/vbulletin_user.php"); ?>
		<div class="box_title">
			<div class="box_txt sidebar">Destacado</div>
			<div class="box_rss"></div>
		</div>
		
		<div class="box_cuerpo">
			<center><?php include("/var/www/gaminga.com/public_html/ads/includes/300_100.php"); ?></center>
		</div>
		<br />
		
		<div class="box_title">
			<div class="box_txt sidebar">Destacado</div>
			<div class="box_rss"></div>
		</div>
		
		<div class="box_cuerpo">
			<?php include("/var/www/gaminga.com/public_html/ads/includes/300_250.php"); ?>
		</div>
		<br />
		
		<div>
			<iframe scrolling="no" height="164" frameborder="0" width="310" src="/widgets/noticias/feed_310.php" marginheight="0" marginwidth="0"></iframe>
		</div>
		<br />
		
		<div class="box_title">
			<div class="box_txt sidebar">Destacado</div>
			<div class="box_rss"></div>
		</div>
		
		<div class="box_cuerpo">
			<?php include("/var/www/gaminga.com/public_html/ads/includes/300_250_2.php"); ?>
		</div>
		<br />
		
		<div class="social_share">
			<?php include ("/var/www/gaminga.com/public_html/common/social_share.php"); ?>
		</div>
	</div>
	<br class="clear"/>

<?php
include("/var/www/gaminga.com/public_html/common/footer.php");
?>