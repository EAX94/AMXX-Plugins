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
						$cs_groupname = mysql_real_escape_string($_POST['cs_groupname']);
						
						$forum_username1 = mysql_real_escape_string($_POST['forum_username1']);
						$forum_username2 = mysql_real_escape_string($_POST['forum_username2']);
						$forum_username3 = mysql_real_escape_string($_POST['forum_username3']);
						$forum_username4 = mysql_real_escape_string($_POST['forum_username4']);
						$forum_username5 = mysql_real_escape_string($_POST['forum_username5']);
						$forum_username6 = mysql_real_escape_string($_POST['forum_username6']);
						
						$cs_username1 = mysql_real_escape_string($_POST['cs_username1']);
						$cs_username2 = mysql_real_escape_string($_POST['cs_username2']);
						$cs_username3 = mysql_real_escape_string($_POST['cs_username3']);
						$cs_username4 = mysql_real_escape_string($_POST['cs_username4']);
						$cs_username5 = mysql_real_escape_string($_POST['cs_username5']);
						$cs_username6 = mysql_real_escape_string($_POST['cs_username6']);
						
						$capitan = mysql_real_escape_string($_POST['capitan']);
						
						$capitan = $capitan - 1;
						
						$pos = 0;
						
						$query = mysql_query("SELECT userid FROM user WHERE username = '".$forum_username1."';") or die("Se produjo un error, por favor notifique al webmaster. (1)");
						$result = mysql_num_rows($query);
						
						if($result == '1')
						{
							while($data = mysql_fetch_array($query))
							{
								$userid[$pos] = $data['userid'];
								$pos = $pos + 1;
							}
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
										<p>El nombre de usuario en el foro del integrante #01 esta mal escrito, <a href="javascript:history.back();" title="Vuelva atr&aacute;s"><b>vuelva atr&aacute;s</b></a> e intente nuevamente.</p>
									</div>
								</div>
							<?php
						}
						
						if($pos == '1')
						{
							$query = mysql_query("SELECT userid FROM user WHERE username = '".$forum_username2."';") or die("Se produjo un error, por favor notifique al webmaster. (2)");
							$result = mysql_num_rows($query);
							
							if($result == '1')
							{
								while($data = mysql_fetch_array($query))
								{
									$userid[$pos] = $data['userid'];
									$pos = $pos + 1;
								}
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
											<p>El nombre de usuario en el foro del integrante #02 esta mal escrito, <a href="javascript:history.back();" title="Vuelva atr&aacute;s"><b>vuelva atr&aacute;s</b></a> e intente nuevamente.</p>
										</div>
									</div>
								<?php
							}
							
							if($pos == '2')
							{
								$query = mysql_query("SELECT userid FROM user WHERE username = '".$forum_username3."';") or die("Se produjo un error, por favor notifique al webmaster. (3)");
								$result = mysql_num_rows($query);
								
								if($result == '1')
								{
									while($data = mysql_fetch_array($query))
									{
										$userid[$pos] = $data['userid'];
										$pos = $pos + 1;
									}
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
												<p>El nombre de usuario en el foro del integrante #03 esta mal escrito, <a href="javascript:history.back();" title="Vuelva atr&aacute;s"><b>vuelva atr&aacute;s</b></a> e intente nuevamente.</p>
											</div>
										</div>
									<?php
								}
								
								if($pos == '3')
								{
									$query = mysql_query("SELECT userid FROM user WHERE username = '".$forum_username4."';") or die("Se produjo un error, por favor notifique al webmaster. (4)");
									$result = mysql_num_rows($query);
									
									if($result == '1')
									{
										while($data = mysql_fetch_array($query))
										{
											$userid[$pos] = $data['userid'];
											$pos = $pos + 1;
										}
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
													<p>El nombre de usuario en el foro del integrante #04 esta mal escrito, <a href="javascript:history.back();" title="Vuelva atr&aacute;s"><b>vuelva atr&aacute;s</b></a> e intente nuevamente.</p>
												</div>
											</div>
										<?php
									}
									
									if($pos == '4')
									{
										$query = mysql_query("SELECT userid FROM user WHERE username = '".$forum_username5."';") or die("Se produjo un error, por favor notifique al webmaster. (5)");
										$result = mysql_num_rows($query);
										
										if($result == '1')
										{
											while($data = mysql_fetch_array($query))
											{
												$userid[$pos] = $data['userid'];
												$pos = $pos + 1;
											}
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
														<p>El nombre de usuario en el foro del integrante #05 esta mal escrito, <a href="javascript:history.back();" title="Vuelva atr&aacute;s"><b>vuelva atr&aacute;s</b></a> e intente nuevamente.</p>
													</div>
												</div>
											<?php
										}
										
										if($pos == '5')
										{
											if($forum_username6 != '')
											{
												$query = mysql_query("SELECT userid FROM user WHERE username = '".$forum_username6."';") or die("Se produjo un error, por favor notifique al webmaster. (6)");
												$result = mysql_num_rows($query);
												
												if($result == '1')
												{
													while($data = mysql_fetch_array($query))
													{
														$userid[$pos] = $data['userid'];
														$pos = $pos + 1;
													}
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
																<p>El nombre de usuario en el foro del integrante #06 esta mal escrito, <a href="javascript:history.back();" title="Vuelva atr&aacute;s"><b>vuelva atr&aacute;s</b></a> e intente nuevamente.</p>
															</div>
														</div>
													<?php
												}
											}
											
											if($result == '1' || ($result == '0' && $forum_username6 == ''))
											{
												include	("/var/www/gaminga.com/public_html/kiske/config_kk.php");
												include ("/var/www/gaminga.com/public_html/common/connect.php");
												
												$query = mysql_query("INSERT INTO ctf (groupname, usernick1, usernick2, usernick3, usernick4, usernick5, usernick6, username1, username2, username3, username4, username5, username6, userid1, userid2, userid3, userid4, userid5,
												userid6, captain_userid, aprobado) VALUES ('".$cs_groupname."', '".$forum_username1."', '".$forum_username2."', '".$forum_username3."', '".$forum_username4."', '".$forum_username5."', '".$forum_username6."',
												'".$cs_username1."', '".$cs_username2."', '".$cs_username3."', '".$cs_username4."', '".$cs_username5."', '".$cs_username6."',
												'".$userid[0]."', '".$userid[1]."', '".$userid[2]."', '".$userid[3]."', '".$userid[4]."', '".$userid[5]."', '".$userid[$capitan]."', '0');")
												or die("Se produjo un error, por favor notifique al webmaster. (7)");
												
												?>
													<div class="entrybody">
														<div class="box_title">
															<div class="box_txt ultimos_posts">Felicitaciones!</div>
															<div class="box_rss"></div>
														</div>
														<div class="box_cuerpo">	
															<p>Has completado todos los pasos para inscribir a tu equipo, solo debes esperar a que un encargado apruebe tu solicitud y aparecera en la <a href="javascript:history.back();" title="Vuelva atr&aacute;s"><b>p&aacute;gina anterior</b></a>.</p>
														</div>
													</div>
												<?php
											}
										}
									}
								}
							}
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