<%@ page import="com.model.db.DatabaseConnection"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ include file="noCache.jsp"%>

<html>
<head>
<link rel="stylesheet" href="pop_style.css" />
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<meta http-equiv="Content-Type"
	content="text/html; charset=windows-1252">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<link href="/eHospitalLab/eHosLabStyles.css" rel="stylesheet"
	type="text/css">

<base target="main">

<script language="JavaScript">
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
	document.oncontextmenu = new Function("return true") //right click option show
</script>
<%--    jm Thermal printout--%>
<script type="text/javascript">
	function openPDF() {
		this.window.focus();
		this.window.print();
		//this.window.close();
		location.href = 'home.jsp'
	}
</script>
<style>
/* * {
            font-family: Verdana, sans-serif;
        } */
table, th, td {
	border: 0px solid black;
	border-collapse: collapse;
	colSpan: 5;
	vertical-align: top;
}

th, td {
	padding: 1px;
	vertical-align: top;
}

title {
	
}

img {
	display: inline-block;
}
</style>


</head>
<%
HttpSession sessions = request.getSession(false);
DecimalFormat df = new DecimalFormat();
df.setMaximumFractionDigits(2);
df.setMinimumFractionDigits(2);
String usertype = (String) sessions.getValue("usertype");
String uid1 = (String) sessions.getValue("uid");
String uid = uid1.toUpperCase();
String refNo4 = request.getParameter("refNo4");
refNo4 = refNo4.trim();
// out.println(refNo4);

DatabaseConnection conn = new DatabaseConnection();
DatabaseConnection conn2 = new DatabaseConnection();
conn.connectToDB();
conn2.connectToDB();
String query = "";

String NAME = "", DOB = "", YY = "", MM = "", cBank = "", ccRcpNo = "", cNo = "", cAuth = "", UPIN = "", DATE = "",
		RCPT_NO = "", REF_NO = "", DESCRIPTION = "", REMARKS = "", CASHIER_ID = "", DIS_REASON = "";
String ACC_ID = "", acc = "";

