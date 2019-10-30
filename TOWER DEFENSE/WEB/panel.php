<?php
	include ("/var/www/gaminga.com/public_html/common/config.php");
	include ("/var/www/gaminga.com/public_html/common/config_sv.php");
	include ("/var/www/gaminga.com/public_html/common/global.php");
	include ("/var/www/gaminga.com/public_html/common/connect.php");
	
	$ptitle = ' - Servidores - Counter-Strike - Tower Defense - Panel de Control';
	$pdesc = 'Panel de control del servidor Tower Defense';
	$ptag = 'tower, defense, td, taringacs, servidores';
	$pinclude .= '
		<script type="text/javascript" language="javascript">
			$(document).ready(function() {
				$(".reglas_title a").click(function(){
					$(this).closest("div").next(".reglas_data").toggle("slow");
				});
			});
		</script>';
	$certifica = '/Portada/servidores/counter-strike/27035';
	
	include("/var/www/gaminga.com/public_html/common/header.php");
	
	$vb_email = $vbulletin->userinfo['email'];
	$vb_group = $vbulletin->userinfo['usergroupid'];
	$vb_nick = $vbulletin->userinfo['username'];
	$vb_userid = $vbulletin->userinfo['userid'];
	
	if ( ($vb_group != '1') && ($vb_group != '3') && ($vb_group != '30') && ($vb_group != '37') && ($vb_group != '') ) {
		$vb_correcto = '1';
	} else {
		$vb_correcto = '0';
	}
?>

