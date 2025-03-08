<head>
<script type="text/javascript" src="qr/qrcode.js"></script>
<script>
	var qrcode = new QRCode("qrcode");
	function makeCode() {
		var elText = document.getElementById("text");
		if (!elText.value) {
			alert("Input a text");
			elText.focus();
			return;
		}
		qrcode.makeCode(elText.value);
	}
</script>
</head>
<%
String ref_no = "<h1 color='red'>This is not a valid report...</h1>";
if (request.getParameter("ref_no") != null) {
	ref_no = request.getParameter("ref_no");
}
String this_page = "";
if (request.getParameter("this_page") != null) {
	this_page = request.getParameter("this_page");
}
%>
<input id="text" type="hidden"
	value="https://nawalokaepay.lk/ebill/<%=this_page%>.jsp?p=<%=ref_no%>" />
<table border="0" align="right" style="margin-bottom: 0px">
	<tr>
		<td align="center"><div id="qrcode" align="center"
				style="margin-top: 0px"></div></td>
	</tr>
	<tr>
		<td valign="middle" align="center"><font size="1px">Scan
				to validate</font></td>
	</tr>
</table>
<script type="text/javascript">
	var qrcode = new QRCode(document.getElementById("qrcode"), {
		width : 80,
		height : 80
	});

	function makeCode() {
		var elText = document.getElementById("text");

		if (!elText.value) {
			alert("Input a text");
			elText.focus();
			return;
		}

		qrcode.makeCode(elText.value);
	}

	makeCode();

	$("#text").on("blur", function() {
		makeCode();
	}).on("keydown", function(e) {
		if (e.keyCode == 13) {
			makeCode();
		}
	});
</script>
