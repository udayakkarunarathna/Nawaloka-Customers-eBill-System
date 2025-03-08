<%
String title_h = "";
if (request.getParameter("title_h") != null) {
	title_h = request.getParameter("title_h");
}
String ACC_ID_h = "NAWALOKA HOSPITALS PLC";
if (request.getParameter("ACC_ID_h") != null) {
	ACC_ID_h = request.getParameter("ACC_ID_h");
}
%><div class="text-center"
    style="background: url('images/ebill_header.jpg') no-repeat center center; background-size: cover; padding-top: 20%; position: relative;">
</div>
<div style="display: flex; justify-content: space-between; font-size: 9pt; margin-top: 0pt;">
    <div><%=title_h%></div>
    <div>42/FO/OP/01</div>
</div>