<%@ page import="com.model.db.DatabaseConnection" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<%@ include file="noCache.jsp" %>
<html>
<head>
    <link rel="stylesheet" href="pop_style.css"/>
    <link rel="stylesheet" type="text/css" href="jax/ext-all.css"/>
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
        String refNo7 = request.getParameter("refNo7");
        refNo7 = refNo7.trim();
//        int stringlength = refNo7.length();
//        String a = "";
//        for (int i = 1; i <= 10 - stringlength; i++) {
//            a = a + "0";
//        }
//        refNo7 = "CH" + a + refNo7;
//        out.println(refNo7);
        if (usertype.equals("Admin") || usertype.equals("User")) {
            if (refNo7.equals("") || refNo7 == null) {
                // set error message
                request.setAttribute("ErrorMessage", "<center>  Please Enter OPD Reference Number </center>");
                request.setAttribute("ErrorType", "ERROR");
                // call the error screen (ErrorScreen.jsp)

                dispatcher = getServletContext().getRequestDispatcher("/ErrorScreen.jsp");
                dispatcher.include(request, response);
            } else {

                DatabaseConnection conn = new DatabaseConnection();
                DatabaseConnection conn1 = new DatabaseConnection();
                conn.connectToDB();
                conn1.connectToDB();
                String NAME = "", DOB = "", BHT = "", YY = "", MM = "", cBank = "", ccRcpNo = "", cNo = "", cAuth = "", UPIN = "", DATE = "", RCPT_NO = "", REF_NO = "",
                        DESCRIPTION = "", REMARKS = "", CASHIER_ID = "", DIS_REASON = "", ONLINE_INVO = "", mode = "";
                String ACC_ID = "", acc = "";

                int PAY_MODE = 0;

                double TOTAL = 0, NET_AMO = 0, DISCOUNT = 0, total = 0, vat = 0;
                ResultSet rs = null;
                ResultSet rs1 = null;

                try {
                    String query = "SELECT pr.TITLE || ' ' || nvl(pr.INITIALS, '') || ' ' || nvl(pr.SURNAME, ''),\n" +
                            "       c.INVOICE_NO,\n" +
                            "       NVL((select distinct HV.PIN_NO from HOSPITAL_VISIT HV where HV.REGISTRATION_NO = PR.REGISTRATION_NO), '-'),\n" +
                            "       to_char(c.TXN_DATE, 'dd/mm/yyyy hh:mi PM') as TXN_DATE,\n" +
                            "       ech.BHT_NO,\n" +
                            "       c.GROSS_AMOUNT,\n" +
                            "       C.NETAMOUNT,\n" +
                            "       C.DISCOUNT,\n" +
                            "       C.CASHIER_ID\n" +
                            "FROM CASHIER_COLLECTION c,\n" +
                            "     ECHPAYMENTS ech,\n" +
                            "     PATIENT_REGISTRATION pr,\n" +
                            "     echbill eb\n" +

                            "WHERE\n" +
                            "  to_number(substr(c.INVOICE_NO, 4)) = to_number('" + refNo7 + "')\n" +
                            "  and ech.RECIEPT_NUMBER = c.INVOICE_NO\n" +
                            "  and pr.REGISTRATION_NO = eb.CUST_ID\n" +
                            "  and ech.BILL_ID = eb.ID\n" +
                            "  and C.STATUS =1\n" +
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

                    rs = conn.query(query);

                    int countR = 0;
                    if (uid.equals("SAMADHI")) {
                        out.println(query);
                    }
                    while (rs.next()) {
                        countR++;
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


%>

<body topmargin="0" leftmargin="0" class="optionsTop">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td height="30" align="left" background="/eHospitalOPDOffice/images/titleMiddle.gif" class="titles"><img
                src="/eHospitalOPDOffice/images/titleCorner.gif" width="30" height="30" border="0"></td>
        <td valign="middle" background="/eHospitalOPDOffice/images/titleMiddle.gif" class="titles"><p
                style="margin-right:10">
            Search Theater Payment Number</p></td>
    </tr>
    <tr>
        <td width="30">&nbsp;</td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td width="30">&nbsp;</td>
        <td>

            <table width="700" border="0" cellpadding="0" cellspacing="0" class="bodyTable">

                <tr>
                    <td colspan="4">&nbsp;</td>
                </tr>

                <form action="Ref_Search_DetailsReprints_FinalpayPrint.jsp" name="f1" method="post">
                    <input type="text" value="<%=refNo7%>" style="visibility: hidden" name="refNo7">
                    <tr>
                        <td width="212" height="25" class="rowgrey"><p style="margin-left: 10px">NAME</p></td>

                        <td height="25" colspan="4" class="rowgrey"><b><%=NAME%>
                        </b></td>
                    </tr>
                    <tr>
                        <td width="212" height="25" class="rowgrey"><p style="margin-left: 10px">DATE</p></td>

                        <td height="25" colspan="4" class="rowgrey"><b><%=DATE%>
                        </b></td>
                    </tr>
                    <tr>
                        <td width="212" height="25" class="rowgrey"><p style="margin-left: 10px">RCPT NO</p></td>

                        <td height="25" colspan="4" class="rowgrey"><b><%=RCPT_NO%>
                        </b></td>
                    </tr>

                    <tr>
                        <td width="212" height="25" class="rowgrey"><p style="margin-left: 10px">UPIN</p></td>

                        <td height="25" colspan="4" class="rowgrey"><b><%=UPIN%>
                        </b></td>
                    </tr>
                    <tr>
                        <td width="212" height="25" class="rowgrey"><p style="margin-left: 10px">BHT</p></td>

                        <td height="25" colspan="4" class="rowgrey"><b><%=BHT%>
                        </b></td>
                    </tr>
                    <tr>
                        <td colspan="2" class="rowTop">&nbsp;</td>
                    </tr>
                    <tr>
                        <td width="305" height="25" class="rowgrey"><p style="margin-left: 10px;"><b>#</b>
                        </p></td>
                        <td width="305" height="25" class="rowgrey"><p style="margin-left: 10px;"><b>DESCRIPTION</b>
                        </p></td>

                        <td width="400" height="25" class="rowgrey"><p style="margin-left: 10px;"><b>AMOUNT</b></p>
                        </td>


                    </tr>
                    <tr>
                        <td colspan="2" height="4pt"></td>
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
                        <td valign="top" valign="top"><%=count%>.</td>
                        <td valign="top" valign="top"><%=PAYMENT_MODE%>
                        </td>

                        <td valign="top" valign="top"><%=df.format(charge)%>
                        </td>
                    </tr>

                    <%}%>
                    <tr>
                        <td width="212" height="25" class="rowgrey"><p style="margin-right: 10px">DISCOUNT
                            (Rs.)</p></td>

                        <td height="25" colspan="4" class="rowgrey"><b><%=df.format(DISCOUNT)%>
                        </b></td>
                    </tr>
                    <tr>
                        <td width="212" height="25" class="rowgrey"><p style="margin-right: 10px">GROSS AMOUNT</p></td>

                        <td height="25" colspan="4" class="rowgrey"><b><%=df.format(TOTAL)%>
                        </b></td>
                    </tr>

                    <tr>
                        <td width="212" height="25" class="rowgrey"><p style="margin-right: 10px">NET AMOUNT</p></td>

                        <td height="25" colspan="4" class="rowgrey"><b><%=df.format(NET_AMO)%>
                        </b></td>
                    </tr>
                    <tr>
                        <td width="212" height="25" class="rowgrey"><p style="margin-left: 10px">USER</p></td>

                        <td height="25" colspan="4" class="rowgrey"><b><%=CASHIER_ID%>
                        </b></td>

                    </tr>
                    <tr align="right">

                        <td height="25" align="center" valign="middle" colspan="6" class="rowgrey">
                            <input name="Submit" type="submit" class="submitbut"

                                   value="Print">
                        </td>
                    </tr>

                </form>
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
                    conn1.flushStmtRs();
                } catch (Exception e) {
                    conn.flushStmtRs();
                    conn1.flushStmtRs();
                }
            }

        }

    }


%>