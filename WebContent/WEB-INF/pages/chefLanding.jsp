<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>


<!DOCTYPE html>

<jsp:include page="/WEB-INF/templates/chef-navbar.jsp" />

<html>
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
    <div class="jumbotron">
        <h1>View My Order Requests</h1>
        <p>Click here to view your pending order requests that are waiting for your response</p>
        <p><a class="btn btn-primary" role="button" href="orderRequests.jsp">See Orders</a></p>
    </div>
    <div class="jumbotron">
        <h1>View My Schedule</h1>
        <p>Click here to view your schedule of accepted orders</p>
        <p><a class="btn btn-primary" role="button" href="mySchedule.html">See Schedule</a></p>
    </div>
    <script src="assets/js/jquery.min.js"></script>
    <script src="assets/bootstrap/js/bootstrap.min.js"></script>
</body>

</html>