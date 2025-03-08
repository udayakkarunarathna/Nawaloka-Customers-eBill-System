<%@ page import="com.model.db.DatabaseConnection"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ include file="noCache.jsp"%>
<html>
<head>
<link rel="stylesheet" href="pop_style.css" />
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
<title>Edit Employee details</title>


<link href="eHosStoreStyles.css" rel="stylesheet" type="text/css">

<style type="text/css">
<!--
.style1 {
	color: #FF0000
}
-->
</style>

</head>

<%
RequestDispatcher dispatcher;
HttpSession sessions = request.getSession(false);
DecimalFormat df = new DecimalFormat();
df.setMaximumFractionDigits(2);
df.setMinimumFractionDigits(2);
if (sessions == null) {
	request.setAttribute("ErrorMessage", "<center> User not logged in. Please log in. </center>");
	request.setAttribute("ErrorType", "ERROR");

	dispatcher = getServletContext().getRequestDispatcher("/ErrorScreen.jsp");
	dispatcher.include(request, response);

} else {

	String usertype = (String) sessions.getValue("usertype");
	String uid1 = (String) sessions.getValue("uid");
	String uid = uid1.toUpperCase();
	String refNo5 = request.getParameter("refNo5");
	refNo5 = refNo5.trim();
	out.println(refNo5);
	int stringlength = refNo5.length();
	String a = "";
	for (int i = 1; i <= 9 - stringlength; i++) {
		a = a + "0";
	}
	refNo5 = "CHM" + a + refNo5;
	if (usertype.equals("Admin") || usertype.equals("User")) {
		if (refNo5.equals("") || refNo5 == null) {
	// set error message
	request.setAttribute("ErrorMessage", "<center>  Please Enter OPD Reference Number </center>");
	request.setAttribute("ErrorType", "ERROR");
	// call the error screen (ErrorScreen.jsp)

	dispatcher = getServletContext().getRequestDispatcher("/ErrorScreen.jsp");
	dispatcher.include(request, response);
		} else {

	DatabaseConnection conn = new DatabaseConnection();

	conn.connectToDB();

	String query = "";
	String NAME = "", AGE = "", TELE = "", EMAIL = "", DOCTOR = "", cBank = "", ccRcpNo = "", cNo = "",
			cAuth = "", UPIN = "", DATE = "", RCPT_NO = "", REF_NO = "", CASHIER_ID = "", DIS_REASON = "",
			PKG_NAME = "";
	String ACC_ID = "", acc = "";

	int PAY_MODE = 0;

	double TOTAL = 0, NET_AMO = 0, DISCOUNT = 0, vat = 0, PKG_AMO = 0;

	ResultSet rs = null;
	try {
		query = "select m.NAME,\n"
				+ "       (NVL(m.AGE_YY, '0') || 'Y ' || NVL(m.AGE_MM, '0') || 'M ')                                      AGE,\n"
				+ "       NVL(m.TELE, '-'),\n" + "       NVL(m.EMAIL, '-'),\n"
				+ "       NVL((SELECT l.UPIN FROM LAB_TEST_INVOICES l WHERE l.INVOICE_NO = CC.SERVICE_REF_NO), '-')    AS UPIN,\n"
				+ "       to_char(m.TXN_DATE, 'DD/MM/YYYY HH12:MI AM'),\n" + "       CC.INVOICE_NO,\n"
				+ "       cc.SERVICE_REF_NO,\n" + "       cc.GROSS_AMOUNT,\n" + "       cc.DISCOUNT,\n"
				+ "       cc.NETAMOUNT,\n" + "       cc.PAYMENT_MODE,\n" + "       cc.CREDIT_CARD_RCPT_NO,\n"
				+ "       cc.CHEQUE_NO,\n"
				+ "       NVL((SELECT b.BANK_NAME FROM BANKS b WHERE b.BANK_ID = CC.BANK_NAME), '-')                   AS BANKNAME,\n"
				+ "       cc.CHEQUE_AUTH_PERSON,\n" + "       p.PACKAGE_NAME,\n" + "       p.AMOUNT,\n"
				+ "       NVL((select distinct DR.REASON from DISCOUNT_REASON DR where CC.DIS_REASON = DR.REASON_ID), '-'),\n"
				+ "       DECODE(CC.ACC_ID, 'A001', 'NAWALOKA', 'A002', 'NEW NAWALOKA', 'NEW NAWALOKA MEDICAL CENTER') as ACC_ID,\n"
				+ "       CC.ACC_ID                                                                                    as acc,\n"
				+ "       NVL((SELECT l.REF_DOCTOR FROM LAB_TEST_INVOICES l WHERE l.INVOICE_NO = CC.SERVICE_REF_NO), '-')    AS DOCTOR,\n"
				+ "       CC.CASHIER_ID\n" + "from cashier_collection cc,\n" + "     medi_pack_invoices m,\n"
				+ "     medical_Packages p\n" + "where cc.SERVICE_REF_NO = '" + refNo5 + "'\n"
				+ "  and cc.SERVICE_REF_NO = m.SERVICE_REF_NO\n" + "  and m.PACKAGE_ID = p.PACKAGE_ID\n"
				+ "  and cc.STATUS = 1";
		rs = conn.query(query);
		int countR = 0;

		if (uid.equals("SAMADHI")) {
			out.println(query);
		}

		while (rs.next()) {
			countR++;
			NAME = rs.getString(1);
			// out.println(NAME);
			AGE = rs.getString(2);
			TELE = rs.getString(3);
			EMAIL = rs.getString(4);
			UPIN = rs.getString(5);
			RCPT_NO = rs.getString(7);
			REF_NO = rs.getString(8);
			DATE = rs.getString(6);
			//                    PAY_MODE = rs.getInt(12);
			PKG_NAME = rs.getString(17);
			PKG_AMO = rs.getDouble(18);
			CASHIER_ID = rs.getString(7);
			//                    TOTAL = rs.getDouble(9);
			//                    NET_AMO = rs.getDouble(11);
			//                    DIS_REASON = rs.getString(19);
			//                    DISCOUNT = rs.getDouble(10);
			//                    ACC_ID = rs.getString(20);
			//                    acc = rs.getString(21);
			//                    cBank = rs.getString(15);
			//                    ccRcpNo = rs.getString(13);
			//                    cNo = rs.getString(14);
			//                    cAuth = rs.getString(16);
			DOCTOR = rs.getString(22);
			CASHIER_ID = rs.getString(23);
%>
<body topmargin="0" leftmargin="0" class="optionsTop">

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="30" align="left"
				background="/eHospitalOPDOffice/images/titleMiddle.gif"
				class="titles"><img
				src="/eHospitalOPDOffice/images/titleCorner.gif" width="30"
				height="30" border="0"></td>
			<td valign="middle"
				background="/eHospitalOPDOffice/images/titleMiddle.gif"
				class="titles"><p style="margin-right: 10">Search Theater
					Payment Number</p></td>
		</tr>
		<tr>
			<td width="30">&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td width="30">&nbsp;</td>
			<td>

				<table width="700" border="0" cellpadding="0" cellspacing="0"
					class="bodyTable">

					<tr>
						<td colspan="4">&nbsp;</td>
					</tr>

					<form action="Ref_Search_DetailsReprints_Mpkprint.jsp" name="f1"
						method="post">
						<input type="text" value="<%=refNo5%>" style="visibility: hidden"
							name="refNo5">
						<tr>
							<td width="212" height="25" class="rowgrey"><p
									style="margin-left: 10px">NAME</p></td>

							<td height="25" colspan="4" class="rowgrey"><b><%=NAME%>
							</b></td>
						</tr>
						<tr>
							<td width="212" height="25" class="rowgrey"><p
									style="margin-left: 10px">AGE</p></td>

							<td height="25" colspan="4" class="rowgrey"><b><%=AGE%>
							</b></td>
						</tr>
						<tr>
							<td width="212" height="25" class="rowgrey"><p
									style="margin-left: 10px">TELE</p></td>

							<td height="25" colspan="4" class="rowgrey"><b><%=TELE%>
							</b></td>
						</tr>
						<tr>
							<td width="212" height="25" class="rowgrey"><p
									style="margin-left: 10px">EMAIL</p></td>

							<td height="25" colspan="4" class="rowgrey"><b><%=EMAIL%>
							</b></td>
						</tr>
						<tr>
							<td width="212" height="25" class="rowgrey"><p
									style="margin-left: 10px">UPIN</p></td>

							<td height="25" colspan="4" class="rowgrey"><b><%=UPIN%>
							</b></td>
						</tr>
						<tr>
							<td width="212" height="25" class="rowgrey"><p
									style="margin-left: 10px">DATE</p></td>

							<td height="25" colspan="4" class="rowgrey"><b><%=DATE%>
							</b></td>
						</tr>
						<tr>
							<td width="212" height="25" class="rowgrey"><p
									style="margin-left: 10px">RCPT NO</p></td>

							<td height="25" colspan="4" class="rowgrey"><b><%=RCPT_NO%>
							</b></td>
						</tr>
						<tr>
							<td width="212" height="25" class="rowgrey"><p
									style="margin-left: 10px">REF NO</p></td>

							<td height="25" colspan="4" class="rowgrey"><b><%=REF_NO%>
							</b></td>
						</tr>

						<tr>
							<td width="212" height="25" class="rowgrey"><p
									style="margin-left: 10px">DOCTOR</p></td>

							<td height="25" colspan="4" class="rowgrey"><b><%=DOCTOR%>
							</b></td>

						</tr>
						<tr>
							<td width="212" height="25" class="rowgrey"><p
									style="margin-left: 10px">PACKAGE</p></td>

							<td height="25" colspan="4" class="rowgrey"><b><%=PKG_NAME%>
							</b></td>

						</tr>
						<tr>
							<td width="212" height="25" class="rowgrey"><p
									style="margin-left: 10px">PACKAGE AMOUNT</p></td>

							<td height="25" colspan="4" class="rowgrey"><b><%=PKG_AMO%>
							</b></td>

						</tr>

						<tr>
							<td width="212" height="25" class="rowgrey"><p
									style="margin-left: 10px">ISSUED USER</p></td>

							<td height="25" colspan="4" class="rowgrey"><b><%=CASHIER_ID%>
							</b></td>
						</tr>


						<tr align="right">

							<td height="25" align="center" valign="middle" colspan="6"
								class="rowgrey"><input name="Submit" type="submit"
								class="submitbut" value="Print"></td>
						</tr>
						<tr>
							<td colspan="4" class="rowTop">&nbsp;</td>
						</tr>

					</form>
				</table>
			</td>
		</tr>
	</table>

</body>
<%
}
if (countR == 0) {
request.setAttribute("ErrorMessage", "This reference number is already canceled");
request.setAttribute("ErrorType", "ERROR");
dispatcher = getServletContext().getRequestDispatcher("/ErrorScreen.jsp");
dispatcher.forward(request, response);
}
conn.flushStmtRs();
} catch (Exception e) {
conn.flushStmtRs();
}
}
}
}
%>
</html>