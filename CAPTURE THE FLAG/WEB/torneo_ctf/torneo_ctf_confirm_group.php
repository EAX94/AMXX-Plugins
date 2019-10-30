<?php
if(!$_POST) {
	header("HTTP/1.1 301 Moved Permanently");
	header("Location: http://www.gaminga.com/torneo_ctf/");
}

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
?>

<div id="cuerpocontainer">
	<div id="izquierda">
		<br class="clear">
		<div class="entrybody">
			<div class="box_cuerpo">
				<?php
					if($vb_correcto == '1')
					{
						if($vb_userid == '35170' || $vb_userid == '78584' || $vb_userid == '34901')
						{
							$groupid = mysql_real_escape_string($_POST['groupid']);
							
							include	("/var/www/gaminga.com/public_html/kiske/config_kk.php");
							include ("/var/www/gaminga.com/public_html/common/connect.php");
							
							$query = mysql_query("SELECT id FROM ctf WHERE id = '".$groupid."' AND aprobado = '0';") or die("Se produjo un error, por favor notifique al webmaster. (1)");
							$result = mysql_num_rows($query);
							
							if($result == '1')
							{
								$query = mysql_query("UPDATE ctf SET aprobado = '1' WHERE id = '".$groupid."';") or die("Se produjo un error, por favor notifique al webmaster. (2)");
								
								?>
									<div class="entrybody">
										<div class="box_title">
											<div class="box_txt ultimos_posts">Felicitaciones!</div>
											<div class="box_rss"></div>
										</div>
										<div class="box_cuerpo">	
											<p>El ID del equipo ingresado ha sido aprobado, <a href="javascript:history.back();" title="Vuelva atr&aacute;s"><b>vuelva atr&aacute;s</b></a> y verifique que esto sea correcto.</p>
										</div>
									</div>
								<?php
							}
							else
							{
								?>
									<div class="entrybody">
										<div class="box_title">
											<div class="box_txt ultimos_posts">Ha ocurrido un error!</div>
											<div class="box_rss"></div>
										</div>
										<div class="box_cuerpo">	
											<p>El ID ingresado ya esta aprobado o no existe, <a href="javascript:history.back();" title="Vuelva atr&aacute;s"><b>vuelva atr&aacute;s</b></a> e intente nuevamente.</p>
										</div>
									</div>
								<?php
							}
						}
						else
						{
							?>
								<p style="padding-left:20px;"><span style="font-weight:bold;">No tenes acceso a esta pagina.</span>
							<?php
						}
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