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
String tmp_title = "SERVICE NONE APPOINTMENT RECEIPT";
			%>
<title><%=title%> | Nawaloka Hospital</title>
<script src="js/printbill.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.js"
	integrity="sha512-vNrhFyg0jANLJzCuvgtlfTuPR21gf5Uq1uuSs/EcBfVOz6oAHmjqfyPoB5rc9iWGSnVE41iuQU4jmpXMyhBrsw=="
	crossorigin="anonymous" referrerpolicy="no-referrer"></script>
</head>
<html>
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
    HttpSession sessions = request.getSession(false);
    DecimalFormat df = new DecimalFormat();
    df.setMaximumFractionDigits(2);
    df.setMinimumFractionDigits(2);

    String p = "", refno = "", upin = ""; 	
	if (request.getParameter("p") != null) {
		p = request.getParameter("p");
		refno = request.getParameter("p").split("_")[0];
		upin = request.getParameter("p").split("_")[1];			
	}

    int usbill = 0;
    ResultSet rs9 = null;
    DatabaseConnection conn9 = new DatabaseConnection();
    conn9.connectToDB();
    String query9 = "";

    try {
        query9 = "SELECT COUNT(*) FROM NONAPPOINTMENTS_BREAKDOWN@COLOMBO_LIVE B WHERE B.SERVICE_REF_NO = '" + refno + "' AND B.SERVICE_CODE = 'SER0041'";
        // out.println(query9);
        rs9 = conn9.query(query9);
        while (rs9.next()) {
            usbill = rs9.getInt(1);
        }
        conn9.flushStmtRs();
    } catch (Exception e) {
        conn9.flushStmtRs();
    }

    DatabaseConnection conn2 = new DatabaseConnection();

    try {
        conn2.connectToDB();
        ResultSet rs2 = null;
        String tes = "SELECT HS.DESCRIPTION, " +
                "       NB.SERVICE_CHARGE, " +
                "       NB.DOC_CHARGE, " +
                "       NB.DISCOUNT_ALLOWED, " +
                "       DISCOUNT_AMOUNT, " +
                "       DISCOUNT_PER, " +
                "       nvl(d.TITLE, 'N/A') || ' ' || d.FIRST_NAME || ' ' || d.LAST_NAME, " +
                "       hs.APP_NONAPP, " +
                "       hs.SERVICE_CODE " +
                "FROM NONAPPOINTMENTS_BREAKDOWN@COLOMBO_LIVE NB, " +
                "     HOSPITAL_SERVICES@COLOMBO_LIVE HS, " +
                "     doctors@COLOMBO_LIVE d " +
                "WHERE NB.SERVICE_REF_NO = '" + refno + "' " +
                "  and nb.SERVICE_DONE_DOC = d.DOC_NO(+) " +
                "  AND HS.SERVICE_CODE = NB.SERVICE_CODE";
        //  out.println(tes);
        rs2 = conn2.query(tes);


        String NAME = "", YY = "", acc = "", cBank = "", ccRcpNo = "", cNo = "", cAuth = "", REF_NO = "", MM = "", REF_DOC = "", DIS_REASON = "", EMAIL = "", COM_NAME = "", UNIT = "", TELE = "", CASHIER_ID = "", UPIN = "", DATE = "", RECIPT_NO = "", REMARKS = "", DOCTOR = "";
        double NET_AMO = 0f, TOTAL = 0f, vat = 0;
        int PAY_MODE = 0;
        String payment = " ", balance = " ", ACC_ID = "";

        DatabaseConnection conn3 = new DatabaseConnection();
        ResultSet rs3 = null;
        String nawasn = "-";
        String newnawasn = "-";
        String nnmcsn = "-";
        if (session.getAttribute("nawasn") != null) {
            nawasn = ((String) session.getAttribute("nawasn"));
        }
        if (session.getAttribute("newnawasn") != null) {
            newnawasn = ((String) session.getAttribute("newnawasn"));
        }
        if (session.getAttribute("nnmcsn") != null) {
            nnmcsn = ((String) session.getAttribute("nnmcsn"));
        }
        String tes3 = " " +
                "SELECT SN.NAME_BHT, " +
                "       NVL(SN.TELE, '-') TELE, " +
                "       SN.AGE_YY, " +
                "       SN.AGE_MM, " +
                "       NVL(SN.NID, '-')  NID, " +
                "       SN.SEX, " +
                "       NVL(d.TITLE, 'N/A') || ' ' || d.FIRST_NAME || ' ' || d.LAST_NAME, " +
                "       NVL(NC.REMARKS, 'N/A') REMARKS, " +
                "       NC.GROSS_AMOUNT, " +
                "       NC.DISCOUNT_PER, " +
                "       NC.INVOICE_NO, " +
                "       NC.DISCOUNT, " +
                "       NC.NETAMOUNT, " +
                "       NC.PAYMENT_MODE, " +
                "       NC.CASHIER_ID, " +
                "       NC.BANK_NAME, " +
                "       NC.CHEQUE_NO, " +
                "       NC.CHEQUE_AUTH_PERSON, " +
                "       NC.CREDIT_CARD_RCPT_NO, " +
                "       NVL((select distinct  DR.REASON from DISCOUNT_REASON@COLOMBO_LIVE DR where nc.DIS_REASON = DR.REASON_ID ), '-'), " +
                "       NVL((select distinct CC.NAME from CREDIT_COMPANIES@COLOMBO_LIVE CC where sn.COMPANY_ID = cc.ID), '-'), " +
                "       DECODE(NC.ACC_ID, 'A001', '" + nawasn + "', 'A002', '" + newnawasn + "', '" + nnmcsn + "') as ACC_ID, " +
                "       to_char(sn.TXN_DATE, 'DD/MM/YYYY HH12:MI AM')                                                   TXN_DATE, " +
                "       nc.ACC_ID      as acc, " +
                "       SUM(DECODE(nb.SERVICE_CODE, 'SER0689', 1, 'SER0662', 1, 'SER0017', 1, 'SER0018', 1, 'SER0044', 1, 'SER0045', 1, " +
                "                  0))    ctmri, " +
                "       NVL((SELECT U.NAME FROM UNITS@COLOMBO_LIVE U WHERE U.UNIT_CODE = SN.UNIT_CODE), '-')                      AS UNIT, " +
                "       NVL(SN.EMAIL, '-') AS EMAIL, " +
                "       NVL(SN.UPIN, '-') UPIN, " +
                "       NC.SERVICE_REF_NO, " +
                "       NVL((SELECT b.BANK_NAME FROM BANKS@COLOMBO_LIVE b WHERE b.BANK_ID = NC.BANK_NAME), '-') " +
                "FROM SERVICES_NONAPPOINTMENTS@COLOMBO_LIVE SN, " +
                "     CASHIER_COLLECTION@COLOMBO_LIVE NC, " +
                "     NONAPPOINTMENTS_BREAKDOWN@COLOMBO_LIVE NB, " +
                "     DOCTORS@COLOMBO_LIVE d " +
                " " +
                "WHERE SN.SERVICE_REF_NO = '" + refno + "' AND SN.UPIN = '" + upin + "' " +
                "  and nb.SERVICE_REF_NO = sn.SERVICE_REF_NO " +
                "  AND SN.SERVICE_REF_NO = NC.SERVICE_REF_NO " +
                "  and sn.REF_DOCTOR = d.DOC_NO(+) " +
                " " +
                "group by SN.NAME_BHT, NVL(SN.TELE, '-'), SN.AGE_YY, SN.AGE_MM, NVL(SN.NID, '-'), SN.SEX, " +
                "         NVL(d.TITLE, 'N/A') || ' ' || d.FIRST_NAME || ' ' || d.LAST_NAME, NVL(NC.REMARKS, 'N/A'), NC.GROSS_AMOUNT, " +
                "         NC.DISCOUNT_PER, NC.DISCOUNT, NC.NETAMOUNT, NC.PAYMENT_MODE, sn.COMPANY_ID, NC.BANK_NAME, NC.CHEQUE_NO, " +
                "         NC.CHEQUE_AUTH_PERSON, NC.CREDIT_CARD_RCPT_NO, nc.DIS_REASON, NC.INVOICE_NO, NC.CASHIER_ID, " +
                "         DECODE(NC.ACC_ID, 'A001','" + nawasn + "', 'A002', '" + newnawasn + "', '" + nnmcsn + "'), " +
                "         to_char(sn.TXN_DATE, 'DD/MM/YYYY HH12:MI AM'), nc.ACC_ID, SN.UNIT_CODE, NVL(SN.EMAIL, '-'), NVL(SN.UPIN, '-'), " +
                "         NC.SERVICE_REF_NO,NC.BANK_NAME  ";
       // out.println(tes3);
        try {
            conn3.connectToDB();
            rs3 = conn3.query(tes3);
            while (rs3.next()) {
                NAME = rs3.getString(1);
                YY = rs3.getString(3);
                MM = rs3.getString(4);
                TELE = rs3.getString(2);
                DATE = rs3.getString(23);
                RECIPT_NO = rs3.getString(11);
                UPIN = rs3.getString(28);
                REMARKS = rs3.getString(8);
                REF_DOC = rs3.getString(7);
                TOTAL = rs3.getDouble(9);
                NET_AMO = rs3.getDouble(13);
                PAY_MODE = rs3.getInt(14);
                CASHIER_ID = rs3.getString(15);
                EMAIL = rs3.getString(27);
                UNIT = rs3.getString(26);
                COM_NAME = rs3.getString(21);
                DIS_REASON = rs3.getString(20);
                REF_NO = rs3.getString(29);
                ACC_ID = rs3.getString("ACC_ID");
                acc = rs3.getString("acc");
                cBank = rs3.getString(30);
                ccRcpNo = rs3.getString(17);
                cNo = rs3.getString(19);
                cAuth = rs3.getString(18);
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
						<td valign="top" width="1pt">:</td>
						<td valign="top"><%=NAME%></td>
					</tr>
					<tr>
						<td valign="top" style="white-space: nowrap;">Age</td>
						<td valign="top">:</td>
						<td valign="top"><%=YY%> Y <%=MM%></td>
					</tr>
					<tr>
						<td valign="top" style="white-space: nowrap;">Telephone</td>
						<td valign="top">:</td>
						<td valign="top"><%=TELE%></td>
					</tr>
					<%
                    if (!EMAIL.equals("-")) {
                %>
					<tr>
						<td valign="top" style="white-space: nowrap;">Email</td>
						<td valign="top">:</td>
						<td valign="top"><%=EMAIL%></td>

					</tr>
					<%}%>

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
						<td valign="top" style="white-space: nowrap;">UPIN</td>
						<td valign="top">:</td>
						<td valign="top"><%=UPIN%></td>
					</tr>
					<tr>
						<td valign="top" style="white-space: nowrap;">Date</td>
						<td valign="top">:</td>
						<td valign="top"><%=DATE%></td>
					</tr>


					<tr>
						<td valign="top" style="white-space: nowrap;">Receipt No.</td>
						<td valign="top">:</td>
						<td valign="top"><%=RECIPT_NO%></td>

					</tr>
					<tr>
						<td valign="top" style="white-space: nowrap;">Ref. No.</td>
						<td valign="top">:</td>
						<td valign="top"><%=REF_NO%></td>

					</tr>
					<%
                    if (REMARKS.equalsIgnoreCase("N/A") || REMARKS.equalsIgnoreCase("")) {
                    } else {
                %>
					<tr>
						<td valign="top" style="white-space: nowrap;">Remarks</td>
						<td valign="top">:</td>
						<td valign="top"><%=REMARKS%></td>

					</tr>
					<%}%>
					<tr>
						<td valign="top" style="white-space: nowrap;">Doctor</td>
						<td valign="top">:</td>
						<td valign="top"><%=REF_DOC%></td>

					</tr>
					<%
                    if (!COM_NAME.equals("-")) {
                %>
					<tr>
						<td valign="top" style="white-space: nowrap;">Company Name</td>
						<td valign="top">:</td>
						<td valign="top"><%=COM_NAME%></td>

					</tr>
					<%}%>
					<%
                    if (!UNIT.equals("-")) {
                %>
					<tr>
						<td valign="top" style="white-space: nowrap;">Unit</td>
						<td valign="top">:</td>
						<td valign="top"><%=UNIT%></td>

					</tr>
					<%}%>
				</table>
			</div>
			<div>
				<table class="table-sm" border="0" width="99%" align="center"
					style="font-size: 10pt; margin-top: 10pt; margin-bottom: 0pt; border: 0pt solid black">
					<tr>
						<td colspan="3" height="10pt"></td>
					</tr>
					<tr>
						<td valign="top" colspan="3"><b>- Services/Payment
								Details -</b></td>
					</tr>
					<tr>
						<td colspan="3" height="2pt"></td>
					</tr>
					<tr>
						<td><u>#</u></td>
						<td><u>SERVICE NAME</u></td>
						<td align="right"><u>AMOUNT</u></td>
					</tr>
					<tr>
						<td colspan="3" height="3pt"></td>
					</tr>
					<%
                                int count = 0;
                                while (rs2.next()) {
                                    count++;
                                    String sName = rs2.getString(1);
                                    if (sName.equals("LANEROLLE SANATH DR.") && usbill > 0) {
                                        sName = "PROFESSIONAL CHARGES";
                                    }
                                    //serCode = rs1.getString("SERVICE_CODE");
                                    double charge = 0;
                                    if (rs2.getFloat(2) > 0) {
                                        charge = rs2.getDouble(2);
                                    }
                                    if (rs2.getFloat(3) > 0) {
                                        charge = rs2.getDouble(3);
                                    }
                            %>
					<tr>
						<td valign="top"><%=count%>.</td>
						<td valign="top"><b><%=sName%></b></td>
						<td valign="top" align="right"><b><%=df.format(charge)%></b></td>
					</tr>
					<%
                                }

                            %>
					<%
                                if ((TOTAL - NET_AMO) > 0) {
                            %>
					<tr>
						<td valign="top" colspan="2" align="right">GROSS AMOUNT
							(Rs.):&nbsp;</td>
						<td valign="top" align="right"
							style="border-top: 1px solid black;"><b><%=df.format(TOTAL)%></b></td>
					</tr>
					<tr>
						<td valign="top" colspan="2" align="right"><%=DIS_REASON%>
							(Rs.):&nbsp;</td>
						<td valign="top" align="right" style=""><b><%=df.format((TOTAL - NET_AMO))%></b>
						</td>
					</tr>
					<%}%>
					<tr>
						<td valign="top" colspan="2" align="right">NET AMOUNT
							(Rs.):&nbsp;</td>
						<td valign="top" align="right"
							style="border-top: 1px solid black; border-bottom: 1px solid black;"><b><%=df.format(NET_AMO)%></b>
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
					<% if (PAY_MODE == 1) {

                            %>
					<tr>
						<td valign="top" colspan="3">Payment Mode : CASH</td>
					</tr>
					<%}%>
					<% if (PAY_MODE == 2) {
                     %>
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
						<td valign="top"><%=cNo%></td>
					</tr>
					<%}%>
					<% if (PAY_MODE == 3) {

                            %>
					<tr>
						<td valign="top" style="white-space: nowrap;">Payment Mode</td>
						<td valign="top">:</td>
						<td valign="top">CHEQUE</td>
					</tr>
					<tr>
						<td valign="top" style="white-space: nowrap;">Cheque No</td>
						<td valign="top">:</td>
						<td valign="top"><%=ccRcpNo%></td>
					</tr>
					<tr>
						<td valign="top" style="white-space: nowrap;">Bank/Branch
							Name</td>
						<td valign="top">:</td>
						<td valign="top"><%=cBank%></td>
					</tr>
					<tr>
						<td valign="top" style="white-space: nowrap;">Authorized
							Person</td>
						<td valign="top">:</td>
						<td valign="top"><%=cAuth%></td>
					</tr>
					<%}%>
					<tr>
						<td colspan="3" height="5pt"></td>
					</tr>
					<tr>
						<td height="10pt"></td>
					</tr>
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
                                        today = rs4.getString(1);%>
					<tr>
						<td valign="top" align="left">REPRINTED DATE: <%=today%>
						</td>
					</tr>
					<%
                                    }
                                    conn4.flushStmtRs();
                                } catch (Exception ex) {
                                    conn4.flushStmtRs();
                                }
                            %>
					<tr>
						<td height="10pt"></td>
					</tr>
				</table>
			</div>
			<div><%@ include file="footer.jsp"%></div>
			<%@ include file="footerout.jsp"%>
		</div>
		<%
            }
            conn3.flushStmtRs();
        } catch (Exception e) {
            out.println(e);
            conn3.flushStmtRs();
        }
    } catch (Exception ex) {
        out.println(ex);
        conn2.flushStmtRs();
    }%>
	</div>
	<jsp:include page="download.jsp">
		<jsp:param value="<%=p%>" name="p" />
	</jsp:include>
</body>
</html>