<div id="cuerpocontainer">
	<div id="izquierda">
		<div class="breadcrump">
			<ul>
				<li class="first"><a href="/servidores/counter-strike/" title="Servidores">Servidores</a></li>
				<li><a href="/servidores/counter-strike/" title="Counter-Strike">Counter-Strike</a></li>
				<li><a href="/servidores/counter-strike/27035/" title="Tower Defense">Tower Defense</a></li>
				<li><h1 class="titulo_head">Panel de Control</h1></li>
				<li class="last"></li>
			</ul>
		</div>
		
		<br class="clear">
		
		<div class="entrybody">
			<div class="box_title">
				<div class="box_txt ultimos_posts">Tower Defense - Panel de Control</div>
				<div class="box_rss"/>
			</div>
		</div>
		
		<div class="box_cuerpo">
			<?php
				$coincidencias = 0;
				
				$getdata = mysql_query("SELECT * FROM vinculos WHERE vb_userid = '".$vb_userid."' AND td <> '0'") or die("Se produjo un error, por favor notifique al webmaster. (1)");
				$coincidencias = mysql_num_rows($getdata);
				
				if($coincidencias == '0') {
					if(($vb_nick != 'No Registrado') && ($vb_correcto == '1')) {
						?>
							<p>Ingres&aacute; el usuario y contrase&ntilde;a de tu cuenta del Tower Defense.</p>
							<p>Al hacerlo, vas a poder vincular tu cuenta de GAM!NGA con la cuenta del servidor Tower Defense y poder acceder al panel de control.</p>
							
							<form action="/servidores/counter-strike/27035/vinculacion/" method="post"> 
								<fieldset style="border:0px;" class="loginchat">
									<dl>
										<dt style="margin-left:25px;">Usuario</dt>			
										<dd><input id="login" name="jb_username" type="text" tabindex="1" accesskey="u"/></dd>
									</dl>
									
									<dl>
										<dt style="margin-left:25px;">Contrase&ntilde;a</dt>
										<dd><input id="password" name="jb_password" type="password" tabindex="1"/></dd>
									</dl>
								</fieldset>
								
								<p style="text-align:center;"><input type="submit" value="Vincular!" class="boton_nice" style="cursor:pointer;color:#FFF;font-weight:bold;"/></p>
							</form>
						<?php
					} else {
						if($vb_group == '3') {
							?>
								Para poder visualizar el panel de control de tu usuario en el servidor Tower Defense debes validar tu cuenta de GAM!NGA. 
								<br /><a href="/foros/register.php?do=requestemail" title="Validar cuenta">Validar cuenta!</a></p>
							<?php
						} else {
							?>
								<p>Para poder visualizar el panel de control de tu usuario en el servidor Tower Defense debes estar registrado e identificado en GAM!NGA.</p>
							<?php
						}
					}
				} else {
					while($data = mysql_fetch_array($getdata)) {
						$td_id = $data['td'];
					}
					
					include ("/var/www/gaminga.com/public_html/common/config_td.php");
					include ("/var/www/gaminga.com/public_html/common/connect.php");
					
					$getdata_td = mysql_query("SELECT * FROM td_users WHERE id = '".$td_id."'") or die("Se produjo un error, por favor notifique al webmaster. (2)");
					
					while($data_td = mysql_fetch_array($getdata_td)) {
						$td_name = $data_td['name'];
						
						$td_registrado_fecha = $data_td['register'];
						$td_last_connect_fecha = $data_td['last_connect'];
						
						$td_kills = $data_td['kills'];
						$td_soldier_lvl = $data_td['soldier_lvl'];
						$td_soldier_kills = $data_td['soldier_kills'];
						$td_engineer_lvl = $data_td['engineer_lvl'];
						$td_engineer_dmg = $data_td['engineer_dmg'];
						$td_support_lvl = $data_td['support_lvl'];
						$td_support_dmg = $data_td['support_dmg'];
						$td_sniper_lvl = $data_td['sniper_lvl'];
						$td_sniper_kills = $data_td['sniper_kills'];
						$td_levelg = $data_td['levelg'];
						$td_achievement_count = $data_td['achievement_count'];
						$td_osmios = $data_td['osmios'];
						$td_mvp = $data_td['mvp'];
						$td_gold = $data_td['gold'];
					}
					
					$getdata_td = mysql_query("SELECT * FROM td_waveboss WHERE td_id = '".$td_id."'") or die("Se produjo un error, por favor notifique al webmaster. (7)");
					
					while($data_td = mysql_fetch_array($getdata_td)) {
						$td_waves_normal = explode(" ", $data_td['waves_normal']);
						$td_waves_nightmare = explode(" ", $data_td['waves_nightmare']);
						$td_waves_suicidal = explode(" ", $data_td['waves_suicidal']);
						$td_waves_hell = explode(" ", $data_td['waves_hell']);
						
						$td_boss_normal = $data_td['boss_normal'];
						$td_boss_nightmare = $data_td['boss_nightmare'];
						$td_boss_suicidal = $data_td['boss_suicidal'];
						$td_boss_hell = $data_td['boss_hell'];
					}
					
					for($i = 0; $i < 11; $i++) {
						$td_waves_normal[$i] = number_format($td_waves_normal[$i], 0, '', '.');
						$td_waves_nightmare[$i] = number_format($td_waves_nightmare[$i], 0, '', '.');
						$td_waves_suicidal[$i] = number_format($td_waves_suicidal[$i], 0, '', '.');
						$td_waves_hell[$i] = number_format($td_waves_hell[$i], 0, '', '.');
					}
					
					$td_boss_normal = number_format($td_boss_normal, 0, '', '.');
					$td_boss_nightmare = number_format($td_boss_nightmare, 0, '', '.');
					$td_boss_suicidal = number_format($td_boss_suicidal, 0, '', '.');
					$td_boss_hell = number_format($td_boss_hell, 0, '', '.');
					
					$td_registrado_fecha = strtotime($td_registrado_fecha);
					$td_registrado_fecha = date("d/m/Y - H:i:s", $td_registrado_fecha);
					
					$td_last_connect_fecha = strtotime($td_last_connect_fecha);
					$td_last_connect_fecha = date("d/m/Y - H:i:s", $td_last_connect_fecha);
					
					$td_kills = number_format($td_kills, 0, '', '.');
					$td_soldier_kills = number_format($td_soldier_kills, 0, '', '.');
					$td_engineer_dmg = number_format($td_engineer_dmg, 0, '', '.');
					$td_support_dmg = number_format($td_support_dmg, 0, '', '.');
					$td_sniper_kills = number_format($td_sniper_kills, 0, '', '.');
					$td_osmios = number_format($td_osmios, 0, '', '.');
					$td_mvp = number_format($td_mvp, 0, '', '.');
					$td_gold = number_format($td_gold, 0, '', '.');
					
					$td_name_html = str_replace(' ', '&nbsp;', $td_name);
					
					?>
						<p>Tu cuenta en el servidor Tower Defense es: <b><?php echo $td_name_html; ?></b></p>
						<p>Te registraste el <b><?php echo $td_registrado_fecha; ?></b></p>
						<p>Tu última conexión fue el <b><?php echo $td_last_connect_fecha; ?></b></p>
					<?php
					
					if ($vb_group == '34') {
						?>
							<p style="font-weight:bold;padding-left:10px;background-color:DarkGoldenRod;text-align:center;color:#FFF;;" class="server_result_line_impar">- <a href="/premium/" title="Premium" style="color:#FFF;">SOS USUARIO PREMIUM</a> -</p>
						<?php
					}
					
					?>
					
					<p style="font-weight:bold;padding-left:10px;" class="server_result_line_impar">INFORMACI&Oacute;N</p>
						<p style="padding-left:20px;"><span style="font-weight:bold;">NIVEL G!:</span> <?php echo $td_levelg; ?>
						<p style="padding-left:20px;"><span style="font-weight:bold;">ZOMBIES MATADOS:</span> <?php echo $td_kills; ?>
						<p style="padding-left:20px;"><span style="font-weight:bold;">LOGROS DESBLOQUEADOS:</span> <?php echo $td_achievement_count; ?>
						<p style="padding-left:20px;"><span style="font-weight:bold;">OSMIOS:</span> <?php echo $td_osmios; ?>
						<p style="padding-left:20px;"><span style="font-weight:bold;">MVP GANADOS:</span> <?php echo $td_mvp; ?>
						<p style="padding-left:20px;"><span style="font-weight:bold;">ORO GANADO:</span> <?php echo $td_gold; ?>
						
					<p style="font-weight:bold;padding-left:10px;" class="server_result_line_impar">SOLDADO</p>
						<p style="padding-left:20px;"><span style="font-weight:bold;">NIVEL: </span> <?php echo $td_soldier_lvl; ?>
						<p style="padding-left:20px;"><span style="font-weight:bold;">MATADOS:</span> <?php echo $td_soldier_kills; ?>
						
					<p style="font-weight:bold;padding-left:10px;" class="server_result_line_impar">INGENIERO</p>
						<p style="padding-left:20px;"><span style="font-weight:bold;">NIVEL:</span> <?php echo $td_engineer_lvl; ?>
						<p style="padding-left:20px;"><span style="font-weight:bold;">DAÑO HECHO:</span> <?php echo $td_engineer_dmg; ?>
						
					<p style="font-weight:bold;padding-left:10px;" class="server_result_line_impar">SOPORTE</p>
						<p style="padding-left:20px;"><span style="font-weight:bold;">NIVEL:</span> <?php echo $td_support_lvl; ?>
						<p style="padding-left:20px;"><span style="font-weight:bold;">DAÑO HECHO:</span> <?php echo $td_support_dmg; ?>
						
					<p style="font-weight:bold;padding-left:10px;" class="server_result_line_impar">FRANCOTIRADOR</p>
						<p style="padding-left:20px;"><span style="font-weight:bold;">NIVEL:</span> <?php echo $td_sniper_lvl; ?>
						<p style="padding-left:20px;"><span style="font-weight:bold;">DAÑO HECHO:</span> <?php echo $td_sniper_kills; ?>
					
					<br><br>
					
					<div class="reglas_title">
						<p style="font-weight:bold;padding-left:10px;background:none repeat scroll 0 0 #FE9A2E;line-height:25px;">&#8226; <a href="#01" title="VER JEFES MATADOS POR DIFICULTAD">VER JEFES MATADOS POR DIFICULTAD</a></p>
					</div>
					
					<div class="reglas_data" name="01" style="display:none;">
						<p style="padding-left:20px;"><span style="font-weight:bold;">NORMAL:</span> <?php echo $td_boss_normal; ?>
						<p style="padding-left:20px;"><span style="font-weight:bold;">NIGHTMARE:</span> <?php echo $td_boss_nightmare; ?>
						<p style="padding-left:20px;"><span style="font-weight:bold;">SUICIDAL:</span> <?php echo $td_boss_suicidal; ?>
						<p style="padding-left:20px;"><span style="font-weight:bold;">HELL:</span> <?php echo $td_boss_hell; ?>
					</div>
					
					<div class="reglas_title">
						<p style="font-weight:bold;padding-left:10px;background:none repeat scroll 0 0 #FE9A2E;line-height:25px;">&#8226; <a href="#02" title="VER CANTIDAD DE OLEADAS GANADAS POR DIFICULTAD">VER CANTIDAD DE OLEADAS GANADAS POR DIFICULTAD</a></p>
					</div>
					
					<div class="reglas_data" name="02" style="display:none;">
						<div style="padding-left:20px;" class="reglas_title">
							<p style="font-weight:bold;padding-left:10px;background:none repeat scroll 0 0 #F5DA81;line-height:25px;">&#8226; <a href="#03" title="NORMAL">NORMAL</a></p>
						</div>
					
						<div class="reglas_data" name="03" style="display:none;">
							<p style="padding-left:40px;"><span style="font-weight:bold;">TOTAL:</span> <?php echo $td_waves_normal[0]; ?>
							<?php
								for($i = 1; $i < 11; $i++) {
									?>
										<p style="padding-left:40px;"><span style="font-weight:bold;">OLEADA <?php echo $i; ?>:</span> <?php echo $td_waves_normal[$i]; ?>
									<?php
								}
							?>
						</div>
						
						<div style="padding-left:20px;" class="reglas_title">
							<p style="font-weight:bold;padding-left:10px;background:none repeat scroll 0 0 #F5DA81;line-height:25px;">&#8226; <a href="#04" title="NIGHTMARE">NIGHTMARE</a></p>
						</div>
						
						<div class="reglas_data" name="04" style="display:none;">
							<p style="padding-left:40px;"><span style="font-weight:bold;">TOTAL:</span> <?php echo $td_waves_nightmare[0]; ?>
							<?php
								for($i = 1; $i < 11; $i++) {
									?>
										<p style="padding-left:40px;"><span style="font-weight:bold;">OLEADA <?php echo $i; ?>:</span> <?php echo $td_waves_nightmare[$i]; ?>
									<?php
								}
							?>
						</div>
						
						<div style="padding-left:20px;" class="reglas_title">
							<p style="font-weight:bold;padding-left:10px;background:none repeat scroll 0 0 #F5DA81;line-height:25px;">&#8226; <a href="#05" title="SUICIDAL">SUICIDAL</a></p>
						</div>
						
						<div class="reglas_data" name="05" style="display:none;">
							<p style="padding-left:40px;"><span style="font-weight:bold;">TOTAL:</span> <?php echo $td_waves_suicidal[0]; ?>
							<?php
								for($i = 1; $i < 11; $i++) {
									?>
										<p style="padding-left:40px;"><span style="font-weight:bold;">OLEADA <?php echo $i; ?>:</span> <?php echo $td_waves_suicidal[$i]; ?>
									<?php
								}
							?>
						</div>
						
						<div style="padding-left:20px;" class="reglas_title">
							<p style="font-weight:bold;padding-left:10px;background:none repeat scroll 0 0 #F5DA81;line-height:25px;">&#8226; <a href="#06" title="HELL">HELL</a></p>
						</div>
						
						<div class="reglas_data" name="06" style="display:none;">
							<p style="padding-left:40px;"><span style="font-weight:bold;">TOTAL:</span> <?php echo $td_waves_hell[0]; ?>
							<?php
								for($i = 1; $i < 11; $i++) {
									?>
										<p style="padding-left:40px;"><span style="font-weight:bold;">OLEADA <?php echo $i; ?>:</span> <?php echo $td_waves_hell[$i]; ?>
									<?php
								}
							?>
						</div>
					</div>
					
					<div class="reglas_title">
						<p style="font-weight:bold;padding-left:10px;background:none repeat scroll 0 0 #FE9A2E;line-height:25px;">&#8226; <a href="/servidores/counter-strike/27035/times/" title="MEJORES TIEMPOS">MEJORES TIEMPOS</a></p>
					</div>
					
					<br class="clear"/>
					
					<p style="font-weight: bold;padding-left:10px;" class="server_result_line_impar">HERRAMIENTAS</p>
						<p style="float:left;width:50%;margin-left:20px;"><img src="/images/key.gif" alt="Generar contrase&ntilde;a" style="vertical-align:middle;"/> <a href="/servidores/counter-strike/27035/generar/" title="Generar contrase&ntilde;a">&iquest;Olvidaste tu contrase&ntilde;a&#63;</a></p>
						<p style="float:left;width:50%;margin-left:20px;"><img src="/images/cog.gif" alt="Eliminar vinculaci&oacute;n" style="vertical-align:middle;"/> <a href="/servidores/counter-strike/27035/eliminacion/" title="Eliminar vinculaci&oacute;n">Eliminar vinculaci&oacute;n</a></p>
						<p style="float:left;width:50%;margin-left:20px;"><img src="/images/lock.gif" alt="Cambiar contrase&ntilde;a" style="vertical-align:middle;"/> <a href="/servidores/counter-strike/27035/password/" title="Cambiar contrase&ntilde;a">Cambiar contrase&ntilde;a</a></p>
					<br class="clear"/>
					
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