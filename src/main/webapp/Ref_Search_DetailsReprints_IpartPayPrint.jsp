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
String refNo8 = request.getParameter("refNo8");
refNo8 = refNo8.trim();
DatabaseConnection conn = new DatabaseConnection();

conn.connectToDB();

String NAME = "", DOB = "", PAYMENT_TYPE = "", BHT = "", YY = "", MM = "", cBank = "", ccRcpNo = "", cNo = "",
		cAuth = "", UPIN = "", DATE = "", RCPT_NO = "", REF_NO = "", DESCRIPTION = "", REMARKS = "", CASHIER_ID = "",
		DIS_REASON = "", ONLINE_INVO = "", mode = "";
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
	+ "       cc.PAYMENT_MODE                                     as payMode,\n" + "       ep.PAYMENT_TYPE,\n"
	+ "       NVL(ep.ONLINE_PAYMENT_INVOICE, '-')                 as ONLINE_PAYMENT_INVOICE,\n"
	+ "       NVL(HV.PIN_NO, '-')                                    UPIN,\n" + "       hv.BHT,\n"
	+ "       cc.CASHIER_ID,\n" + "       cc.INVOICE_NO,\n"
	+ "       DECODE(CC.ACC_ID, 'A001', 'NAWALOKA', 'A002', 'NEW NAWALOKA', 'NEW NAWALOKA MEDICAL CENTER') as ACC_ID,\n"
	+ "       CC.ACC_ID                                                                                    as acc\n"
	+ "FROM CASHIER_COLLECTION cc,\n" + "     echbill eb,\n" + "     HOSPITAL_VISIT hv,\n"
	+ "     PATIENT_REGISTRATION pr,\n" + "     echpayments ep\n" + "WHERE\n"
	+ "  to_number(substr(cc.INVOICE_NO, 4)) = to_number('" + refNo8 + "')\n"
	+ "  and cc.SERVICE_REF_NO = eb.ID\n" + "  and ep.RECIEPT_NUMBER = cc.INVOICE_NO\n"
	+ "  and hv.BHT = eb.BHT_NO\n" + "  and pr.REGISTRATION_NO = hv.REGISTRATION_NO";

	rs = conn.query(query);
	//out.println(query);
	while (rs.next()) {
		NAME = rs.getString(6);
		//  out.println(NAME);
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
		ACC_ID = rs.getString("ACC_ID");
		acc = rs.getString("acc");
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

<body style="padding-left: 6px; padding-right: 6px; font-size: 8pt"
	onLoad="openPDF()">
	<table width="265px" border="1" align="left">
		<%
		String tmp_title = "INWARD PART PAYMENT RECEIPT-REPRINT";
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
						<td valign="top" style="white-space: nowrap;">DATE</td>
						<td valign="top">:</td>
						<td valign="top"><%=DATE%></td>

					</tr>

					<tr>
						<td valign="top" style="white-space: nowrap;">RCPT NO</td>
						<td valign="top">:</td>
						<td valign="top"><%=RCPT_NO%></td>

					</tr>
					<tr>
						<td valign="top" style="white-space: nowrap;">UPIN</td>
						<td valign="top">:</td>
						<td valign="top"><%=UPIN%></td>

					</tr>
					<tr>
						<td valign="top" style="white-space: nowrap;">BHT</td>
						<td valign="top">:</td>
						<td valign="top"><%=BHT%></td>

					</tr>
				</table>
				<table width="265px">
					<tr>
						<td><u>#</u></td>
						<td><u>DESCRIPTION - [PART] </u></td>
						<td align="right"><u>AMOUNT</u></td>
					</tr>
					<tr>
						<td colspan="3" height="3pt"></td>
					</tr>
					<tr>
						<td valign="top">1.</td>
						<td valign="top"><%=mode%></td>
						<td align="right" valign="top"><%=df.format(NET_AMO)%></td>
					</tr>

				</table>
				<table width="265px" align="right">
					<tr>
						<td align="right">TOTAL AMOUNT(Rs.)</td>
						<td>:</td>
						<td align="right"
							style="border-top: 1px solid black; border-bottom: 1px solid black;">
							<b><%=df.format(NET_AMO)%> </b>
						</td>
					</tr>
				</table>

				<table width="265px" align="right">
					<%
					if (PAY_MODE == 3) {
					%>
					<tr>
						<td colspan="2">
							<table>
								<tr>
									<td valign="top">CHEQUE NO&nbsp;:&nbsp;<%=cNo%>
									</td>
								</tr>
								<tr>
									<td valign="top">BANK NAME&nbsp;:&nbsp;<%=cBank%>
									</td>
								</tr>
								<tr>
									<td valign="top">AUTH PERSON&nbsp;:&nbsp;<%=cAuth%>
									</td>
								</tr>
								<tr>
									<td height="3pt"></td>
								</tr>

								</td>
								</tr>
								<%
								}
								%>
								<%
								if (PAY_MODE == 2) {
								%>
								<tr>
									<td colspan="2">
										<table border="0">
											<tr>
												<td valign="top">BANK NAME&nbsp;:&nbsp;<%=cBank%>
												</td>
											</tr>
											<%
											if (!(ccRcpNo.equals("-") || ccRcpNo.equals("null"))) {
											%>
											<tr>
												<td valign="top">CREDIT CARD RCPT. NO.&nbsp;:&nbsp;<%=ccRcpNo%>
												</td>
											</tr>
											<%
											}
											%>
											<tr>
												<td height="3pt"></td>
											</tr>

										</table>
									</td>
								</tr>
								<%
								if (!(ONLINE_INVO.equals("-") || ONLINE_INVO.equals("null"))) {
								%>
								<tr>
									<td align="right">ONLINE PAYMENT INVOICE</td>
									<td>:</td>
									<td><%=ONLINE_INVO%></td>
								</tr>
								<%
								}
								%>

								<%
								}
								%>
								<tr>
									<td colspan="3" height="5pt"></td>
								</tr>


								<tr>
									<td height="10pt"></td>
								</tr>
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
			</td>
		</tr>
	</table>
</body>


</html>


<%
}
conn.flushStmtRs();
} catch (Exception e) {
conn.flushStmtRs();
}
%>