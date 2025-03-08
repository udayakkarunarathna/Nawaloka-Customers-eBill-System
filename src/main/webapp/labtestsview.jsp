<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ page import="com.model.db.DatabaseConnection"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ include file="noCache.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="icon" href="images/logo.png" type="image/x-icon">
<link href="css/bootstrap.min.css" rel="stylesheet">
<link href="css/bill.css" rel="stylesheet">
<link rel="stylesheet"
	href="font-awesome-4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="font-awesome-4.7.0/css/font-awesome.css">
<%
String title = "e-Bill";
String tmp_title = "LAB INVESTIGATION RECEIPT";
			%>
<title><%=title%> | Nawaloka Hospital</title>
<script src="js/printbill.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.js"
	integrity="sha512-vNrhFyg0jANLJzCuvgtlfTuPR21gf5Uq1uuSs/EcBfVOz6oAHmjqfyPoB5rc9iWGSnVE41iuQU4jmpXMyhBrsw=="
	crossorigin="anonymous" referrerpolicy="no-referrer"></script>
</head>
<body style="padding: 8px">
	<div id="downloadEbill" class="printDiv">
		<div class="text-center"
			style="background-color: #151313e0; color: white; border-radius: 0.5rem !important; padding-top: 8pt; padding-bottom: 5pt; margin: 2pt 3pt 0pt 3pt">
			<div align="center">
				<img src="images/logo.png" class="img-rounded"
					alt="Nawaloka Laboratory" height="40">&nbsp;&nbsp;<b>NAWALOKA
				HOSPITALS PLC</b>
				<div align="center" style="margin-top: -7pt; color: white">
					<b><%=title%></b>
				</div>
			</div>
		</div>
		<%
		DecimalFormat df = new DecimalFormat();
		df.setMaximumFractionDigits(2);
		df.setMinimumFractionDigits(2);
		DatabaseConnection conn = new DatabaseConnection();
		ResultSet rs = (ResultSet) null;
		ResultSet rs_packages = (ResultSet) null;
		
		String p = "", refno = "", upin = ""; 	
		if (request.getParameter("p") != null) {
			p = request.getParameter("p");
			refno = request.getParameter("p").split("_")[0];
			upin = request.getParameter("p").split("_")[1];			
		}
		
		ResultSet rs1 = null;
		ResultSet rs2 = null;
		String NAME = "", DOB = "", YY = "", MM = "", cBank = "", ccRcpNo = "", cNo = "", cAuth = "", NIC = "", NAT = "",
				AIR = "", TELE = "", EMAIL = "", UPIN = "", DATE = "", RCPT_NO = "", LAB_REF = "", REF_NO = "", UNIT = "",
				DOCTOR = "", DESCRIPTION = "", REMARKS = "", CASHIER_ID = "", DIS_REASON = "", COMPANY = "";
		String TEST_NAME = "", AMOUNT = "", ACC_ID = "", acc = "";
		double NET_AMO = 0f, TOTAL = 0f, DISCOUNT = 0f, vat = 0;
		int PAY_MODE = 0;
		DatabaseConnection conn1 = new DatabaseConnection();
		DatabaseConnection conn2 = new DatabaseConnection();
		double z = 0;
		
		try {
			conn1.connectToDB();
			String query1 = "SELECT NVL(L.DOB,'-'), L.NAME_BHT, L.AGE_YY, L.AGE_MM, " + " C.PAYMENT_MODE, NVL(L.PHONE,'-'), NVL(L.UPIN,'-'), "
			+ " to_char(L.TXN_DATE,'DD/MM/YYYY HH12:MI AM'), L.INVOICE_NO, " + " L.REF_DOCTOR, L.EMAIL, NVL(L.AIR_REF,'-'), "
			+ " NVL(L.NATIONALITY,'-'), L.STATUS, C.GROSS_AMOUNT, C.NETAMOUNT, "
			+ " NVL((select distinct DR.REASON from DISCOUNT_REASON@COLOMBO_LIVE DR where C.DIS_REASON = DR.REASON_ID), '-'), "
			+ " C.REMARKS, C.CASHIER_ID, "
			+ " NVL((SELECT U.NAME FROM UNITS@COLOMBO_LIVE U WHERE U.UNIT_CODE = L.UNIT_CODE), '-') AS UNIT, "
			+ " NVL((select distinct CC.NAME from CREDIT_COMPANIES@COLOMBO_LIVE CC where L.COMPANY_ID = cc.ID), '-') AS COMPANY, "
			+ " C.DISCOUNT, C.INVOICE_NO, L.INVOICE_NO, NVL(L.NID,'-'), "
			+ " DECODE(C.ACC_ID, 'A001', 'NAWALOKA', 'A002', 'NEW NAWALOKA', 'NEW NAWALOKA MEDICAL CENTER') as ACC_ID, "
			+ " C.ACC_ID  as acc, " + " C.CHEQUE_NO, C.CHEQUE_AUTH_PERSON, C.CREDIT_CARD_RCPT_NO, "
			+ " NVL((SELECT b.BANK_NAME FROM BANKS@COLOMBO_LIVE b WHERE b.BANK_ID = C.BANK_NAME), '-')  AS BANKNAME "
			+ " FROM LAB_TEST_INVOICES@COLOMBO_LIVE L, CASHIER_COLLECTION@COLOMBO_LIVE C "
			+ "    WHERE L.INVOICE_NO = '" + refno + "' AND L.UPIN = '" + upin + "' AND C.SERVICE_REF_NO = L.INVOICE_NO";

			rs1 = conn1.query(query1);
			while (rs1.next()) {
				NAME = rs1.getString(2);
				YY = rs1.getString(3);
				MM = rs1.getString(4);
				NIC = rs1.getString(25);
				NAT = rs1.getString(13);
				AIR = rs1.getString(12);
				DOB = rs1.getString(1);
				TELE = rs1.getString(6);
				EMAIL = rs1.getString(11);
				UPIN = rs1.getString(7);
				DATE = rs1.getString(8);
				RCPT_NO = rs1.getString(23);
				LAB_REF = rs1.getString(14);
				REF_NO = rs1.getString(24);
				UNIT = rs1.getString(20);
				DOCTOR = rs1.getString(10);
				REMARKS = rs1.getString(18);
				CASHIER_ID = rs1.getString(19);
				TOTAL = rs1.getDouble(15);
				NET_AMO = rs1.getDouble(16);
				DIS_REASON = rs1.getString(17);
				COMPANY = rs1.getString(21);
				DISCOUNT = rs1.getDouble(22);
				ACC_ID = rs1.getString("ACC_ID");
				acc = rs1.getString("acc");
				PAY_MODE = rs1.getInt(5);
				cBank = rs1.getString(31);
				ccRcpNo = rs1.getString(30);
				cNo = rs1.getString(28);
				cAuth = rs1.getString(29);
				z = rs1.getDouble(15) + rs1.getDouble(22);
		}
		} catch (Exception e) {
		conn1.flushStmtRs();
		} finally {
		conn1.flushStmtRs();
		}
		%>
		<div align="center" style="margin-top: 5pt;">
			<b><%=tmp_title%></b>
		</div>
		<div>
			<table class="table-sm" border="0" width="99%" align="center"
				style="font-size: 10pt; margin-top: 10pt; margin-bottom: 0pt; border: 0pt solid black">
				<tr>
					<td valign="top" colspan="6"><b>- Your Personal Details -</b></td>
				</tr>
				<tr>
					<td colspan="6" height="2pt"></td>
				</tr>
				<tr>
					<td valign="top" style="white-space: nowrap;">Name</td>
					<td valign="top" width="1pt">:</td>
					<td valign="top" colspan="4"><%=NAME%></td>
				</tr>
				<tr>
					<td valign="top" width="15%">Birth Date</td>
					<td valign="top" width="1pt">:</td>
					<td valign="top"><%=DOB%></td>
					<td valign="top" align="right">Age</td>
					<td valign="top" width="1pt">:</td>
					<td valign="top"><%=YY%> Y <%=MM%> M</td>
				</tr>
				<%
				if (!NIC.equals("-")) {
				%>
				<tr>
					<td valign="top">NIC No.</td>
					<td valign="top">:</td>
					<td valign="top"><%=NIC%></td>
				</tr>
				<%
				}
				%>
				<%
				if (!NAT.equals("-")) {
				%>
				<tr>
					<td valign="top">Nationality</td>
					<td valign="top">:</td>
					<td valign="top"><%=NAT%></td>
				</tr>
				<%
				}
				%>
				<%
				if (!AIR.equals("-")) {
				%>
				<tr>
					<td valign="top">Air Ticket No.</td>
					<td valign="top">:</td>
					<td valign="top"><%=AIR%></td>
				</tr>
				<%
				}
				%>
				<%
				if (!TELE.equals("-")) {
				%>
				<tr>
					<td valign="top">Telephone</td>
					<td valign="top">:</td>
					<td valign="top"><%=TELE%></td>
				</tr>
				<%
				}
				%>
				<%
				if (!EMAIL.equals("-")) {
				%>
				<tr>
					<td valign="top">Email</td>
					<td valign="top">:</td>
					<td valign="top"><%=EMAIL%></td>
				</tr>
				<%
				}
				%>
				<tr>
					<td colspan="3" height="5pt"></td>
				</tr>
			</table>
		</div>

		<div>
			<table class="table-sm" border="0" width="99%" align="center"
				style="font-size: 10pt; margin-top: 10pt; margin-bottom: 0pt; border: 0pt solid black">
				<tr>
					<td valign="top" colspan="3"><b>- Hospital References -</b></td>
				</tr>
				<tr>
					<td colspan="3" height="2pt"></td>
				</tr>
				<%
				if (!UPIN.equals("-")) {
				%>
				<tr>
					<td valign="top">UPIN</td>
					<td valign="top">:</td>
					<td valign="top"><%=UPIN%></td>
				</tr>
				<%
				}
				%>
				<tr>
					<td valign="top" width="20%">Date</td>
					<td valign="top" width="1pt">:</td>
					<td valign="top"><%=DATE%></td>
				</tr>
				<tr>
					<td valign="top">Receipt No.</td>
					<td valign="top">:</td>
					<td valign="top"><%=RCPT_NO%></td>
				</tr>
				<tr>
					<td valign="top">Ref. No.</td>
					<td valign="top">:</td>
					<td valign="top"><%=REF_NO%></td>
				</tr>

				<%
				if (!UNIT.equals("-")) {
				%>
				<tr>
					<td valign="top">Unit</td>
					<td valign="top">:</td>
					<td valign="top"><%=UNIT%></td>
				</tr>
				<%
				}
				%>
				<tr>
					<td valign="top">Doctor</td>
					<td valign="top">:</td>
					<td valign="top"><%=DOCTOR%></td>
				</tr>
				<%
				if (!COMPANY.equals("-")) {
				%>
				<tr>
					<td valign="top">Company</td>
					<td valign="top">:</td>
					<td valign="top"><%=COMPANY%></td>
				</tr>
				<%
				}
				%>
			</table>
		</div>

		<div>
			<table class="table-sm" border="0" width="99%" align="center"
				style="font-size: 10pt; margin-top: 10pt; margin-bottom: 0pt; border: 0pt solid black">
				<tr>
					<td width="3%"></td>
					<td width="80%"></td>
					<td></td>
				</tr>
				<tr>
					<td valign="top" colspan="3"><b>- Investigation Details -</b></td>
				</tr>
				<tr>
					<td colspan="3" height="2pt"></td>
				</tr>
				<tr>
					<td><u>#</u></td>
					<td colspan="2"><u>TEST NAME</u></td>
				</tr>
				<%
						
						try {
							conn2.connectToDB();
							String query2 = "SELECT T.DESCRIPTION,T.CHARGE " + "FROM LAB_TEST_BREAKDOWN@COLOMBO_LIVE B, "
							+ "     LAB_TESTS@COLOMBO_LIVE T, " + "     LAB_TEST_INVOICES@COLOMBO_LIVE L " + "WHERE L.INVOICE_NO = '"
							+ refno + "' " + "  AND T.TEST_CODE = B.TEST_PROFILE_CODE " + "  AND l.INVOICE_NO = B.INVOICE_NO "
							+ "UNION " + "SELECT LP.DESCRIPTION,LP.CHARGE "
							+ "FROM LAB_TEST_BREAKDOWN@COLOMBO_LIVE B, LAB_PROFILE@COLOMBO_LIVE LP, LAB_TEST_INVOICES@COLOMBO_LIVE L "
							+ "WHERE L.INVOICE_NO = '" + refno + "' " + "  AND LP.PROFILE_CODE = B.TEST_PROFILE_CODE "
							+ "  AND l.INVOICE_NO = B.INVOICE_NO";
							rs2 = conn2.query(query2);
						
						int count = 0;
						while (rs2.next()) {
							count++;
							DESCRIPTION = rs2.getString(1);
							double charge = 0;
							if (rs2.getFloat(2) > 0) {
								charge = rs2.getDouble(2);
							}
						%>
				<tr>
					<td valign="top"><%=count%>.</td>
					<td valign="top" colspan="2"><b><%=DESCRIPTION%></b></td>
				</tr>
				<%
						}
						} catch (Exception e) {
							conn2.flushStmtRs();
							} finally {
							conn2.flushStmtRs();
							}
						%>

				<tr>
					<td colspan="3" height="20pt"></td>
				</tr>
				<tr>
					<td colspan="3" height="5pt"></td>
				</tr>
				<tr>
					<td valign="top" colspan="3"><b>- Payment Details -</b></td>
				</tr>
				<%if(DISCOUNT > 0){ %>
				<tr>
					<td valign="top" colspan="2" align="right">GROSS AMOUNT (Rs.)
						:&nbsp;</td>
					<td valign="top" align="right"><b><%=df.format(z)%></b></td>
				</tr>
				<%} %>
				<%if(!DIS_REASON.equals("N/A")){ %>
				<tr>
					<td valign="top" colspan="2" align="right"><%=DIS_REASON%>
						(Rs.) :&nbsp;</td>
					<td valign="top" align="right"><b><%=df.format(DISCOUNT)%></b></td>
				</tr>
				<%} %>
				<tr>
					<td valign="top" colspan="2" align="right">NET AMOUNT (Rs.)
						:&nbsp;</td>
					<td valign="top" align="right"
						style="border-top: 1px solid black; border-bottom: 1px double black;"><b><%=df.format(NET_AMO)%></b></td>
				</tr>
				<tr>
					<td colspan="3" align="right" height="10pt"></td>
				</tr>
			</table>
		</div>
		<div>
			<table class="table-sm" border="0" width="99%" align="center"
				style="font-size: 10pt; margin-top: 10pt; margin-bottom: 0pt; border: 0pt solid black">


				<%
						if (PAY_MODE == 1) {
						%>
				<tr>
					<td>
						<table>
							<tr>
								<td valign="top" colspan="3">Payment Mode : CASH</td>
							</tr>
						</table>
					</td>
				</tr>
				<%
						}
						%>
				<%
						if (PAY_MODE == 2) {
						%>
				<tr>
					<td>
						<table>
							<tr>
								<td valign="top">Payment Mode</td>
								<td valign="top">:</td>
								<td valign="top">CREDIT CARD</td>
							</tr>
							<tr>
								<td valign="top">Bank Name</td>
								<td valign="top">:</td>
								<td valign="top"><%=cBank%></td>
							</tr>
							<tr>
								<td valign="top">Rcpt. No.</td>
								<td valign="top">:</td>
								<td valign="top"><%=ccRcpNo%></td>
							</tr>
						</table>
					</td>
				</tr>
				<%
						}
						%>
				<%
						if (PAY_MODE == 3) {
						%>
				<tr>
					<td>
						<table>
							<tr>
								<td valign="top">Payment Mode</td>
								<td valign="top">:</td>
								<td valign="top">CHEQUE</td>
							</tr>
							<tr>
								<td valign="top">Cheque No</td>
								<td valign="top">:</td>
								<td valign="top"><%=cNo%></td>
							</tr>
							<tr>
								<td valign="top">Bank/Branch Name</td>
								<td valign="top">:</td>
								<td valign="top"><%=cBank%></td>
							</tr>
							<tr>
								<td valign="top">Authorized Person</td>
								<td valign="top">:</td>
								<td valign="top"><%=cAuth%></td>
							</tr>
						</table>
				<tr>
					<td>
						<%
								}
								%>
					
				<tr>
					<td colspan="3" height="8pt"></td>
				</tr>
				<tr>
					<td colspan="3" height="20pt"></td>
				</tr>
				<tr>
					<td valign="top" align="left" style="">ISSUED USER : <%=CASHIER_ID%>
					</td>
				</tr>
				<tr>
					<td height="10pt"></td>
				</tr>
			</table>

			<div><%@ include file="footer.jsp"%></div>
			<%@ include file="footerout.jsp"%>
		</div>
	</div>
	<jsp:include page="download.jsp">
		<jsp:param value="<%=p%>" name="p" />
	</jsp:include>
</body>
</html>