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
String tmp_title = "OPD APPOINTMENT RECEIPT";
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
					alt="Nawaloka Laboratory" height="40">&nbsp;&nbsp;NAWALOKA
				HOSPITALS PLC
				<div align="center" style="margin-top: -7pt; color: white">
					<b><%=title%></b>
				</div>
			</div>
		</div>
		<%
		DecimalFormat df = new DecimalFormat();
		df.setMaximumFractionDigits(2);
		df.setMinimumFractionDigits(2);
		ResultSet rs = null;

		String p = "", refno = "", upin = ""; 	
		if (request.getParameter("p") != null) {
			p = request.getParameter("p");
			refno = request.getParameter("p").split("_")[0];
			upin = request.getParameter("p").split("_")[1];			
		}

		DatabaseConnection conn = new DatabaseConnection();

		String query = "";

		String APP_TIME = "", NAME = "", AGE = "", REF_NO = "", REF_DOC = "", RECIPT_DATE = "", RECT_NO = "", DIS_REASON = "",
				EMAIL = "", COM_NAME = "", UNIT = "", TELE = "", CASHIER_ID = "", UPIN = "", DATE = "", RECIPT_NO = "",
				REMARKS = "", DOCTOR = "", APP_NO = "", APP_DATE = "", SERVICE = "", CAT = "", ACC_ID = "", acc = "",
				cBank = "", ccRcpNo = "", cNo = "", cAuth = "";
		double NET_AMO = 0f, TOTAL = 0f, OTH_FEE = 0f, DOC_FEE = 0f, HOS_FEE = 0f, DISCOUNT = 0f, vat = 0;
		int PAY_MODE = 0;

		try {
			conn.connectToDB();
			query = "SELECT s.BHT_PNAME, "
			+ " (NVL(S.AGE_YY, '0') || 'Y ' || NVL(S.AGE_MM, '0') || 'M ' || NVL(S.AGE_DD, '0') || 'D')   AGE, "
			+ " NVL(S.TELE, '-')      TELE, " + " NVL(S.UPIN, '-'), " + " C.INVOICE_NO, "
			+ " to_char(c.TXN_DATE, 'DD/MM/YYYY HH12:MI AM'), " + " C.SERVICE_REF_NO, " + " S.PATIENT_NO, "
			+ " UPPER(TO_CHAR(S.APP_DATE, 'Dy, DD/MM/YYYY')), " + " LPAD(S.APP_TIME, 4, 0), " + " x.DESCRIPTION, "
			+ " d.title || ' ' || d.first_name || ' ' || d.last_name    dname, "
			+ " NVL((SELECT U.NAME FROM UNITS@COLOMBO_LIVE U WHERE U.UNIT_CODE = S.UNIT_CODE), '-') AS UNIT, "
			+ " NVL((select distinct CC.NAME from CREDIT_COMPANIES@COLOMBO_LIVE CC where S.CREDIT_AGENT_ID = cc.ID), '-') AS COMPANY, "
			+ " s.SERVICE_CODE   as   code, " + " NVL((SELECT S1.SERVICE_SUB_NAME "
			+ " FROM HOSPITAL_SERVICES_SUB_CAT@COLOMBO_LIVE S1 "
			+ " WHERE S1.SERVICE_SUB_CODE = s.SERVICE_SUB_CAT_CODE), '-'), " + " nvl(s.OTHER_FEE1, 0), "
			+ " c.PAYMENT_MODE, " + " s.DOC_FEE, " + " s.HOS_FEE, " + " C.DISCOUNT, " + " C.GROSS_AMOUNT, "
			+ " C.NETAMOUNT, "
			+ " NVL((select distinct DR.REASON from DISCOUNT_REASON@COLOMBO_LIVE DR where C.DIS_REASON = DR.REASON_ID), '-'), "
			+ " S.REMARKS, " + " C.CASHIER_ID, " + " C.ACC_ID     as acc, " + " C.CHEQUE_NO, "
			+ " C.CHEQUE_AUTH_PERSON, " + " C.CREDIT_CARD_RCPT_NO, "
			+ " NVL((SELECT b.BANK_NAME FROM BANKS@COLOMBO_LIVE b WHERE b.BANK_ID = C.BANK_NAME), '-')    AS BANKNAME "
			+ ", NVL(S.EMAIL,'-') EMAIL, SUBSTR(S.APP_TIME,0,2) || ':' || SUBSTR(S.APP_TIME,3) APP_TIME "

			+ "FROM SERVICE_APPOINTMENTS@COLOMBO_LIVE S, CASHIER_COLLECTION@COLOMBO_LIVE C, HOSPITAL_SERVICES@COLOMBO_LIVE x, doctors@COLOMBO_LIVE d "
			+ "WHERE S.SERVICE_REF_NO = '" + refno + "' " + "  AND S.SERVICE_REF_NO = C.SERVICE_REF_NO "
			+ "  AND s.SERVICE_CODE = x.SERVICE_CODE " + "  and d.doc_no = s.SERVICE_DONE_DOC_id";

			rs = conn.query(query);
			System.out.println(query);
			while (rs.next()) {
				EMAIL = rs.getString("EMAIL");
				APP_TIME = rs.getString("APP_TIME");
				NAME = rs.getString(1);
				// out.println(NAME);
				AGE = rs.getString(2);
				TELE = rs.getString(3);
				UPIN = rs.getString(4);
				RECIPT_NO = rs.getString(5);
				RECIPT_DATE = rs.getString(6);
				REF_NO = rs.getString(7);
				APP_NO = rs.getString(8);
				APP_DATE = rs.getString(9);
				SERVICE = rs.getString(11);
				CAT = rs.getString(16);
				DOCTOR = rs.getString(12);
				UNIT = rs.getString(13);
				COM_NAME = rs.getString(14);
				OTH_FEE = rs.getDouble(17);
				PAY_MODE = rs.getInt(18);
				DOC_FEE = rs.getDouble(19);
				HOS_FEE = rs.getDouble(20);
				DISCOUNT = rs.getDouble(21);
				TOTAL = rs.getDouble(22);
				NET_AMO = rs.getDouble(23);
				DIS_REASON = rs.getString(24);
				REMARKS = rs.getString(25);
				CASHIER_ID = rs.getString(26);
				ACC_ID = rs.getString(27);
				acc = rs.getString("acc");

				cBank = rs.getString(31);
				ccRcpNo = rs.getString(30);
				cNo = rs.getString(28);
				cAuth = rs.getString(29);
		%>

		<div align="center" style="margin-top: 5pt;">
			<b><%=tmp_title%></b>
		</div>
		<div>
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
						<td align="center" valign="top" width="1pt">:</td>
						<td valign="top"><%=NAME%></td>
					</tr>
					<tr>
						<td align="left" style="white-space: nowrap;" valign="top">Age</td>
						<td align="center" valign="top">:</td>
						<td align="left" valign="top"><%=AGE%></td>
					</tr>
					<%
						if (!TELE.equals("-")) {
						%>
					<tr>
						<td align="left" style="white-space: nowrap;" valign="top">Telephone</td>
						<td align="center" valign="top">:</td>
						<td align="left" valign="top"><%=TELE%></td>
					</tr>
					<%
						}
						%>
					<%
						if (!EMAIL.equals("-")) {
						%>
					<tr>
						<td align="left" style="white-space: nowrap;" valign="top">Email</td>
						<td align="center" valign="top">:</td>
						<td align="left" valign="top"><%=EMAIL%></td>
					</tr>
					<%
						}
						%>
					<tr>
						<td colspan="3" height="15pt"></td>
					</tr>
					<tr>
						<td valign="top" colspan="3"><b>- Hospital References -</b></td>
					</tr>
					<tr>
						<td colspan="3" height="2pt"></td>
					</tr>
					<tr>
						<td align="left" style="white-space: nowrap;" valign="top">UPIN</td>
						<td align="center" valign="top">:</td>
						<td align="left" valign="top"><%=UPIN%></td>
					</tr>
					<tr>
						<td align="left" style="white-space: nowrap;" valign="top">Receipt
							No.</td>
						<td align="center" valign="top">:</td>
						<td align="left" valign="top"><%=RECIPT_NO%></td>
					</tr>
					<tr>
						<td align="left" style="white-space: nowrap;" valign="top">Date</td>
						<td align="center" valign="top">:</td>
						<td align="left" valign="top"><%=RECIPT_DATE%></td>
					</tr>
					<tr>
						<td align="left" style="white-space: nowrap;" valign="top">Ref.
							No.</td>
						<td align="center" valign="top">:</td>
						<td align="left" valign="top"><%=REF_NO%></td>
					</tr>
					<tr>
						<td colspan="3" height="2pt"></td>
					</tr>
					<tr>
						<td valign="top" colspan="3"><b>- Appointment Details -</b></td>
					</tr>
					<tr>
						<td colspan="3" height="2pt"></td>
					</tr>
					<tr>
						<td align="left" style="white-space: nowrap;" valign="top">Number</td>
						<td align="center" valign="top">:</td>
						<td align="left" valign="top"><%=APP_NO%></td>
					</tr>
					<tr>
						<td align="left" style="white-space: nowrap;" valign="top">Time</td>
						<td align="center" valign="top">:</td>
						<td align="left" valign="top"><%=APP_TIME%></td>
					</tr>
					<tr>
						<td align="left" style="white-space: nowrap;" valign="top">Date</td>
						<td align="center" valign="top">:</td>
						<td align="left" valign="top"><%=APP_DATE%></td>
					</tr>
					<tr>
						<td align="left" style="white-space: nowrap;" valign="top">Service</td>
						<td align="center" valign="top">:</td>
						<td align="left" valign="top"><b><%=SERVICE%></b></td>
					</tr>
					<tr>
						<td align="left" style="white-space: nowrap;" valign="top">Category</td>
						<td align="center" valign="top">:</td>
						<td align="left" valign="top"><b><%=CAT%></b></td>
					</tr>
					<tr>
						<td align="left" style="white-space: nowrap;" valign="top">Doctor</td>
						<td align="center" valign="top">:</td>
						<td align="left" valign="top"><%=DOCTOR%></td>
					</tr>
					<%
						if (!UNIT.equals("-")) {
						%>
					<tr>
						<td align="left" style="white-space: nowrap;" valign="top">Unit</td>
						<td align="center" valign="top">:</td>
						<td align="left" valign="top"><%=UNIT%></td>
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
						<td colspan="3" height="5pt"></td>
					</tr>
					<tr>
						<td valign="top" colspan="3"><b>- Payment Details -</b></td>
					</tr>
					<%
						if (!df.format(OTH_FEE).equals("0.00")) {
						%>
					<tr>
						<td valign="top" align="right">REPORTING FEE (Rs.) : &nbsp;</td>
						<td valign="top" align="right"><b><%=df.format(OTH_FEE)%></b></td>

					</tr>
					<%
						}

						if (!df.format(DOC_FEE).equals("0.00")) {
						%>
					<tr>
						<td valign="top" align="right">DOCTOR FEE (Rs.) : &nbsp;</td>
						<td valign="top" align="right"><b><%=df.format(DOC_FEE)%></b></td>

					</tr>
					<%
						}
						%>
					<tr>
						<td valign="top" align="right">HOSPITAL FEE (Rs.) : &nbsp;</td>
						<td valign="top" align="right"><b><%=df.format(HOS_FEE)%></b></td>
					</tr>
					<%
						if (!df.format(DISCOUNT).equals("0.00")) {
						%>
					<tr>
						<td valign="top" align="right"><%=DIS_REASON%></td>
						<td valign="top" align="right"><b><%=df.format(DISCOUNT)%></b></td>
					</tr>
					<%
						}
						%>
					<%-- <tr>
                    <td valign="top" align="right">GROSS AMOUNT:</td>

                    <td valign="top" align="right"><%=df.format(TOTAL)%>
                    </td>

                </tr> --%>
					<tr>
						<td valign="top" align="right">NET AMOUNT (Rs.) : &nbsp;</td>
						<td valign="top" align="right"
							style="border-top: 1px solid black; border-bottom: 1px double black;"><b><%=df.format(NET_AMO)%></b>
						</td>
					</tr>
					<tr>
						<td valign="top" align="right">&nbsp;</td>
						<td valign="top" align="right"
							style="border-top: 1px solid black;">&nbsp;</td>
					</tr>
					<%
						if (PAY_MODE == 1) {
						%>
					<tr>
						<td colspan="2" align="left">Payment Mode : CASH</td>
					</tr>
					<%
						}
						%>
					<%
						if (PAY_MODE == 2) {
						%>
					<tr>
						<td colspan="2"><table>
								<%if(cBank.equals("WEBX")){ %>
								<tr>
									<td valign="top" style="white-space: nowrap;">Payment Mode</td>
									<td valign="top">:</td>
									<td valign="top">ONLINE</td>
								</tr>
								<tr>
									<td valign="top" style="white-space: nowrap;">Payment
										Method</td>
									<td valign="top">:</td>
									<td valign="top"><%=cBank%></td>
								</tr>
								<%}else{ %>
								<tr>
									<td valign="top" style="white-space: nowrap;">Payment Mode</td>
									<td valign="top">:</td>
									<td valign="top">CREDIT CARD</td>
								</tr>
								<tr>
									<td valign="top" style="white-space: nowrap;">Bank Name</td>
									<td valign="top">:</td>
									<td valign="top"><%=cBank%></td>
								</tr>
								<tr>
									<td valign="top" style="white-space: nowrap;">Rcpt. No.</td>
									<td valign="top">:</td>
									<td valign="top"><%=ccRcpNo%></td>
								</tr>
								<%} %>
							</table></td>
					</tr>
					<%
						}
						%>
					<%
						if (PAY_MODE == 3) {
						%>
					<tr>
						<td colspan="2"><table>

								<tr>
									<td valign="top" style="white-space: nowrap;">Payment Mode</td>
									<td valign="top">:</td>
									<td valign="top">CHEQUE</td>
								</tr>

								<tr>
									<td valign="top" style="white-space: nowrap;">Cheque No.</td>
									<td valign="top">:</td>
									<td valign="top"><%=cNo%></td>
								</tr>
								<tr>
									<td valign="top" style="white-space: nowrap;">Bank/Branch</td>
									<td valign="top">:</td>
									<td valign="top"><%=cBank%></td>
								</tr>
								<tr>
									<td valign="top" style="white-space: nowrap;">Authorized
										By</td>
									<td valign="top">:</td>
									<td valign="top"><%=cAuth%></td>
								</tr>
								<%
									}
									%>
								<%
						if (REMARKS.equalsIgnoreCase("N/A") || REMARKS.equalsIgnoreCase("")) {
						} else {
						%>
								<tr>
									<td colspan="3" valign="top" style="white-space: nowrap;"
										align="left">Remarks :<%=REMARKS%>
									</td>
								</tr>
								<%
						}
						%>
							</table></td>
					</tr>
					<tr>
						<td colspan="2" height="10pt"></td>
					</tr>
					<tr>
						<td colspan="2">
							<table class="table-sm" border="0" width="99%" align="center"
								style="font-size: 10pt; margin-top: 10pt; margin-bottom: 0pt; border: 0pt solid black">
								<tr>
									<td valign="top" align="left" style="">ISSUED USER : <%=CASHIER_ID%>
									</td>
								</tr>
								<%
									DatabaseConnection conn4 = new DatabaseConnection();
									try {
										conn4.connectToDB();
										ResultSet rs4 = null;
										String today = "";
										String d = "select to_char(SYSDATE,'DD/MM/YYYY HH12:MI AM') from DUAL@COLOMBO_LIVE";
										rs4 = conn4.query(d);
										if (rs4.next()) {
											today = rs4.getString(1);
									%>

								<%
									}
									} catch (Exception ex) {
									conn4.flushStmtRs();
									}
									%>
								<tr>
									<td height="10pt"></td>
								</tr>
								<tr>
									<td height="10pt"></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>

		</div>
		<%
		}
		conn.flushStmtRs();
		} catch (Exception e) {
		out.println(e);
		conn.flushStmtRs();
		}
		%>
		<div><%@ include file="footer.jsp"%></div>
		<%@ include file="footerout.jsp"%>
	</div>
	<jsp:include page="download.jsp">
		<jsp:param value="<%=p%>" name="p" />
	</jsp:include>
</body>
</html>