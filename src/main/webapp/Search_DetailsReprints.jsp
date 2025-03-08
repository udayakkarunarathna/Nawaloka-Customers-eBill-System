<!-- create by Udaya -->
<html>

<head>
<link rel="stylesheet" href="pop_style.css"></link>
<meta http-equiv="Content-Language" content="en-us">
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<meta http-equiv="Content-Type"
	content="text/html; charset=windows-1252">

<title>Search Information - Accounts - Lab Investigations
	(CREDIT)</title>

<link rel="stylesheet" type="text/css" href="jax/ext-all.css" />
<script type="text/javascript" src="jax/ext-base.js"></script>
<script type="text/javascript" src="jax/ext-all.js"></script>
<script type="text/javascript" src="ConfirmMessage.js"></script>
<script type="text/javascript">
	function clickIE() {
		if (document.all) {
			(message);
			return false;
		}
	}
	function clickNS(e) {
		if (document.layers || (document.getElementById && !document.all)) {
			if (e.which == 2 || e.which == 3) {
				(message);
				return false;
			}
		}
	}
	if (document.layers) {
		document.captureEvents(Event.MOUSEDOWN);
		document.onmousedown = clickNS;
	} else {
		document.onmouseup = clickNS;
		document.oncontextmenu = clickIE;
	}
	document.oncontextmenu = new Function("return false")
</script>

<script language="JavaScript" type="text/JavaScript">
	function Min() {
		self.parent.moveTo(0, 0);
		self.parent.resizeTo(100, -10);
	}

	function Max() {
		self.parent.moveTo(0, 0);
		self.parent.resizeTo(screen.width, screen.height);
	}

	function disableEnterKey() {

		if (event.keyCode == 13) {
			return false;
		} else {
			return true;
		}

	}
</script>

<link href="eHosStoreStyles.css" rel="stylesheet" type="text/css">

</head>