int PAY_MODE = 0;
String disc = "";
double TOTAL = 0, NET_AMO = 0, DISCOUNT = 0, total = 0, vat = 0;
ResultSet rs = null;
ResultSet rs2 = null;
try {

	String query2 = "Select SUM(BL_BRK.CATEGORY_CHARGE) as AMOUNT, 'THEATER CHARGES' as DESCRIPTION\n"
	+ "from TH_BILL_BREAKDOWN BL_BRK,cashier_collection cc\n" + "where cc.SERVICE_REF_NO = '" + refNo4 + "'\n"
	+ "  and (BL_BRK.CATEGORY = '0' OR BL_BRK.CATEGORY = '4' OR BL_BRK.CATEGORY = '5' OR BL_BRK.CATEGORY = '6' OR\n"
	+ "       BL_BRK.CATEGORY = '7' OR BL_BRK.CATEGORY = '9' OR BL_BRK.CATEGORY = '1' OR BL_BRK.CATEGORY = '15')\n"
	+ "  and BL_BRK.CATID_STATUS = 0\n" + "  and BL_BRK.INVOICE_NO = cc.SERVICE_REF_NO\n" + "\n" + "UNION\n"
	+ "Select BL_BRK.CAT_TOT_CHARGE as AMOUNT, 'DRUG CHARGES' as DESCRIPTION\n"
	+ "from TH_BILL_BREAKDOWN BL_BRK,cashier_collection cc\n" + "where cc.SERVICE_REF_NO = '" + refNo4 + "'\n"
	+ "  and BL_BRK.CATEGORY = '2'\n" + "  and BL_BRK.CATID_STATUS = 0\n"
	+ "  and BL_BRK.INVOICE_NO = cc.SERVICE_REF_NO\n" + "UNION\n"
	+ "Select BL_BRK.CATEGORY_CHARGE as AMOUNT, D.TITLE || ' ' || D.FIRST_NAME || ' ' || D.LAST_NAME as DESCRIPTION\n"
	+ "from TH_BILL_BREAKDOWN BL_BRK,\n" + "     DOCTORS D,\n" + "     THEATER_DOCTORS TD,\n"
	+ "    cashier_collection cc\n" + "where cc.SERVICE_REF_NO= '" + refNo4 + "'\n"
	+ "  and BL_BRK.CATEGORY = '3'\n" + "  and BL_BRK.CATID_STATUS = 0\n" + "  AND D.DOC_NO = TD.DOC_NO\n"
	+ "  AND TD.TH_DOC_ID = BL_BRK.CATEGORY_ID\n" + "  AND BL_BRK.PAY_STATUS = 0\n"
	+ "  and BL_BRK.INVOICE_NO = cc.SERVICE_REF_NO\n" + "UNION\n"
	+ "Select DISTINCT(BL_BRK.CAT_TOT_CHARGE) as AMOUNT, 'DISCOUNT' as DESCRIPTION\n"
	+ "from TH_BILL_BREAKDOWN BL_BRK,cashier_collection cc\n" + "where cc.SERVICE_REF_NO = '" + refNo4 + "'\n"
	+ "  and BL_BRK.CATEGORY = '8'\n" + "  and BL_BRK.CATID_STATUS = 0\n"
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
	+ "       CC.CHEQUE_NO,\n" + "       CC.CHEQUE_AUTH_PERSON,\n" + "       CC.CREDIT_CARD_RCPT_NO,\n"
	+ "       NVL((SELECT b.BANK_NAME FROM BANKS b WHERE b.BANK_ID = CC.BANK_NAME), '-')                   AS BANKNAME\n"
	+ "FROM cashier_collection cc,\n" + "     TH_OPDCASH_PATIENTS TP\n" + "where cc.SERVICE_REF_NO = '" + refNo4
	+ "'\n" + "  AND cc.INVOICE_NO = TP.INVOICE_NO";

	rs = conn.query(query);
	// out.println(query);
	while (rs.next()) {
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
		ACC_ID = rs.getString("ACC_ID");
		acc = rs.getString("acc");
		cBank = rs.getString(17);
		ccRcpNo = rs.getString(16);
		cNo = rs.getString(14);
		cAuth = rs.getString(15);
%>
<body style="padding-left: 6px; padding-right: 6px; font-size: 8pt"
	onLoad="openPDF()">
	<table width="265px" border="1" align="left">
		<%
		String tmp_title = "THEATER PAYMENT RECEIPT-REPRINT";
		%>
		<tr>
			<td><jsp:include page="print_header.jsp">
					<jsp:param name="accID1" value="<%=acc%>" />
					<jsp:param name="title1" value="<%=tmp_title%>" />
					<jsp:param name="vat1" value="<%=vat%>" />
				</jsp:include></td>
		</tr>
		<tr>
			<td>
				<table border="1" width="265px" align="left">
					<tr>
						<td valign="top" style="white-space: nowrap;">NAME</td>
						<td valign="top">:</td>
						<td valign="top"><%=NAME%></td>

					</tr>
					<tr>
						<td align="left" style="white-space: nowrap;" valign="top">UPIN</td>
						<td align="center" valign="top">:</td>
						<td align="left" valign="top"><%=UPIN%></td>
					</tr>
					<tr>
						<td align="left" style="white-space: nowrap;" valign="top">RCPT
							NO</td>
						<td align="center" valign="top">:</td>
						<td align="left" valign="top"><%=RCPT_NO%></td>
					</tr>
					<tr>
						<td align="left" style="white-space: nowrap;" valign="top">INVOICE
							NO.</td>
						<td align="center" valign="top">:</td>
						<td align="left" valign="top"><%=REF_NO%></td>
					</tr>
					<tr>
						<td align="left" style="white-space: nowrap;" valign="top">
							DATE</td>
						<td align="center" valign="top">:</td>
						<td align="left" valign="top"><%=DATE%></td>
					</tr>

				</table>
			</td>
		</tr>
		<tr>
			<td>
				<table width="265px">
					<tr>
						<td><u>#</u></td>
						<td><u>SERVICE NAME</u></td>
						<td align="right"><u>AMOUNT</u></td>
					</tr>
					<tr>
						<td colspan="3" height="3pt"></td>
					</tr>
					<%
					try {
						rs2 = conn2.query(query2);
						// out.println(query2);
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
						<td valign="top"><%=count%>.</td>
						<td valign="top"><%=disc%></td>
						<td valign="top" align="right"><%=df.format(rs2.getDouble("AMOUNT"))%>
						</td>
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
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<table border="1" width="265px">
					<%
					if (!df.format(DISCOUNT).equals("0.00")) {
					%>
					<tr>
						<td valign="top" align="right"><%=DIS_REASON%></td>

						<td valign="top" align="right"><%=df.format(DISCOUNT)%></td>

					</tr>
					<%
					}
					%>

					<tr>
						<td valign="top" align="right">GROSS AMOUNT:</td>

						<td valign="top" align="right"><%=df.format(TOTAL)%></td>

					</tr>
					<tr>
						<td valign="top" align="right">NET AMOUNT:</td>

						<td valign="top" align="right"
							style="border-top: 1px solid black; border-bottom: 1px solid black;"><%=df.format(NET_AMO)%>
						</td>

					</tr>
					<tr>
						<td colspan="3" align="right" height="10pt"></td>
					</tr>
					<%
					if (PAY_MODE == 1) {
					%>
					<table>

						<tr>
							<td valign="top" colspan="3">PAYMENT MODE : CASH</td>
						</tr>
					</table>
					<%
					}
					%>
					<%
					if (PAY_MODE == 2) {
					%>
					<table>

						<tr>
							<td valign="top" style="white-space: nowrap;">PAYMENT MODE</td>
							<td valign="top">:</td>
							<td valign="top">CREDIT CARD</td>
						</tr>
						<tr>
							<td valign="top" style="white-space: nowrap;">BANK NAME</td>
							<td valign="top">:</td>
							<td valign="top"><%=cBank%></td>
						</tr>
						<tr>
							<td valign="top" style="white-space: nowrap;">RCPT. NO</td>
							<td valign="top">:</td>
							<td valign="top"><%=ccRcpNo%></td>
						</tr>
					</table>
					<%
					}
					%>
					<%
					if (PAY_MODE == 3) {
					%>
					<table>

						<tr>
							<td valign="top" style="white-space: nowrap;">PAYMENT MODE</td>
							<td valign="top">:</td>
							<td valign="top">CHEQUE</td>
						</tr>

						<tr>
							<td valign="top" style="white-space: nowrap;">CHEQUE NO</td>
							<td valign="top">:</td>
							<td valign="top"><%=cNo%></td>
						</tr>
						<tr>
							<td valign="top" style="white-space: nowrap;">BANK/BRANCH
								NAME</td>
							<td valign="top">:</td>
							<td valign="top"><%=cBank%></td>
						</tr>
						<tr>
							<td valign="top" style="white-space: nowrap;">AUTHORIZED
								PERSON</td>
							<td valign="top">:</td>
							<td valign="top"><%=cAuth%></td>
						</tr>
						<%
						}
						%>
					</table>
					<tr>
						<td colspan="3" height="5pt"></td>
					</tr>
					<tr>
						<td height="10pt"></td>
					</tr>
				</table>
				<table>
					<tr>
						<td valign="top" align="left">------------------------------</td>
					</tr>

					<tr>
						<td valign="top" align="left" style="">ISSUED USER : <%=CASHIER_ID%>
						</td>
					</tr>
					<tr>
						<td valign="top" align="left" style="">REPRINTED USER:<%=uid%>
						</td>
					</tr>
					<%
					DatabaseConnection conn4 = new DatabaseConnection();
					try {
						conn4.connectToDB();
						ResultSet rs4 = null;
						String today = "";
						String d = "select to_char(SYSDATE,'DD/MM/YYYY HH12:MI AM')from DUAL";
						rs4 = conn4.query(d);
						if (rs4.next()) {
							today = rs4.getString(1);
					%>
					<tr>
						<td valign="top" align="left" style="">REPRINTED DATE: <%=today%>
						</td>
					</tr>
					<%
					}
					} catch (Exception ex) {
					conn4.flushStmtRs();
					}
					%>
					<tr>
						<td height="10pt"></td>
					</tr>
					<%-- <tr>
                            <td align="center">
                                <jsp:include page="barcodegen.jsp">
                                    <jsp:param
                                            value="<%=RCPT_NO%>" name="no1"/>
                                </jsp:include>
                            </td>
                        </tr> --%>
					<tr>
						<td><jsp:include page="print_footer.jsp"></jsp:include></td>
					</tr>
					<tr>
						<td height="10pt"></td>
					</tr>

				</table>

			</td>
		</tr>

	</table>

</body>
<%
}
conn.flushStmtRs();
} catch (Exception e) {
conn.flushStmtRs();
}
%>
</html>