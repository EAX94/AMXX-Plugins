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
							include ("/var/www/gaminga.com/public_html/kiske/config_kk.php");
							include ("/var/www/gaminga.com/public_html/common/connect.php");
							
							$query = mysql_query("SELECT * FROM ctf WHERE aprobado = '0';") or die("Se produjo un error, por favor notifique al webmaster. (1)");
							$result = mysql_num_rows($query);
							
							if($result > 0)
							{
								?>
									<p style="color:cornsilk;font-weight:bold;text-align:center;padding-left:10px;overflow:hidden;background:none repeat scroll 0 0 #3D5370;" class="server_result_line_impar">
										<span style="font-size:150%;display:inline-block;">SOLICITUDES SIN APROBAR</span>
									</p>
									
									<p style="padding-left:20px;"><span style="font-weight:bold">Revisa que no hayan usuarios repetidos en equipos ya aprobados!</span></p>
									
									<div class="clear">
										<p style="padding-left:20px;"><b>(C)</b> = Capitán.</p>
									</div>
									
								<?php
									while($data = mysql_fetch_array($query))
									{
										$group_id = $data['id'];
										
										$groupname = $data['groupname'];
										
										$cs_username_1 = $data['usernick1'];
										$cs_username_2 = $data['usernick2'];
										$cs_username_3 = $data['usernick3'];
										$cs_username_4 = $data['usernick4'];
										$cs_username_5 = $data['usernick5'];
										$cs_username_6 = $data['usernick6'];
										
										$forum_username_1 = $data['username1'];
										$forum_username_2 = $data['username2'];
										$forum_username_3 = $data['username3'];
										$forum_username_4 = $data['username4'];
										$forum_username_5 = $data['username5'];
										$forum_username_6 = $data['username6'];
										
										$forum_userid_1 = $data['userid1'];
										$forum_userid_2 = $data['userid2'];
										$forum_userid_3 = $data['userid3'];
										$forum_userid_4 = $data['userid4'];
										$forum_userid_5 = $data['userid5'];
										$forum_userid_6 = $data['userid6'];
										
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
										$cs_username_6 = "<a href=\"http://www.gaminga.com/foros/miembros/$forum_userid_6-$forum_username_6/\">$cs_username_6</a>";
								?>
									<p style="padding-left:20px;">EQUIPO: <b><?php echo $groupname ?></b> (ID: <b><?php echo $group_id ?></b>)
										<ul>
											<li><b>FORO:</b> <?php echo $cs_username_1 ?> | <b>CS:</b> <?php echo $forum_username_1 ?></li>
											<li><b>FORO:</b> <?php echo $cs_username_2 ?> | <b>CS:</b> <?php echo $forum_username_2 ?></li>
											<li><b>FORO:</b> <?php echo $cs_username_3 ?> | <b>CS:</b> <?php echo $forum_username_3 ?></li>
											<li><b>FORO:</b> <?php echo $cs_username_4 ?> | <b>CS:</b> <?php echo $forum_username_4 ?></li>
											<li><b>FORO:</b> <?php echo $cs_username_5 ?> | <b>CS:</b> <?php echo $forum_username_5 ?></li>
										<?php
											if($forum_userid_6 == '0')
											{
										?>
												<li>SUPLENTE: <b>NO TIENE</b></li>
										<?php
											}
											else
											{
										?>
											<li><b>SUPLENTE:</b> <b>FORO:</b> <?php echo $cs_username_6 ?> | <b>CS:</b> <?php echo $forum_username_6 ?></li>
										<?php
											}
										?>
										</ul>
									</p>
									
									<br>
									<br>
							<?php
									}
							
							?>
								<form method="POST" action="/torneo_ctf/torneo_ctf_confirm_group/" name="comprarpremium" id="comprarpremium">
									<div class="clear">
										<p style="float:left;width:165px;">Ingresa el ID del equipo que deseas aprobar:</p>
										<p style="float:left;width:145px;"><input type="text" name="groupid" size="74" class="required" value="<?php echo $_POST['groupid']; ?>"/></p>
									</div>
									
									<div class="premium_submit">
										<input type="submit" class="search_submit" name="gk_ctf_cc" style="width:300px;" value="APROBAR SOLICITUD"/>
									</div>
									
									<br class="clear"/>
								</form>
							<?php
							}
							else
							{
								?>
									<p style="padding-left:20px;"><span style="font-weight:bold;">No hay solicitudes sin aprobar.</span>
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