<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ page import="java.util.*" %>  
    
<%@ page import="utility.Helper" %>
<%
	Helper.initializeSessionDataForValidation(request);
%>
<!DOCTYPE html>
<html>
	<head>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/CSS/style.css" />
	<script src="${pageContext.request.contextPath}/JavaScript/main.js"></script>
	<body>
		 <div id="mainPage" class="mainPage">
	 		<jsp:include page="/WEB-INF/pages/${content}.jsp" />
	 		<jsp:include page="/WEB-INF/pages/responses.jsp" />
		</div>
	</body>
</html>