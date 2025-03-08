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
	String refNo6 = request.getParameter("refNo6");
	refNo6 = refNo6.trim();
	//        int stringlength = refNo6.length();
	//        String a = "";
	//        for (int i = 1; i <= 10 - stringlength; i++) {
	//            a = a + "0";
	//        }
	//        refNo6 = "CH" + a + refNo6;
	//  out.println(refNo6);
	if (usertype.equals("Admin") || usertype.equals("User")) {
		if (refNo6.equals("") || refNo6 == null) {
	// set error message
	request.setAttribute("ErrorMessage", "<center>  Please Enter OPD Reference Number </center>");
	request.setAttribute("ErrorType", "ERROR");
	// call the error screen (ErrorScreen.jsp)

	dispatcher = getServletContext().getRequestDispatcher("/ErrorScreen.jsp");
	dispatcher.include(request, response);
		} else {

	DatabaseConnection conn = new DatabaseConnection();
	conn.connectToDB();

	String NAME = "", DOB = "", BHT = "", YY = "", MM = "", cBank = "", ccRcpNo = "", cNo = "", cAuth = "",
			UPIN = "", DATE = "", RCPT_NO = "", REF_NO = "", DESCRIPTION = "", REMARKS = "", CASHIER_ID = "",
			DIS_REASON = "", ONLINE_INVO = "", mode = "";
	String ACC_ID = "", acc = "";

	int PAY_MODE = 0;

	double TOTAL = 0, NET_AMO = 0, DISCOUNT = 0, total = 0, vat = 0;
	ResultSet rs = null;

	try {
		String query = "select pr.TITLE || ' ' || nvl(pr.INITIALS, '') || ' ' || nvl(pr.SURNAME, ''),\n"
				+ "       eb.BHT_NO,\n" + "\n"
				+ "       NVL((select distinct HV.PIN_NO from HOSPITAL_VISIT HV where HV.REGISTRATION_NO = PR.REGISTRATION_NO), '-'),\n"
				+ "       CC.INVOICE_NO,\n" + "       cc.TXN_TYPE,\n"
				+ "       to_char(cc.TXN_DATE, 'dd/mm/yyyy hh:mi PM') as TXN_DATE,\n"
				+ "       cc.GROSS_AMOUNT,\n" + "       cc.NETAMOUNT,\n" + "       cc.DISCOUNT,\n"
				+ "       NVL((select distinct DR.REASON from DISCOUNT_REASON DR where cc.DIS_REASON = DR.REASON_ID), '-'),\n"
				+ "       cc.CASHIER_ID,\n" + "       cc.PAYMENT_MODE,\n"
				+ "       NVL(cc.CREDIT_CARD_RCPT_NO, '-')            as CREDIT_CARD_RCPT_NO,\n"
				+ "       cc.CHEQUE_NO,\n"
				+ "       NVL((SELECT b.BANK_NAME FROM BANKS b WHERE b.BANK_ID = CC.BANK_NAME), '-'),\n"
				+ "       cc.CHEQUE_AUTH_PERSON,\n"
				+ "       NVL(ep.ONLINE_PAYMENT_INVOICE, '-')         as ONLINE_PAYMENT_INVOICE,\n"
				+ "       cc.DIS_REASON,\n" + "       NVL(cc.REMARKS, '-')                        as REMARKS,\n"
				+ "       DECODE(CC.ACC_ID, 'A001', 'NAWALOKA', 'A002', 'NEW NAWALOKA', 'NEW NAWALOKA MEDICAL CENTER') as ACC_ID,\n"
				+ "       CC.ACC_ID                                                                                    as acc\n"
				+ "from CASHIER_COLLECTION cc,\n" + "     echpayments ep,\n" + "     PATIENT_REGISTRATION pr,\n"
				+ "     echbill eb\n" + "\n" + "\n" + "WHERE\n"
				+ "  to_number(substr(cc.INVOICE_NO, 4)) = to_number('" + refNo6 + "')\n"
				+ "  AND PR.REGISTRATION_NO = EB.CUST_ID\n" + "  AND EP.BILL_ID = EB.ID\n"
				+ "  and CC.STATUS =1\n" + "\n" + "  and ep.RECIEPT_NUMBER = cc.INVOICE_NO";
		rs = conn.query(query);
		int countR = 0;
		if (uid.equals("SAMADHI")) {
			out.println(query);
		}

		while (rs.next()) {
			countR++;
			NAME = rs.getString(1);
			// out.println(NAME);
			BHT = rs.getString(2);
			UPIN = rs.getString(3);
			RCPT_NO = rs.getString(4);
			DATE = rs.getString(6);
			PAY_MODE = rs.getInt(12);
			if (PAY_MODE == 1) {
				mode = "CASH";
			}
			if (PAY_MODE == 2) {
				mode = "CREDIT CARD";
			}
			if (PAY_MODE == 3) {
				mode = "CHEQUE";
			}

			CASHIER_ID = rs.getString(11);
			TOTAL = rs.getDouble(7);
			NET_AMO = rs.getDouble(8);
			DIS_REASON = rs.getString(10);
			DISCOUNT = rs.getDouble(9);
			ACC_ID = rs.getString("ACC_ID");
			acc = rs.getString("acc");
			cBank = rs.getString(15);
			ccRcpNo = rs.getString(13);
			cNo = rs.getString(14);
			cAuth = rs.getString(16);
			REMARKS = rs.getString(19);
			ONLINE_INVO = rs.getString(17);
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

					<form action="Ref_Search_DetailsReprints_IFpayPrint.jsp" name="f1"
						method="post">
						<input type="text" value="<%=refNo6%>" style="visibility: hidden"
							name="refNo6">
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
							<td valign="top" valign="top"><%=df.format(TOTAL)%></td>
						</tr>
						<tr>
							<td width="212" height="25" class="rowgrey"><p
									style="margin-left: 10px">
									DISCOUNT:<%=DIS_REASON%>
									(Rs.)
								</p></td>

							<td height="25" colspan="4" class="rowgrey"><b><%=df.format(DISCOUNT)%>
							</b></td>
						</tr>
						<tr>
							<td width="212" height="25" class="rowgrey"><p
									style="margin-left: 10px">GROSS AMOUNT</p></td>

							<td height="25" colspan="4" class="rowgrey"><b><%=df.format(TOTAL)%>
							</b></td>
						</tr>
						<tr>
							<td width="212" height="25" class="rowgrey"><p
									style="margin-left: 10px">NET AMOUNT</p></td>

							<td height="25" colspan="4" class="rowgrey"><b><%=df.format(NET_AMO)%>
							</b></td>
						</tr>
						<tr>
							<td width="212" height="25" class="rowgrey"><p
									style="margin-left: 10px">REMARKS</p></td>

							<td height="25" colspan="4" class="rowgrey"><b><%=REMARKS%>
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