<%
	String accID1 = "", title1 = "", vat1 = "", iso = "42/FO/OP/01";
	if (request.getParameter("accID1") != null) {
		accID1 = request.getParameter("accID1");
	}
	if (request.getParameter("title1") != null) {
		title1 = request.getParameter("title1");
	}
	if (request.getParameter("vat1") != null) {
		vat1 = request.getParameter("vat1");
	}
	if (request.getParameter("iso") != null) {
		iso = request.getParameter("iso");
	}
	//out.println("|" + vat1 + "|");
%>
<div align="right" style="font-size: 10pt"><%=iso%></div>
<%
		String center = "";
		String tel = "";
		String fax = "";
	if (accID1.equalsIgnoreCase("A003")) {
		center = (String) session.getAttribute("nnmcname");
		tel = (String) session.getAttribute("nnmctel");
		fax = (String) session.getAttribute("nnmcfax");
	} else if (accID1.equalsIgnoreCase("A002")) {
		center = (String) session.getAttribute("newnawaname");
		tel = (String) session.getAttribute("newnawatel");
		fax = (String) session.getAttribute("newnawafax");
	} else {
		center = (String) session.getAttribute("nawaname");
		tel = (String) session.getAttribute("nawatel");
		fax = (String) session.getAttribute("nawafax");
	}
	tel = tel.replace("TELEPHONE: 0115577111 , 2304444","TEL: +94 115577111,2304444");
	fax = fax.replace("94 - 011 - 2430393","+94 112430393").replace("-","");
%>


<%
String unit_id = (String) session.getAttribute("unitID");

if(unit_id.equals("U02369")){ %>
<div align="center">
	<img src="images/ELITE.jpg" width="265px" height="90px">
</div>
<div align="center" style="width: 265px; font-size: 10pt">
	<%=center%><br /><%=tel%><br /><%=fax%></div>
<%}else{ %>		
<table align="center" width="100%" border="0"
	style="">
	<tr style="">
		<td rowspan="4" valign="middle"><img
			src="images/nawaloka-logo.png" style="height: 30pt"></td>
	</tr>
	
	<tr>
		<td align="center" style="font-size: 10pt"><%=center%></td>
	</tr>
	<tr>
		<td align="center" style="font-size: 9pt"><%=tel%></td>
	</tr>
	<tr>
		<td align="center" style="font-size: 9pt"><%=fax%></td>
	</tr>
</table>
<%} %>


<div align="center" style="margin-top: 5px">
	<u><%=title1%></u>
</div>

<%
	if (!vat1.equals("0") && !vat1.equals("0.0")) {
%>
<div align="right">VAT NO - 1040876047000</div>
<%
	}
%>