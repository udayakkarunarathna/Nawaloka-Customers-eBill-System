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
	String refNo4 = request.getParameter("refNo4");
	refNo4 = refNo4.trim();
	int stringlength = refNo4.length();
	String a = "";
	for (int i = 1; i <= 9 - stringlength; i++) {
		a = a + "0";
	}
	refNo4 = "THV" + a + refNo4;
	// out.println(refNo4);
	if (usertype.equals("Admin") || usertype.equals("User")) {
		if (refNo4.equals("") || refNo4 == null) {
	// set error message
	request.setAttribute("ErrorMessage", "<center>  Please Enter OPD Reference Number </center>");
	request.setAttribute("ErrorType", "ERROR");
	// call the error screen (ErrorScreen.jsp)

	dispatcher = getServletContext().getRequestDispatcher("/ErrorScreen.jsp");
	dispatcher.include(request, response);
		} else {

	DatabaseConnection conn = new DatabaseConnection();
	DatabaseConnection conn2 = new DatabaseConnection();
	conn.connectToDB();
	conn2.connectToDB();
	String query = "";

	String NAME = "", DOB = "", YY = "", MM = "", cBank = "", ccRcpNo = "", cNo = "", cAuth = "", UPIN = "",
			DATE = "", RCPT_NO = "", REF_NO = "", DESCRIPTION = "", REMARKS = "", CASHIER_ID = "",
			DIS_REASON = "";
	String ACC_ID = "", acc = "";

	int PAY_MODE = 0;
	String disc = "";
	double TOTAL = 0, NET_AMO = 0, DISCOUNT = 0, total = 0, vat = 0;
	ResultSet rs = null;
	ResultSet rs2 = null;
	try {

		String query2 = "Select SUM(BL_BRK.CATEGORY_CHARGE) as AMOUNT, 'THEATER CHARGES' as DESCRIPTION\n"
				+ "from TH_BILL_BREAKDOWN BL_BRK,cashier_collection cc\n" + "where cc.SERVICE_REF_NO = '"
				+ refNo4 + "'\n"
				+ "  and (BL_BRK.CATEGORY = '0' OR BL_BRK.CATEGORY = '4' OR BL_BRK.CATEGORY = '5' OR BL_BRK.CATEGORY = '6' OR\n"
				+ "       BL_BRK.CATEGORY = '7' OR BL_BRK.CATEGORY = '9' OR BL_BRK.CATEGORY = '1' OR BL_BRK.CATEGORY = '15')\n"
				+ "  and BL_BRK.CATID_STATUS = 0\n" + "  and BL_BRK.INVOICE_NO = cc.SERVICE_REF_NO\n" + "\n"
				+ "UNION\n" + "Select BL_BRK.CAT_TOT_CHARGE as AMOUNT, 'DRUG CHARGES' as DESCRIPTION\n"
				+ "from TH_BILL_BREAKDOWN BL_BRK,cashier_collection cc\n" + "where cc.SERVICE_REF_NO = '"
				+ refNo4 + "'\n" + "  and BL_BRK.CATEGORY = '2'\n" + "  and BL_BRK.CATID_STATUS = 0\n"
				+ "  and BL_BRK.INVOICE_NO = cc.SERVICE_REF_NO\n" + "UNION\n"
				+ "Select BL_BRK.CATEGORY_CHARGE as AMOUNT, D.TITLE || ' ' || D.FIRST_NAME || ' ' || D.LAST_NAME as DESCRIPTION\n"
				+ "from TH_BILL_BREAKDOWN BL_BRK,\n" + "     DOCTORS D,\n" + "     THEATER_DOCTORS TD,\n"
				+ "    cashier_collection cc\n" + "where cc.SERVICE_REF_NO= '" + refNo4 + "'\n"
				+ "  and BL_BRK.CATEGORY = '3'\n" + "  and BL_BRK.CATID_STATUS = 0\n"
				+ "  AND D.DOC_NO = TD.DOC_NO\n" + "  AND TD.TH_DOC_ID = BL_BRK.CATEGORY_ID\n"
				+ "  AND BL_BRK.PAY_STATUS = 0\n" + "  and BL_BRK.INVOICE_NO = cc.SERVICE_REF_NO\n" + "UNION\n"
				+ "Select DISTINCT(BL_BRK.CAT_TOT_CHARGE) as AMOUNT, 'DISCOUNT' as DESCRIPTION\n"
				+ "from TH_BILL_BREAKDOWN BL_BRK,cashier_collection cc\n" + "where cc.SERVICE_REF_NO = '"
				+ refNo4 + "'\n" + "  and BL_BRK.CATEGORY = '8'\n" + "  and BL_BRK.CATID_STATUS = 0\n"
				+ "and BL_BRK.INVOICE_NO = cc.SERVICE_REF_NO";

		query = "\n"
				+ "SELECT TP.TITLE || ' ' || TP.FNAME || ' ' || TP.SURNAME                                             AS PNAME,\n"
				+ "       TP.UPIN,\n" + "       to_char(TP.REG_DATE, 'DD/MM/YYYY HH12:MI AM'),\n"
				+ "       cc.INVOICE_NO,\n" + "       cc.SERVICE_REF_NO,\n" + "       CC.PAYMENT_MODE,\n"
				+ "       cc.CASHIER_ID,\n" + "       cc.GROSS_AMOUNT,\n" + "       cc.NETAMOUNT,\n"
				+ "       cc.DISCOUNT,\n"
				+ "       NVL((select distinct DR.REASON from DISCOUNT_REASON DR where CC.DIS_REASON = DR.REASON_ID), '-'),\n"
				+ "       DECODE(CC.ACC_ID, 'A001', 'NAWALOKA', 'A002', 'NEW NAWALOKA', 'NEW NAWALOKA MEDICAL CENTER') as ACC_ID,\n"
				+ "       CC.ACC_ID                                                                                    as acc,\n"
				+ "       CC.CHEQUE_NO,\n" + "       CC.CHEQUE_AUTH_PERSON,\n"
				+ "       CC.CREDIT_CARD_RCPT_NO,\n"
				+ "       NVL((SELECT b.BANK_NAME FROM BANKS b WHERE b.BANK_ID = CC.BANK_NAME), '-')                   AS BANKNAME\n"
				+ "FROM cashier_collection cc,\n" + "     TH_OPDCASH_PATIENTS TP\n"
				+ "where cc.SERVICE_REF_NO = '" + refNo4 + "'\n" + "  and cc.STATUS =1\n"
				+ "  AND cc.INVOICE_NO = TP.INVOICE_NO";

		rs = conn.query(query);

		int countR = 0;

		if (uid.equals("SAMADHI")) {
			out.println(query);
		}
		while (rs.next()) {
			countR++;
			NAME = rs.getString(1);
			//  out.println(NAME);
			UPIN = rs.getString(2);
			RCPT_NO = rs.getString(4);
			REF_NO = rs.getString(5);
			DATE = rs.getString(3);
			PAY_MODE = rs.getInt(6);

			CASHIER_ID = rs.getString(7);
			TOTAL = rs.getDouble(8);
			NET_AMO = rs.getDouble(9);
			DIS_REASON = rs.getString(11);
			DISCOUNT = rs.getDouble(10);
			//                    ACC_ID = rs.getString("ACC_ID");
			//                    acc = rs.getString("acc");
			//                    cBank = rs.getString(17);
			//                    ccRcpNo = rs.getString(16);
			//                    cNo = rs.getString(14);
			//                    cAuth = rs.getString(15);
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

					<form action="Ref_Search_DetailsReprints_Theaterprint.jsp"
						name="f1" method="post">
						<input type="text" value="<%=refNo4%>" style="visibility: hidden"
							name="refNo4">
						<tr>
							<td width="212" height="25" class="rowgrey"><p
									style="margin-left: 10px">NAME</p></td>

							<td height="25" colspan="4" class="rowgrey"><b><%=NAME%>
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
									style="margin-left: 10px">RCPT NO</p></td>

							<td height="25" colspan="4" class="rowgrey"><b><%=RCPT_NO%>
							</b></td>
						</tr>
						<tr>
							<td width="212" height="25" class="rowgrey"><p
									style="margin-left: 10px">INVOICE NO</p></td>

							<td height="25" colspan="4" class="rowgrey"><b><%=REF_NO%>
							</b></td>
						</tr>
						<tr>
							<td width="212" height="25" class="rowgrey"><p
									style="margin-left: 10px">DATE</p></td>

							<td height="25" colspan="4" class="rowgrey"><b><%=DATE%>
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
									<b>SERVICE NAME</b>
								</p></td>

							<td width="400" height="25" class="rowgrey"><p
									style="margin-left: 10px;">
									<b>AMOUNT</b>
								</p></td>


						</tr>
						<tr>
							<td colspan="2" height="4pt"></td>
						</tr>
						<%
						try {
							rs2 = conn2.query(query2);
							//   out.println(query2);
							int count = 0;
							while (rs2.next()) {
								count++;
								disc = rs2.getString("DESCRIPTION");
								disc.replaceAll("^ +| +$|( )+", "$1");
								if (rs2.getDouble("AMOUNT") > 0) {
							if (disc.length() > 38) {
								disc = disc.substring(0, 38);
							}
						%>

						<tr>
							<td valign="top" valign="top"><%=count%>.</td>
							<td valign="top" valign="top"><%=disc%></td>
							<td valign="top" valign="top"><%=df.format(rs2.getDouble("AMOUNT"))%></td>
						</tr>
						<%
						total = total + rs2.getDouble("AMOUNT");
						}
						}
						} catch (Exception e1) {
						System.out.println("--------------------TheaterPrint----------------------------------------");
						e1.printStackTrace();
						System.out.println("------------------------------------------------------------");
						}
						%>
						<tr>
							<td width="212" height="25" class="rowgrey"><p
									style="margin-left: 10px"><%=DIS_REASON%>
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

	<%
	}
	if (countR == 0) {
	request.setAttribute("ErrorMessage", "This reference number is already canceled");
	request.setAttribute("ErrorType", "ERROR");
	dispatcher = getServletContext().getRequestDispatcher("/ErrorScreen.jsp");
	dispatcher.forward(request, response);
	}
	conn.flushStmtRs();
	conn2.flushStmtRs();
	} catch (Exception e) {
	conn.flushStmtRs();
	}
	}
	}
	}
	%>

</html>