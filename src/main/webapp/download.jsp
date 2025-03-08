
<%
String pp = ""; 	
if (request.getParameter("p") != null) {
	pp = request.getParameter("p");
}
%>
<div align="center" style="margin-top: 20px; margin-bottom: 40px">
	<button type="button" class="btn btn-secondary btn-lg btn-block"
		onclick="downloadBill('<%=pp%>')">Download</button>
</div>