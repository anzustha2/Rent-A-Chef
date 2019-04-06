<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ page import="java.util.*" %>  
    
<%@ page import="utility.Helper" %>
<%!ArrayList<String> responses=new ArrayList<String>(); %>
<%
		
	if(session.getAttribute("responses")!=null){
		responses = (ArrayList)session.getAttribute("responses");
	}
	if(responses!=null && responses.size()>0){
		for(String r:responses){
			%>
			<p><%=r %></p>
			<%
		}		
	}
	Helper.resetDataValidation(request);
%>