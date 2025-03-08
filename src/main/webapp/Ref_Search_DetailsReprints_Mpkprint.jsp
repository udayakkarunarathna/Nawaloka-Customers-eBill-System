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
String refNo5 = request.getParameter("refNo5");
refNo5 = refNo5.trim();
// out.println(refNo5);
DatabaseConnection conn = new DatabaseConnection();

conn.connectToDB();

String query = "";
String NAME = "", AGE = "", TELE = "", EMAIL = "", DOCTOR = "", cBank = "", ccRcpNo = "", cNo = "", cAuth = "",
		UPIN = "", DATE = "", RCPT_NO = "", REF_NO = "", CASHIER_ID = "", DIS_REASON = "", PKG_NAME = "";
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
	//   out.println(query);
	while (rs.next()) {
		NAME = rs.getString(1);
		//  out.println(NAME);
		AGE = rs.getString(2);
		TELE = rs.getString(3);
		EMAIL = rs.getString(4);
		UPIN = rs.getString(5);
		RCPT_NO = rs.getString(7);
		REF_NO = rs.getString(8);
		DATE = rs.getString(6);
		PAY_MODE = rs.getInt(12);
		PKG_NAME = rs.getString(17);
		PKG_AMO = rs.getDouble(18);

		TOTAL = rs.getDouble(9);
		NET_AMO = rs.getDouble(11);
		DIS_REASON = rs.getString(19);
		DISCOUNT = rs.getDouble(10);
		ACC_ID = rs.getString(20);
		acc = rs.getString(21);
		cBank = rs.getString(15);
		ccRcpNo = rs.getString(13);
		cNo = rs.getString(14);
		cAuth = rs.getString(16);
		DOCTOR = rs.getString(22);
		CASHIER_ID = rs.getString(23);
%>
<body style="padding-left: 6px; padding-right: 6px; font-size: 8pt"
	onLoad="openPDF()">
	<table width="265px" border="1" align="left">
		<%
		String tmp_title = "MEDICAL PACKAGES RECEIPT-REPRINT";
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
						<td valign="top" style="white-space: nowrap;">AGE</td>
						<td valign="top">:</td>
						<td valign="top"><%=AGE%></td>

					</tr>
					<tr>
						<td valign="top" style="white-space: nowrap;">TELE</td>
						<td valign="top">:</td>
						<td valign="top"><%=TELE%></td>

					</tr>
					<tr>
						<td valign="top" style="white-space: nowrap;">EMAIL</td>
						<td valign="top">:</td>
						<td valign="top"><%=EMAIL%></td>

					</tr>
					<tr>
						<td align="left" style="white-space: nowrap;" valign="top">UPIN</td>
						<td align="center" valign="top">:</td>
						<td align="left" valign="top"><%=UPIN%></td>
					</tr>
					<tr>
						<td align="left" style="white-space: nowrap;" valign="top">
							DATE</td>
						<td align="center" valign="top">:</td>
						<td align="left" valign="top"><%=DATE%></td>
					</tr>
					<tr>
						<td align="left" style="white-space: nowrap;" valign="top">RCPT
							NO</td>
						<td align="center" valign="top">:</td>
						<td align="left" valign="top"><%=RCPT_NO%></td>
					</tr>
					<tr>
						<td align="left" style="white-space: nowrap;" valign="top">REF
							NO.</td>
						<td align="center" valign="top">:</td>
						<td align="left" valign="top"><%=REF_NO%></td>
					</tr>
					<tr>
						<td valign="top" style="white-space: nowrap;">DOCTOR</td>
						<td valign="top">:</td>
						<td valign="top"><%=DOCTOR%></td>

					</tr>
					<tr>
						<td valign="top" style="white-space: nowrap;">PACKAGE</td>
						<td valign="top">:</td>
						<td valign="top"><%=PKG_NAME%></td>

					</tr>


				</table>
			</td>
		</tr>
		<tr>
			<td>
				<table width="265px">

					<tr>
						<td valign="top" style="white-space: nowrap;" align="right">PACKAGE
							AMOUNT(Rs.):</td>

						<td valign="top"><b><%=df.format(PKG_AMO)%></b></td>

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
					</table>


					<%
					}
					%>
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