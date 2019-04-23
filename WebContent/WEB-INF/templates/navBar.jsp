<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
 <%@ page import="java.util.*" %>
 <%@ page import="model.Order" %>
 <%@ page import="model.User" %>
 <%@ page import="database.DBAccess" %>
  <%@ page import="model.Order" %>
   <%@ page import="model.OrderItem" %>
    <%@ page import="model.Dish" %>
     <%@ page import="model.Address" %>
 <%@ page import="utility.Helper" %>
 <%!List<Dish> dishes=new ArrayList<Dish>();%>
  <% 
  	User user = (User)session.getAttribute("user");%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rent_A_Chef</title>
    <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/fonts/font-awesome.min.css">
    <link rel="stylesheet" href="assets/fonts/ionicons.min.css">
    <link rel="stylesheet" href="assets/css/Features-Blue.css">
    <link rel="stylesheet" href="assets/css/Footer-Basic.css">
    <link rel="stylesheet" href="assets/css/Login-Form-Clean.css">
    <link rel="stylesheet" href="assets/css/Navigation-with-Button.css">
    <link rel="stylesheet" href="assets/css/Registration-Form-with-Photo.css">
    <link rel="stylesheet" href="assets/css/styles1.css">
</head>
<body>
<nav class="navbar navbar-light navbar-expand-md navigation-clean-button">
        <div class="container">
        <a class="navbar-brand" href="#">Rent - A - Chef</a>
        
        <button class="navbar-toggler" data-toggle="collapse" data-target="#navcol-1"><span class="sr-only">Toggle navigation</span><span class="navbar-toggler-icon"></span></button>
            <div
                class="collapse navbar-collapse" id="navcol-1">
                <ul class="nav navbar-nav mr-auto">
                	<%if(user.userTypeCode.equals("USR")){ %>
                    <li class="nav-item" role="presentation"><a class="nav-link" href="StartOrder.jsp">Start Order</a></li>
                    <%} %>
                    <%if(user.userTypeCode.equals("CHEF")){ %>
                    <li class="nav-item" role="presentation"><a class="nav-link" href="PickOrder.jsp">Pick Order</a></li>
                    <%} %>
                    <li class="nav-item" role="presentation"><a class="nav-link" href="ViewMyOrders.jsp">My Orders</a></li>
                    <li class="nav-item navbar-text actions" role="presentation">&nbsp;&nbsp;&nbsp;
                    	Logged In User:&nbsp;<strong><%=user.firstName+" "+user.lastName %></strong>
                    </li>
                   
                </ul><span class="navbar-text actions"> <a class="btn btn-light action-button" role="button" href="index2.jsp">Logout</a></span></div>
        </div>
    </nav>
</body>
</html>