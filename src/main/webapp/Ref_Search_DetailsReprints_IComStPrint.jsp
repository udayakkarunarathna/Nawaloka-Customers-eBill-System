<!-- create by Udaya
Date : 07/06/2023
 -->

<%@ page import="com.model.db.DatabaseConnection" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.*" %>
<%@ include file="noCache.jsp" %>
<html>
<head>
    <link rel="stylesheet" href="pop_style.css"/>
    <meta name="GENERATOR" content="Microsoft FrontPage 5.0">
    <meta name="ProgId" content="FrontPage.Editor.Document">
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <link href="/eHospitalLab/eHosLabStyles.css" rel="stylesheet" type="text/css">

    <base target="main">


    <%--    mk Thermal printout--%>
    <script type="text/javascript">
        function openPDF() {
            this.window.focus();
            this.window.print();
            location.href='home.jsp'
        }
    </script>
    <style>
       /*  * {

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
    RequestDispatcher dispatcher;
    HttpSession sessions = request.getSession(false);
    DecimalFormat df = new DecimalFormat();
    df.setMaximumFractionDigits(2);
    df.setMinimumFractionDigits(2);


    String usertype = (String) sessions.getValue("usertype");
    String uid1 = (String) sessions.getValue("uid");
    String uid = uid1.toUpperCase();
    String refNo9 = request.getParameter("refNo9");
    refNo9 = refNo9.trim();

    if (usertype.equals("Admin") || usertype.equals("User")) {
        if (refNo9.equals("") || refNo9 == null) {
            // set error message
            request.setAttribute("ErrorMessage", "<center>  Please Enter OPD Reference Number </center>");
            request.setAttribute("ErrorType", "ERROR");
            // call the error screen (ErrorScreen.jsp)

            dispatcher = getServletContext().getRequestDispatcher("/ErrorScreen.jsp");
            dispatcher.include(request, response);
        } else {

            DatabaseConnection conn = new DatabaseConnection();

            conn.connectToDB();

            String NAME = "", DOB = "", PAYMENT_TYPE = "", BHT = "", YY = "", MM = "", cBank = "", ccRcpNo = "", cNo = "", cAuth = "", UPIN = "", DATE = "", RCPT_NO = "", REF_NO = "",
                    DESCRIPTION = "", REMARKS = "", CASHIER_ID = "", DIS_REASON = "", company = "", mode = "";
            String ACC_ID = "", acc = "";

            int PAY_MODE = 0;

            double TOTAL = 0, AMOUNT = 0, DISCOUNT = 0, total = 0, vat = 0;
            ResultSet rs = null;


            try {
                String query = "select pr.TITLE || ' ' || nvl(pr.INITIALS, '') || ' ' || nvl(pr.SURNAME, ''),\n" +
                        "       eb.BHT_NO,\n" +
                        "       NVL((select distinct HV.PIN_NO from HOSPITAL_VISIT HV where HV.REGISTRATION_NO = PR.REGISTRATION_NO), '-'),\n" +
                        "       CC.INVOICE_NO,\n" +
                        "       cc.TXN_TYPE,\n" +
                        "       to_char(cc.TXN_DATE, 'dd/mm/yyyy hh:mi PM')                                                  as TXN_DATE,\n" +
                        "       cc.AMOUNT,\n" +
                        "       cc.DISCOUNT,\n" +
                        "     cc.USER_ID,\n" +
                        "       cc.PAYMENT_MODE,\n" +
                        "       NVL(cc.CREDIT_CARD_RCPT_NO, '-')                                                             as CREDIT_CARD_RCPT_NO,\n" +
                        "       cc.CHEQUE_NO,\n" +
                        "       NVL((SELECT b.BANK_NAME FROM BANKS b WHERE b.BANK_ID = CC.BANK_NAME), '-'),\n" +
                        "       cc.CHEQUE_AUTH_PERSON,\n" +
                        "       NVL(ep.ONLINE_PAYMENT_INVOICE, '-')                                                          as ONLINE_PAYMENT_INVOICE,\n" +
                        "C.NAME,\n" +
                        "       NVL(cc.REMARKS, '-')                                                                         as REMARKS,\n" +
                        "       DECODE(CC.ACC_ID, 'A001', 'NAWALOKA', 'A002', 'NEW NAWALOKA', 'NEW NAWALOKA MEDICAL CENTER') as ACC_ID,\n" +
                        "       CC.ACC_ID                                                                                    as acc,\n" +
                        "       DECODE(ep.PAYMENT_TYPE, 1, 'INITIAL', 2, 'FURTHER', 3, 'FINAL')                              as Status\n" +
                        "from CASHIER_CREDIT_COLLECTION cc,\n" +
                        "     echpayments ep,\n" +
                        "     PATIENT_REGISTRATION pr,\n" +
                        "     echbill eb,\n" +
                        "     credit_companies c\n" +
                        "WHERE to_number(substr(cc.INVOICE_NO, 4)) = to_number('" + refNo9 + "')\n" +
                        "  AND PR.REGISTRATION_NO = EB.CUST_ID\n" +
                        "  AND EP.BILL_ID = EB.ID\n" +
                        "  and CC.STATUS = 1\n" +
                        "  and cc.AGENT_NO = c.ID\n" +
                        "  and ep.RECIEPT_NUMBER = cc.INVOICE_NO";

                rs = conn.query(query);
                // out.println(query);
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

                    AMOUNT = rs.getDouble(7);

                    CASHIER_ID = rs.getString(9);
                    cBank = rs.getString(13);
                    ccRcpNo = rs.getString(11);
                    cNo = rs.getString(12);
                    cAuth = rs.getString(14);
                    ACC_ID = rs.getString("ACC_ID");
                    acc = rs.getString("acc");
                    PAY_MODE = rs.getInt(10);
                    company = rs.getString(16);
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
<body style="padding-left:6px;padding-right:6px;font-size:8pt"
      onLoad="openPDF()">
<table width="265px" border="1" align="left">
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
            <table border="1" width="265px" align="left">
                <tr>
                    <td valign="top" style="white-space: nowrap;">DATE & TIME</td>
                    <td valign="top"> :</td>
                    <td valign="top"><%=DATE%>
                    </td>
                </tr>

                <tr>
                    <td valign="top" style="white-space: nowrap;">RECEPT NO</td>
                    <td valign="top"> :</td>
                    <td valign="top"><%=RCPT_NO%>
                    </td>
                </tr>
                <tr>
                    <td valign="top" style="white-space: nowrap;">UPIN</td>
                    <td valign="top"> :</td>
                    <td valign="top"><%=UPIN%>
                    </td>
                </tr>
                <tr>
                    <td valign="top" style="white-space: nowrap;">BHT</td>
                    <td valign="top"> :</td>
                    <td valign="top"><%=BHT%>
                    </td>

                </tr>
                <tr>
                    <td valign="top" style="white-space: nowrap;">PATIENT</td>
                    <td valign="top"> :</td>
                    <td valign="top"><%=NAME%>
                    </td>

                </tr>
                <tr>
                    <td valign="top" style="white-space: nowrap;">COMPANY</td>
                    <td valign="top"> :</td>
                    <td valign="top"><%=company%>
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
                    <td><u>DESCRIPTION</u></td>
                    <td align="right"><u>AMOUNT</u></td>
                </tr>
                <tr>
                    <td colspan="3" height="1pt"></td>
                </tr>
                <tr>
                    <td valign="top">1.</td>
                    <td valign="top">AMOUNT TENDERED</td>
                    <td align="right" valign="top"><%=df.format(AMOUNT)%>
                    </td>
                </tr>
                <tr>
                    <td colspan="3" height="1pt"></td>
                </tr>
                <tr>
                    <td valign="top"></td>
                    <td align="right" valign="top">TOTAL AMOUNT
                        (Rs.)&nbsp;:&nbsp;
                    </td>
                    <td align="right" valign="top"
                        style="border-top: 1px solid black; border-bottom: 1px solid black; font-weight: bold; white-space: nowrap;"><%=df.format(AMOUNT)%>
                    </td>
                </tr>
                <tr>
                    <td valign="top"></td>
                    <td valign="top"></td>
                    <td align="right" valign="top"
                        style="border-top: 1px solid black;">&nbsp;
                    </td>
                </tr>
            </table>

    <tr>
        <td>
            <table align="right">
                <%
                    if (PAY_MODE == 3) {
                %>
                <tr>
                    <td colspan="2">
                        <table width="265px" align="right">
                            <tr>
                                <td valign="top">PAY MODE&nbsp;   :&nbsp; <%="CHEQUE"%>
                                </td>

                            </tr>
                            <tr>
                                <td valign="top">CHEQUE NO&nbsp;  :&nbsp;<%=cNo%>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top">BANK NAME&nbsp;  :&nbsp;<%=cBank%>
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
                                            <td valign="top">PAY
                                                MODE&nbsp;:&nbsp;<%="CREDIT CARD"%>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td valign="top">BANK NAME&nbsp;            :&nbsp;<%=cBank%>
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
                                            }
                                        %>


                                    </table>
                                </td>
                            </tr>
                            <%
                                if (PAY_MODE == 1) {
                            %>
                            <tr>
                                <td colspan="2">
                                    <table border="0">
                                        <tr>
                                            <td valign="top">PAY
                                                MODE&nbsp;:&nbsp;<%="CASH"%>
                                            </td>
                                            <%}%>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>

                    </td>
                </tr>

            </table>

    </td>
    </tr>
    <tr>
        <td>
            <table width="265px" >
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
                    <td valign="top" align="left" style="">ISSUED USER   : <%=CASHIER_ID%>
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


%>