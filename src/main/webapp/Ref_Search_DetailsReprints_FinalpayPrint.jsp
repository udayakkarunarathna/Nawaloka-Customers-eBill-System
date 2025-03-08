<%@ page import="com.model.db.DatabaseConnection" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<%@ include file="noCache.jsp" %>
<!-- create by Udaya
Date : 02/04/2023
 -->
<html>
<head>
    <link rel="stylesheet" href="pop_style.css"/>
    <meta name="GENERATOR" content="Microsoft FrontPage 5.0">
    <meta name="ProgId" content="FrontPage.Editor.Document">
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <link href="print_css/print.css" rel="stylesheet" type="text/css">

    <%--    MK Thermal printout--%>
    <script type="text/javascript">
        function openPDF() {
            this.window.focus();
            this.window.print();
            location.href='home.jsp'
        }
    </script>
    <style>
      /*   * {

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
    String refNo7 = request.getParameter("refNo7");
    refNo7 = refNo7.trim();

    DatabaseConnection conn = new DatabaseConnection();
    DatabaseConnection conn1 = new DatabaseConnection();
    DatabaseConnection conn2 = new DatabaseConnection();
    conn2.connectToDB();
    conn.connectToDB();
    conn1.connectToDB();

    String NAME = "", DOB = "", BHT = "", YY = "", MM = "", cBank = "", ccRcpNo = "", cNo = "", cAuth = "", UPIN = "", DATE = "", RCPT_NO = "", REF_NO = "",
            DESCRIPTION = "", REMARKS = "", CASHIER_ID = "", DIS_REASON = "", ONLINE_INVO = "", mode = "";
    String ACC_ID = "", acc = "" , Stat="";

    int PAY_MODE = 0;

    double TOTAL = 0, NET_AMO = 0, DISCOUNT = 0, total = 0, vat = 0;
    ResultSet rs = null;
    ResultSet rs1 = null;
    ResultSet rs2 = null;

    try {
        String query = "SELECT pr.TITLE || ' ' || nvl(pr.INITIALS, '') || ' ' || nvl(pr.SURNAME, ''),\n" +
                "       c.INVOICE_NO,\n" +
                "       NVL((select distinct HV.PIN_NO from HOSPITAL_VISIT HV where HV.REGISTRATION_NO = PR.REGISTRATION_NO), '-'),\n" +
                "       to_char(c.TXN_DATE, 'dd/mm/yyyy hh:mi PM') as TXN_DATE,\n" +
                "       ech.BHT_NO,\n" +
                "       c.GROSS_AMOUNT,\n" +
                "       C.NETAMOUNT,\n" +
                "       C.DISCOUNT,\n" +
                "       C.CASHIER_ID,\n" +
                "           DECODE(C.ACC_ID, 'A001', 'NAWALOKA', 'A002', 'NEW NAWALOKA', 'NEW NAWALOKA MEDICAL CENTER') as ACC_ID,\n" +
                "           C.ACC_ID                                                                                  as acc,\n" +
                "       DECODE(ech.PAYMENT_TYPE,1,'INITIAL',2,'FURTHER',3,'FINAL') as Stat\n" +
                "FROM CASHIER_COLLECTION c,\n" +
                "     ECHPAYMENTS ech,\n" +
                "     PATIENT_REGISTRATION pr,\n" +
                "     echbill eb\n" +
                "WHERE\n" +
                "  to_number(substr(c.INVOICE_NO, 4)) = to_number('" + refNo7 + "')\n" +
                "  and ech.RECIEPT_NUMBER = c.INVOICE_NO\n" +
                "  and pr.REGISTRATION_NO = eb.CUST_ID\n" +
                "  and ech.BILL_ID = eb.ID\n" +
                "  and ech.RECIEPT_NUMBER = c.INVOICE_NO";

        String query1 = "SELECT PAYMENT_MODE,\n" +
                "       NET_AMOUNT,\n" +
                "       DISCOUNT,\n" +
                "       NVL((select  dr.REASON from DISCOUNT_REASON DR where fb.REASON = DR.REASON_ID), '-'),\n" +
                "       REASON,\n" +
                "       (select b.BANK_NAME Banks from Banks b where b.BANK_ID = fb.BANK_NAME)                         BANK_NAME,\n" +
                "       CHEQUE_NO,\n" +
                "       CHEQUE_AUTH_PERSON,\n" +
                "       CREDIT_CARD_RCPT_NO,\n" +
                "       CREDIT_COMPANY_ID,\n" +
                "       CASHIER_ID,\n" +
                "       decode(PAYMENT_MODE, 'CASH', '1', 'CREDIT CARD', '2', 'CHEQUE', '3', 'CREDIT COMPANY', '4') as Status,\n" +
                "       GROSS_AMOUNT,\n" +
                "       REMARKS\n" +
                "FROM FINAL_PAYMENT_BREAKDOWN fb\n" +
                "WHERE\n" +
                "  to_number(substr(fb.INVOICE_NO, 4)) = to_number('" + refNo7 + "')\n" +
                "order by 1";


        String query2 = "SELECT PAYMENT_MODE,\n" +
                "       (select b.BANK_NAME Banks from Banks b where b.BANK_ID = fb.BANK_NAME)                         BANK_NAME,\n" +
                "       CHEQUE_NO,\n" +
                "       CHEQUE_AUTH_PERSON,\n" +
                "       CREDIT_CARD_RCPT_NO,\n" +
                "       CREDIT_COMPANY_ID,\n" +
                "       decode(PAYMENT_MODE, 'CASH', '1', 'CREDIT CARD', '2', 'CHEQUE', '3', 'CREDIT COMPANY', '4') as Status,\n" +
                "       REMARKS\n" +
                "FROM FINAL_PAYMENT_BREAKDOWN fb\n" +
                "WHERE\n" +
                "  to_number(substr(fb.INVOICE_NO, 4)) = to_number('" + refNo7 + "')\n" +
                "order by 1";

        rs = conn.query(query);
       // out.println(query);
        while (rs.next()) {
            NAME = rs.getString(1);
            // out.println(NAME);
            BHT = rs.getString(5);
            UPIN = rs.getString(3);
            RCPT_NO = rs.getString(2);
            DATE = rs.getString(4);
            TOTAL = rs.getDouble(6);
            NET_AMO = rs.getDouble(7);
            DISCOUNT = rs.getDouble(8);
            CASHIER_ID = rs.getString(9);
            ACC_ID = rs.getString("ACC_ID");
            acc = rs.getString("acc");
            Stat = rs.getString("Stat");

%>
<body onload="openPDF();" style="padding-left:6px;padding-right:6px;font-size:8pt">
<table width="265px" border="0" align="left">
    <%
        String tmp_title = "INWARD PAYMENT RECEIPT-REPRINT";
    %>
    <tr>
        <td>
            <jsp:include page="print_header.jsp">
                <jsp:param name="accID1" value="<%=acc%>"/>
                <jsp:param name="title1" value="<%=tmp_title%>"/>
                <jsp:param name="vat1" value="<%=vat%>"/>
            </jsp:include>
        </td>
    </tr>
    <tr>
        <td>
            <table border="0" width="265px" align="left">
                <tr>
                    <td valign="top" style="white-space: nowrap;">PATIENT</td>
                    <td valign="top"> :</td>
                    <td valign="top"><%=NAME%>
                    </td>

                </tr>
                <tr>
                    <td colspan="3" height="3pt"></td>
                </tr>
                <tr>
                    <td align="left" valign="top">DATE</td>
                    <td align="center" valign="top">:</td>
                    <td align="left" valign="top"><%=DATE%>
                    </td>
                </tr>
                <tr>
                    <td align="left" valign="top">RCPT. NO</td>
                    <td align="center" valign="top">:</td>
                    <td align="left" valign="top"><%=RCPT_NO%>
                    </td>
                </tr>
                <tr>
                    <td align="left" valign="top">UPIN</td>
                    <td align="center" valign="top">:</td>
                    <td align="left" valign="top"><%=UPIN%>
                    </td>
                </tr>
                <tr>
                    <td align="left" valign="top">BHT</td>
                    <td align="center" valign="top">:</td>
                    <td align="left" valign="top"><%=BHT%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>
            <table width="265px">
                <tr>
                    <td><u>#</u></td>
                    <td><u>DESCRIPTION
                    </u>[<%=Stat%>]</td>
                    <td align="right"><u>AMOUNT</u></td>
                </tr>
                <tr>
                    <td colspan="3" height="3pt"></td>
                </tr>
                <% rs1 = conn1.query(query1);
                    String PAYMENT_MODE = "";
                    int count = 0;
                    while (rs1.next()) {
                        count++;
                        PAYMENT_MODE = rs1.getString(1);
                        double charge = 0;
                        if (rs1.getFloat(13) > 0) {
                            charge = rs1.getDouble(13);
                        }%>
                <tr>
                    <td valign="top"><%=count%>.</td>
                    <td valign="top"><%=PAYMENT_MODE%>
                    </td>
                    <td valign="top" align="right"><%=df.format(charge)%>
                    </td>
                </tr>
                <%
                    }

                %>

            </table>
        </td>
    </tr>

    <tr>
        <td>
            <table width="265px">
                <% rs1 = conn1.query(query1);
                    //  out.println(query1);
                    while (rs1.next()) {
                        DISCOUNT = rs1.getDouble(3);
                        DIS_REASON = rs1.getString(4);


                %>
                <%
                    if (DISCOUNT != 0.00) {
                %>
                <td align="right">DISCOUNT (Rs)</td>
                <td>:</td>
                <td align="right">&nbsp;<%=df.format(DISCOUNT)%>
                </td>
                </tr>
                <tr>
                    <td valign="top" colspan="2">[<%=DIS_REASON%>]
                    </td>
                </tr>
                <%}%>

                <%}%>
            </table>
        </td>
    </tr>

    <tr>
        <td>
            <table width="265px" align="right">
                <tr>
                    <td valign="top" colspan="2" align="right">TOTAL
                        AMOUNT(Rs.):&nbsp;
                    </td>
                    <td valign="top" align="right"
                        style="border-top: 1px solid black;"><%=df.format(TOTAL)%>
                    </td>
                </tr>
                <tr>
                <tr>
                    <td colspan="2" height="2pt"></td>
                </tr>
                <tr>
                    <td align="right">NET AMOUNT (Rs)&nbsp;:&nbsp;</td>
                    <td align="right" class="breakup breakdown"><b><%=df.format(NET_AMO)%></b></td>
                </tr>
                <tr>
                    <td align="right"></td>
                    <td align="right" class="breakup" height="3pt">&nbsp;</td>
                </tr>
        </td>
    </tr>

    <tr>
        <td>
            <table width="265px">
                <% rs2 = conn2.query(query2);
                    //  out.println(query2);
                    while (rs2.next()) {
                        cBank = rs2.getString(2);
                        ccRcpNo = rs2.getString(5);
                        cNo = rs2.getString(3);
                        cAuth = rs2.getString(4);
                        REMARKS = rs2.getString(8);
                        PAY_MODE = rs2.getInt(7);

                %>
                <% if (PAY_MODE == 1) {

                %>
                <table>

                    <tr>
                        <td valign="top" colspan="3">PAYMENT MODE : CASH</td>

                    </tr>
                    <tr>
                        <td valign="top" colspan="3">REMARKS: <%=REMARKS%>
                        </td>
                    </tr>
                </table>
                <%
                    }
                %>
                <% if (PAY_MODE == 2) {

                %>

                <table>
                    <tr>
                        <td colspan="3" height="3pt"></td>
                    </tr>
                    <tr>
                        <td valign="top" style="white-space: nowrap;">PAYMENT MODE</td>
                        <td valign="top">:</td>
                        <td valign="top">CREDIT CARD</td>
                    </tr>
                    <tr>
                        <td valign="top" style="white-space: nowrap;">BANK NAME</td>
                        <td valign="top">:</td>
                        <td valign="top"><%=cBank%>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" style="white-space: nowrap;">
                            RCPT. NO
                        </td>
                        <td valign="top">:</td>
                        <td valign="top"><%=ccRcpNo%>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" colspan="3">REMARKS: <%=REMARKS%>
                        </td>
                    </tr>
                </table>
                <%}%>
                <% if (PAY_MODE == 3) {

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
                        <td valign="top"><%=cNo%>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" style="white-space: nowrap;">BANK

                        </td>
                        <td valign="top">:</td>
                        <td valign="top"><%=cBank%>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" style="white-space: nowrap;">AUTH
                            PERSON
                        </td>
                        <td valign="top">:</td>
                        <td valign="top"><%=cAuth%>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" colspan="3">REMARKS: <%=REMARKS%>
                        </td>
                    </tr>
                </table>


                <%}%>

                <tr>
                    <td colspan="3" height="5pt"></td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>

    <tr>
        <td>
            <table width="265px">
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
                            today = rs4.getString(1);%>
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
                </td>
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
                    <td>
                        <jsp:include page="print_footer.jsp"></jsp:include>
                    </td>
                </tr>
                <tr>
                    <td height="10pt"></td>
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
        conn1.flushStmtRs();
        conn2.flushStmtRs();
    } catch (Exception e) {
        conn.flushStmtRs();
        conn1.flushStmtRs();
        conn2.flushStmtRs();
    }


%>