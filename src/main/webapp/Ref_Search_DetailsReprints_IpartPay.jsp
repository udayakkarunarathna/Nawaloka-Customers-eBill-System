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
	String refNo8 = request.getParameter("refNo8");
	refNo8 = refNo8.trim();
	//            int stringlength = refNo8.length();
	//            String a = "";
	//            for (int i = 1; i <= 10 - stringlength; i++) {
	//                a = a + "0";
	//            }
	//            refNo8 = "CH" + a + refNo8;
	//  out.println(refNo8);
	if (usertype.equals("Admin") || usertype.equals("User")) {
		if (refNo8.equals("") || refNo8 == null) {
	// set error message
	request.setAttribute("ErrorMessage", "<center>  Please Enter OPD Reference Number </center>");
	request.setAttribute("ErrorType", "ERROR");
	// call the error screen (ErrorScreen.jsp)

	dispatcher = getServletContext().getRequestDispatcher("/ErrorScreen.jsp");
	dispatcher.include(request, response);
		} else {

	DatabaseConnection conn = new DatabaseConnection();

	conn.connectToDB();

	String NAME = "", DOB = "", PAYMENT_TYPE = "", BHT = "", YY = "", MM = "", cBank = "", ccRcpNo = "",
			cNo = "", cAuth = "", UPIN = "", DATE = "", RCPT_NO = "", REF_NO = "", DESCRIPTION = "",
			REMARKS = "", CASHIER_ID = "", DIS_REASON = "", ONLINE_INVO = "", mode = "";
	String ACC_ID = "", acc = "";

	int PAY_MODE = 0;

	double TOTAL = 0, NET_AMO = 0, DISCOUNT = 0, total = 0, vat = 0;
	ResultSet rs = null;

	try {
		String query = "SELECT cc.NETAMOUNT,\n"
				+ "       (select b.BANK_NAME Banks from Banks b where b.BANK_ID = cc.BANK_NAME)                         BANK_NAME,\n"
				+ "       cc.CHEQUE_NO,\n" + "       cc.CHEQUE_AUTH_PERSON,\n"
				+ "       NVL(cc.CREDIT_CARD_RCPT_NO, '-')                    as CREDIT_CARD_RCPT_NO,\n"
				+ "       pr.TITLE || ' ' || pr.INITIALS || ' ' || pr.SURNAME as Pname,\n"
				+ "       to_char(cc.TXN_DATE, 'dd/mm/yyyy hh:mi PM')         as TXN_DATE,\n"
				+ "       cc.PAYMENT_MODE                                     as payMode,\n"
				+ "       ep.PAYMENT_TYPE,\n"
				+ "       NVL(ep.ONLINE_PAYMENT_INVOICE, '-')                 as ONLINE_PAYMENT_INVOICE,\n"
				+ "       NVL(HV.PIN_NO, '-')                                    UPIN,\n" + "       hv.BHT,\n"
				+ "       cc.CASHIER_ID,\n" + "       cc.INVOICE_NO\n" + "FROM CASHIER_COLLECTION cc,\n"
				+ "     echbill eb,\n" + "     HOSPITAL_VISIT hv,\n" + "     PATIENT_REGISTRATION pr,\n"
				+ "     echpayments ep\n" + "WHERE\n" + "  to_number(substr(cc.INVOICE_NO, 4)) = to_number('"
				+ refNo8 + "')\n" + "  and cc.SERVICE_REF_NO = eb.ID\n"
				+ "  and ep.RECIEPT_NUMBER = cc.INVOICE_NO\n" + "  and hv.BHT = eb.BHT_NO\n"
				+ "  and CC.STATUS =1\n" + "  and pr.REGISTRATION_NO = hv.REGISTRATION_NO";

		rs = conn.query(query);
		// out.println(query);
		int countR = 0;
		if (uid.equals("SAMADHI")) {
			out.println(query);
		}
		while (rs.next()) {
			countR++;
			NAME = rs.getString(6);
			// out.println(NAME);
			BHT = rs.getString(12);
			UPIN = rs.getString(11);
			RCPT_NO = rs.getString(14);
			DATE = rs.getString(7);

			NET_AMO = rs.getDouble(1);

			CASHIER_ID = rs.getString(13);
			cBank = rs.getString(2);
			ccRcpNo = rs.getString(5);
			cNo = rs.getString(3);
			cAuth = rs.getString(4);

			PAY_MODE = rs.getInt(8);
			PAYMENT_TYPE = rs.getString(9);
			ONLINE_INVO = rs.getString(10);
			if (PAY_MODE == 1) {
				mode = "CASH";
			}
			if (PAY_MODE == 2) {
				mode = "CREDIT CARD";
			}
			if (PAY_MODE == 3) {
				mode = "CHEQUE";
			}
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

					<form action="Ref_Search_DetailsReprints_IpartPayPrint.jsp"
						name="f1" method="post">
						<input type="text" value="<%=refNo8%>" style="visibility: hidden"
							name="refNo8">
						<tr>
							<td width="212" height="25" class="rowgrey"><p
									style="margin-left: 10px">NAME</p></td>

							<td height="25" colspan="4" class="rowgrey"><b><%=NAME%>
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
									style="margin-left: 10px">UPIN</p></td>

							<td height="25" colspan="4" class="rowgrey"><b><%=UPIN%>
							</b></td>
						</tr>
						<tr>
							<td width="212" height="25" class="rowgrey"><p
									style="margin-left: 10px">BHT</p></td>

							<td height="25" colspan="4" class="rowgrey"><b><%=BHT%>
							</b></td>
						</tr>
						<tr>
							<td colspan="2" class="rowTop">&nbsp;</td>
						</tr>
						<tr>
							<td width="305" height="25" class="rowgrey"><p
									style="margin-left: 10px;">
									<b>#</b>
								</p></td>
							<td width="305" height="25" class="rowgrey"><p
									style="margin-left: 10px;">
									<b>DESCRIPTION</b>
								</p></td>

							<td width="400" height="25" class="rowgrey"><p
									style="margin-left: 10px;">
									<b>AMOUNT</b>
								</p></td>


						</tr>
						<tr>
							<td colspan="2" height="4pt"></td>
						</tr>

						<tr>
							<td valign="top" valign="top">1.</td>
							<td valign="top" valign="top"><%=mode%></td>

							<td valign="top" valign="top"><%=df.format(NET_AMO)%></td>
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