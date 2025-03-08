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
String tmp_title = "OPD DRUG ISSUE BILL";
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
		
		String p = ""; 	
		if (request.getParameter("p") != null) {
			p = request.getParameter("p");
		}
		
		ResultSet rs1 = null;
		ResultSet rs2 = null;
		String[] arr = new String[15];
		int PAY_MODE = 0;
		DatabaseConnection conn1 = new DatabaseConnection();
		DatabaseConnection conn2 = new DatabaseConnection();
		double z = 0;
		
		try {
			conn1.connectToDB();
			String query1 = "SELECT O.TOKEN_NO, TO_CHAR(O.OUTDOOR_ISSUE_DATE, 'YYYY-MM-DD HH12:MI AM') TXN_DATE, O.PATIENT_NAME, O.AGE, O.AGE_MONTHS, O.TELEPHONE, " 
					+"(SELECT D.TITLE || ' ' || D.FIRST_NAME || ' ' || D.LAST_NAME FROM DOCTORS@COLOMBO_LIVE D WHERE D.DOC_NO = O.DOCTOR_NO) DOCTOR, UPPER(O.USER_ID),"
					+" O.DISCOUNT_AMOUNT, O.ISSUE_PAYMENT_TYPE, O.TOTAL_AMOUNT, "
					+"NVL((SELECT D.REASON FROM DISCOUNT_REASON@COLOMBO_LIVE D WHERE D.REASON_ID = O.REASON_ID),'-') DISCOUNT_REASON, "
					+"O.ISSUE_STATUS, NVL((SELECT B.BANK_NAME FROM BANKS@COLOMBO_LIVE B WHERE B.BANK_ID = O.BANK_ID),'-'), NVL(O.CREDIT_CARD_NUMBER,'-') "
					+"FROM OUTDOOR_PATIENT_ISSUE@COLOMBO_LIVE O WHERE O.OUTDOOR_INVOICE_NO = '" + p + "'";

			rs1 = conn1.query(query1);
			while (rs1.next()) {
				arr[0] = rs1.getString(1);
				arr[1] = rs1.getString(2);
				arr[2] = rs1.getString(3);
				arr[3] = rs1.getString(4);
				arr[4] = rs1.getString(5);
				arr[5] = rs1.getString(6);
				arr[6] = rs1.getString(7);
				arr[7] = rs1.getString(8);
				arr[8] = rs1.getString(9);
				arr[9] = rs1.getString(10);
				arr[10] = rs1.getString(11);
				arr[11] = rs1.getString(12);
				arr[12] = rs1.getString(13);
				arr[13] = rs1.getString(14);
				arr[14] = rs1.getString(15);
		}
		} catch (Exception e) {
		conn1.flushStmtRs();
		} finally {
		conn1.flushStmtRs();
		}
		%>
		<%if(arr[12].equals("0")){ %>

		<div align="center" style="margin-top: 5pt;">
			<b><%=tmp_title%></b>
		</div>
		<div>
			<table class="table-sm" border="0" width="99%" align="center"
				style="font-size: 10pt; margin-top: 10pt; margin-bottom: 0pt; border: 0pt solid black">
				<tr>
					<td valign="top" colspan="3"><b>- Your Personal Details -</b></td>
				</tr>
				<tr>
					<td colspan="3" height="2pt"></td>
				</tr>
				<tr>
					<td valign="top" style="white-space: nowrap;" width="15%">Name</td>
					<td valign="top" width="1pt">:</td>
					<td valign="top"><%=arr[2]%></td>
				</tr>
				<tr>
					<td valign="top" style="white-space: nowrap;">Age</td>
					<td valign="top" width="1pt">:</td>
					<td valign="top"><%=arr[3]%> YRS <%=arr[4]%> MONTHS</td>
				</tr>
				<tr>
					<td valign="top" style="white-space: nowrap;">Telephone</td>
					<td valign="top" width="1pt">:</td>
					<td valign="top"><%=arr[5]%></td>
				</tr>
				<tr>
					<td colspan="3" height="10pt"></td>
				</tr>
				<tr>
					<td valign="top" colspan="3"><b>- Hospital References -</b></td>
				</tr>
				<tr>
					<td colspan="3" height="2pt"></td>
				</tr>
				<tr>
					<td valign="top" style="white-space: nowrap;">Bill No</td>
					<td valign="top" width="1pt">:</td>
					<td valign="top"><%=p%></td>
				</tr>
				<tr>
					<td valign="top" style="white-space: nowrap;">Date</td>
					<td valign="top" width="1pt">:</td>
					<td valign="top"><%=arr[1]%></td>
				</tr>
				<%if(arr[6] != null){ %>
				<tr>
					<td valign="top" style="white-space: nowrap;">Doctor</td>
					<td valign="top" width="1pt">:</td>
					<td valign="top"><%=arr[6]%></td>
				</tr>
				<%} %>
				<tr>
					<td valign="top" style="white-space: nowrap;">Token No.</td>
					<td valign="top" width="1pt">:</td>
					<td valign="top"><%=arr[0]%></td>
				</tr>
			</table>
		</div>
		<div>
			<table class="table-sm" border="0" width="99%" align="center"
				style="font-size: 10pt; margin-top: 10pt; margin-bottom: 0pt; border: 0pt solid black">
				<tr>
					<td colspan="3" height="10pt"></td>
				</tr>
				<tr>
					<td valign="top" colspan="3"><b>- Medication/Payment
							Details -</b></td>
				</tr>
				<tr>
					<td colspan="3" height="2pt"></td>
				</tr>
				<tr>
					<td colspan="3">
						<table border="0" width="100%">
							<tr>
								<td><u>#</u></td>
								<td><u>Drug Name</u></td>
								<td><u>Category</u></td>
								<td><u>Batch No.</u></td>
								<td align="right"><u>Qty</u></td>
								<td align="right"><u>Unit Price</u></td>
								<td align="right"><u>Amount</u></td>
							</tr>
							<%						
						try {
							conn2.connectToDB();
							String query2 = "SELECT (DI.TRADE_NAME || '-' || DI.WEIGHT) DRUG_NAME, GI.BATCH_NO, DC.CATEGORY_NAME, "
									+"SUM(O.QUANTITY) QUANTITY, SUM(O.TOTAL_AMOUNT/O.QUANTITY) UNIT_PRICE, SUM(O.TOTAL_AMOUNT) TOTAL_AMOUNT "
									+"FROM OUTDOOR_ISSUE_ITEM@COLOMBO_LIVE O, DRUG_ITEM@COLOMBO_LIVE DI, DRUG_CATEGORY@COLOMBO_LIVE DC, GRN_DRUG_ITEM@COLOMBO_LIVE GI "
									+"Where GI.GRN_NO = O.GRN_NO AND GI.ITEM_NO = O.ITEM_NO AND DC.CATEGORY_NO = DI.CATEGORY_NO AND O.ITEM_NO = DI.ITEM_NO AND "
									+"O.OUTDOOR_INVOICE_NO = '" + p +"' "
									+"GROUP BY DI.TRADE_NAME, DI.WEIGHT, DC.CATEGORY_NAME, GI.BATCH_NO "
									+"ORDER BY 1";
							rs2 = conn2.query(query2);						
						int count = 0;
						while (rs2.next()) {
							count++;
						%>
							<tr>
								<td valign="top"><%=count%>.</td>
								<td valign="top"><b><%=rs2.getString(1)%></b></td>
								<td valign="top"><%=rs2.getString(3)%></td>
								<td valign="top"><%=rs2.getString(2)%></td>
								<td valign="top" align="right"><b><%=rs2.getString(4)%></b></td>
								<td valign="top" align="right"><b><%=df.format(rs2.getDouble(5))%></b></td>
								<td valign="top" align="right"><b><%=df.format(rs2.getDouble(6))%></b></td>
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
								<td colspan="7" height="20pt"></td>
							</tr>
							<%if(Double.parseDouble(arr[8]) > 0){ %>
							<tr>
								<td valign="top" colspan="6" align="right">GRAND TOTAL
									(Rs.) :&nbsp;</td>
								<td valign="top" align="right"
									style="border-top: 1px solid black;"><b><%=df.format(Double.parseDouble(arr[10]) + Double.parseDouble(arr[8]))%></b></td>
							</tr>
							<tr>
								<td valign="top" colspan="6" align="right"><%= arr[11]%>
									(Rs.) :&nbsp;</td>
								<td valign="top" align="right" style=""><b><%=df.format(Double.parseDouble(arr[8])) %></b></td>
							</tr>
							<%} %>
							<tr>
								<td valign="top" colspan="6" align="right">NET AMOUNT (Rs.)
									:&nbsp;</td>
								<td valign="top" align="right"
									style="border-top: 1px solid black; border-bottom: 1px double black;"><b>
										<%=df.format(Double.parseDouble(arr[10])) %></b></td>
							</tr>
						</table>
					</td>
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
						if (Integer.parseInt(arr[9]) == 1) {
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
						} if (Integer.parseInt(arr[9]) == 2) {
						%>
				<tr>
					<td>
						<table>
							<tr>
								<td valign="top">Payment Mode</td>
								<td valign="top">:</td>
								<td valign="top">
									<%if(arr[13].equals("WEBX")){ %>ONLINE<%}else{ %>CREDIT CARD<%} %>
								</td>
							</tr>
							<%if(!arr[13].equals("WEBX")){ %>
							<tr>
								<td valign="top">Bank Name</td>
								<td valign="top">:</td>
								<td valign="top"><%=arr[13]%></td>
							</tr>
							<%} %>
							<%-- <tr>
								<td valign="top">Rcpt. No.</td>
								<td valign="top">:</td>
								<td valign="top"><%=arr[14]%></td>
							</tr> --%>
						</table>
					</td>
				</tr>
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
					<td valign="top" align="left">ISSUED USER : <%=arr[7]%>
					</td>
				</tr>
				<tr>
					<td height="10pt"></td>
				</tr>
			</table>
		</div>
		<%}else{ %>
		<h1 style="color: red">Canceled...</h1>
		<%} %>
		<div><%@ include file="footer.jsp"%></div>
		<%@ include file="footerout.jsp"%>
	</div>
	<jsp:include page="download.jsp">
		<jsp:param value="<%=p%>" name="p" />
	</jsp:include>
</body>
</html>