<body topmargin="0" leftmargin="0" class="optionsTop"
	onLoad="document.f1.refno.focus();">



	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td width="1%" height="30" align="left"
				background="/eHospitalOPDOffice/images/titleMiddle.gif"
				class="titles"><img
				src="/eHospitalOPDOffice/images/titleCorner.gif" width="30"
				height="30" border="0"></td>
			<td valign="middle"
				background="/eHospitalOPDOffice/images/titleMiddle.gif"
				class="titles"><p style="margin-right: 10">Search
					Information - SERVICE NON APPOINTMENT</p></td>
		</tr>
		<tr>
			<td align="left"></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td align="left"></td>
			<td>

				<table width="650" border="0" cellpadding="0" cellspacing="0"
					class="bodyTable">

					<tr>
						<td colspan="4" height="10">&nbsp;</td>
					</tr>
					<tr>

						<form method="POST" action="Ref_Search_DetailsReprints.jsp"
							name="f1">

							<td width="270" height="25" class="rowgrey"><p
									style="margin-left: 10">Reference Number</p></td>
							<td width="10" height="25" class="rowgrey">:</td>
							<td width="230" height="25" class="rowgrey"><input
								name="refno" class="text" tabindex="1"
								onkeydown="return disableEnterKey();" size="22" maxlength="12">
							</td>
							<td width="140" height="25" class="rowgrey"><input name="B1"
								type="submit"
								onClick="this.disabled=true;showMessage('Please Wait','Loading.....');submit();"
								class="submitbut" value=" Search "></td>
						</form>

					</tr>
					<tr>



					</tr>
					<tr>
						<td colspan="4" class="rowTop" height="10">&nbsp;</td>
					</tr>

				</table>

			</td>

		</tr>

	</table>
	<br>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td width="1%" height="30" align="left"
				background="/eHospitalOPDOffice/images/titleMiddle.gif"
				class="titles"><img
				src="/eHospitalOPDOffice/images/titleCorner.gif" width="30"
				height="30" border="0"></td>
			<td valign="middle"
				background="/eHospitalOPDOffice/images/titleMiddle.gif"
				class="titles"><p style="margin-right: 10">Search
					Information - Lab</p></td>
		</tr>
		<tr>
			<td align="left"></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td align="left"></td>
			<td>

				<table width="650" border="0" cellpadding="0" cellspacing="0"
					class="bodyTable">

					<tr>
						<td colspan="4" height="10">&nbsp;</td>
					</tr>
					<tr>

						<form method="POST" action="Ref_Search_DetailsReprints_lab.jsp"
							name="pform">

							<td width="270" height="25" class="rowgrey"><p
									style="margin-left: 10">Reference Number</p></td>
							<td width="10" height="25" class="rowgrey">:</td>
							<td width="230" height="25" class="rowgrey"><input
								name="refno1" class="textBox" tabindex="1"
								onkeydown="return disableEnterKey();" size="22" maxlength="12">
							</td>
							<td width="140" height="25" class="rowgrey"><input name="B2"
								type="submit"
								onClick="this.disabled=true;showMessage('Please Wait','Loading.....');submit();"
								class="submitbut" value=" Search "></td>
						</form>

					</tr>
					<tr>



					</tr>
					<tr>
						<td colspan="4" class="rowTop" height="10">&nbsp;</td>
					</tr>

				</table>

			</td>

		</tr>

	</table>
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">

		<tr>
			<td height="30" align="left"
				background="/eHospitalOPDOffice/images/titleMiddle.gif"
				class="titles"><img
				src="/eHospitalOPDOffice/images/titleCorner.gif" width="30"
				height="30" border="0"></td>
			<td valign="middle"
				background="/eHospitalOPDOffice/images/titleMiddle.gif"
				class="titles"><p style="margin-right: 10">Service
					appointments</p></td>
		</tr>
		<tr>
			<td width="30">&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td width="30">&nbsp;</td>
			<td>

				<table width="650" border="0" cellpadding="0" cellspacing="0"
					class="bodyTable">

					<tr>
						<td colspan="4">&nbsp;</td>
					</tr>

					<form action="Ref_Search_DetailsReprints_Opdapp.jsp" name=""
						method="post">

						<tr>
							<td width="270" height="25" class="rowgrey"><p
									style="margin-left: 10px">Service Reference Number</p></td>
							<td width="10" height="25" class="rowgrey">:</td>
							<td width="230" height="25" class="rowgrey"><input
								name="refNo3" type="text" class="textBox"
								onkeydown="return disableEnterKey();" size="22"></td>
							<td width="140" height="25" class="rowgrey"><input
								name="Submit" type="submit"
								onClick="this.disabled=true;showMessage('Please Wait','Loading.....');submit();"
								class="submitbut" value=" Search "></td>
						</tr>
						<tr>
							<td colspan="4" class="rowTop">&nbsp;</td>
						</tr>
					</form>

				</table>

			</td>
		</tr>
	</table>
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">

		<tr>
			<td height="30" align="left"
				background="/eHospitalOPDOffice/images/titleMiddle.gif"
				class="titles"><img
				src="/eHospitalOPDOffice/images/titleCorner.gif" width="30"
				height="30" border="0"></td>
			<td valign="middle"
				background="/eHospitalOPDOffice/images/titleMiddle.gif"
				class="titles"><p style="margin-right: 10">Theater Payments</p></td>
		</tr>
		<tr>
			<td width="30">&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td width="30">&nbsp;</td>
			<td>

				<table width="650" border="0" cellpadding="0" cellspacing="0"
					class="bodyTable">

					<tr>
						<td colspan="4">&nbsp;</td>
					</tr>

					<form action="Ref_Search_DetailsReprints_Theater.jsp" name=""
						method="post">

						<tr>
							<td width="270" height="25" class="rowgrey"><p
									style="margin-left: 10px">Service Invoice Number</p></td>
							<td width="10" height="25" class="rowgrey">:</td>
							<td width="230" height="25" class="rowgrey"><input
								name="refNo4" type="text" class="textBox"
								onkeydown="return disableEnterKey();" size="22"></td>
							<td width="140" height="25" class="rowgrey"><input
								name="Submit" type="submit"
								onClick="this.disabled=true;showMessage('Please Wait','Loading.....');submit();"
								class="submitbut" value=" Search "></td>
						</tr>
						<tr>
							<td colspan="4" class="rowTop">&nbsp;</td>
						</tr>
					</form>

				</table>

			</td>
		</tr>
	</table>
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">

		<tr>
			<td height="30" align="left"
				background="/eHospitalOPDOffice/images/titleMiddle.gif"
				class="titles"><img
				src="/eHospitalOPDOffice/images/titleCorner.gif" width="30"
				height="30" border="0"></td>
			<td valign="middle"
				background="/eHospitalOPDOffice/images/titleMiddle.gif"
				class="titles"><p style="margin-right: 10">Medical packages</p></td>
		</tr>
		<tr>
			<td width="30">&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td width="30">&nbsp;</td>
			<td>

				<table width="650" border="0" cellpadding="0" cellspacing="0"
					class="bodyTable">

					<tr>
						<td colspan="4">&nbsp;</td>
					</tr>

					<form action="Ref_Search_DetailsReprints_Mpk.jsp" name=""
						method="post">

						<tr>
							<td width="270" height="25" class="rowgrey"><p
									style="margin-left: 10px">Service Reference Number</p></td>
							<td width="10" height="25" class="rowgrey">:</td>
							<td width="230" height="25" class="rowgrey"><input
								name="refNo5" type="text" class="textBox"
								onkeydown="return disableEnterKey();" size="22"></td>
							<td width="140" height="25" class="rowgrey"><input
								name="Submit" type="submit"
								onClick="this.disabled=true;showMessage('Please Wait','Loading.....');submit();"
								class="submitbut" value=" Search "></td>
						</tr>
						<tr>
							<td colspan="4" class="rowTop">&nbsp;</td>
						</tr>
					</form>

				</table>

			</td>
		</tr>
	</table>
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">

		<tr>
			<td height="30" align="left"
				background="/eHospitalOPDOffice/images/titleMiddle.gif"
				class="titles"><img
				src="/eHospitalOPDOffice/images/titleCorner.gif" width="30"
				height="30" border="0"></td>
			<td valign="middle"
				background="/eHospitalOPDOffice/images/titleMiddle.gif"
				class="titles"><p style="margin-right: 10">Initial /
					Further Payments</p></td>
		</tr>
		<tr>
			<td width="30">&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td width="30">&nbsp;</td>
			<td>

				<table width="650" border="0" cellpadding="0" cellspacing="0"
					class="bodyTable">

					<tr>
						<td colspan="4">&nbsp;</td>
					</tr>

					<form action="Ref_Search_DetailsReprints_IFpay.jsp" name=""
						method="post">

						<tr>
							<td width="270" height="25" class="rowgrey"><p
									style="margin-left: 10px">Service Recipt Number</p></td>
							<td width="10" height="25" class="rowgrey">:</td>
							<td width="230" height="25" class="rowgrey"><input
								name="refNo6" type="text" class="textBox"
								onkeydown="return disableEnterKey();" size="22"></td>
							<td width="140" height="25" class="rowgrey"><input
								name="Submit" type="submit"
								onClick="this.disabled=true;showMessage('Please Wait','Loading.....');submit();"
								class="submitbut" value=" Search "></td>
						</tr>
						<tr>
							<td colspan="4" class="rowTop">&nbsp;</td>
						</tr>
					</form>

				</table>

			</td>
		</tr>
	</table>
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">

		<tr>
			<td height="30" align="left"
				background="/eHospitalOPDOffice/images/titleMiddle.gif"
				class="titles"><img
				src="/eHospitalOPDOffice/images/titleCorner.gif" width="30"
				height="30" border="0"></td>
			<td valign="middle"
				background="/eHospitalOPDOffice/images/titleMiddle.gif"
				class="titles"><p style="margin-right: 10">Final Payments</p></td>
		</tr>
		<tr>
			<td width="30">&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td width="30">&nbsp;</td>
			<td>

				<table width="650" border="0" cellpadding="0" cellspacing="0"
					class="bodyTable">

					<tr>
						<td colspan="4">&nbsp;</td>
					</tr>

					<form action="Ref_Search_DetailsReprints_Finalpay.jsp" name=""
						method="post">

						<tr>
							<td width="270" height="25" class="rowgrey"><p
									style="margin-left: 10px">Service Recipt Number</p></td>
							<td width="10" height="25" class="rowgrey">:</td>
							<td width="230" height="25" class="rowgrey"><input
								name="refNo7" type="text" class="textBox"
								onkeydown="return disableEnterKey();" size="22"></td>
							<td width="140" height="25" class="rowgrey"><input
								name="Submit" type="submit"
								onClick="this.disabled=true;showMessage('Please Wait','Loading.....');submit();"
								class="submitbut" value=" Search "></td>
						</tr>
						<tr>
							<td colspan="4" class="rowTop">&nbsp;</td>
						</tr>
					</form>

				</table>

			</td>
		</tr>
	</table>
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">

		<tr>
			<td height="30" align="left"
				background="/eHospitalOPDOffice/images/titleMiddle.gif"
				class="titles"><img
				src="/eHospitalOPDOffice/images/titleCorner.gif" width="30"
				height="30" border="0"></td>
			<td valign="middle"
				background="/eHospitalOPDOffice/images/titleMiddle.gif"
				class="titles"><p style="margin-right: 10">Inward Part
					Payments</p></td>
		</tr>
		<tr>
			<td width="30">&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td width="30">&nbsp;</td>
			<td>

				<table width="650" border="0" cellpadding="0" cellspacing="0"
					class="bodyTable">

					<tr>
						<td colspan="4">&nbsp;</td>
					</tr>

					<form action="Ref_Search_DetailsReprints_IpartPay.jsp" name=""
						method="post">

						<tr>
							<td width="270" height="25" class="rowgrey"><p
									style="margin-left: 10px">Service Recipt Number</p></td>
							<td width="10" height="25" class="rowgrey">:</td>
							<td width="230" height="25" class="rowgrey"><input
								name="refNo8" type="text" class="textBox"
								onkeydown="return disableEnterKey();" size="22"></td>
							<td width="140" height="25" class="rowgrey"><input
								name="Submit" type="submit"
								onClick="this.disabled=true;showMessage('Please Wait','Loading.....');submit();"
								class="submitbut" value=" Search "></td>
						</tr>
						<tr>
							<td colspan="4" class="rowTop">&nbsp;</td>
						</tr>
					</form>

				</table>

			</td>
		</tr>
	</table>
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">

		<tr>
			<td height="30" align="left"
				background="/eHospitalOPDOffice/images/titleMiddle.gif"
				class="titles"><img
				src="/eHospitalOPDOffice/images/titleCorner.gif" width="30"
				height="30" border="0"></td>
			<td valign="middle"
				background="/eHospitalOPDOffice/images/titleMiddle.gif"
				class="titles"><p style="margin-right: 10">Inward Company
					Settlments</p></td>
		</tr>
		<tr>
			<td width="30">&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td width="30">&nbsp;</td>
			<td>

				<table width="650" border="0" cellpadding="0" cellspacing="0"
					class="bodyTable">

					<tr>
						<td colspan="4">&nbsp;</td>
					</tr>

					<form action="Ref_Search_DetailsReprints_IComSt.jsp" name=""
						method="post">

						<tr>
							<td width="270" height="25" class="rowgrey"><p
									style="margin-left: 10px">Service Recipt Number</p></td>
							<td width="10" height="25" class="rowgrey">:</td>
							<td width="230" height="25" class="rowgrey"><input
								name="refNo9" type="text" class="textBox"
								onkeydown="return disableEnterKey();" size="22"></td>
							<td width="140" height="25" class="rowgrey"><input
								name="Submit" type="submit"
								onClick="this.disabled=true;showMessage('Please Wait','Loading.....');submit();"
								class="submitbut" value=" Search "></td>
						</tr>
						<tr>
							<td colspan="4" class="rowTop">&nbsp;</td>
						</tr>
					</form>

				</table>

			</td>
		</tr>
	</table>
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td colspan="2">
				<p style="margin-left: 10" align="left">
				<p style="margin-left: 10; margin-top: 2" align="center">
					<b><font face="Verdana, Arial, Helvetica, sans-serif" size="1"
						color="#0055D5">Copyright &copy; ECHANNELLING LIMITED</font></b>
			</td>
		</tr>
	</table>


	<script type="text/javascript" language="JavaScript1.2"
		src="pop_events.js"></script>

</body>
</html>