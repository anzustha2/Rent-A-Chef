<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
</head>
<body>
<nav class="navbar navbar-light navbar-expand-md navigation-clean-button">
        <div class="container"><a class="navbar-brand" href="chefLanding.jsp">Rent - A - Chef</a><button class="navbar-toggler" data-toggle="collapse" data-target="#navcol-1"><span class="sr-only">Toggle navigation</span><span class="navbar-toggler-icon"></span></button>
            <div
                class="collapse navbar-collapse" id="navcol-1">
                <ul class="nav navbar-nav mr-auto">
                    <li class="nav-item" role="presentation"><a class="nav-link" href="orderRequests.jsp">Order Requests</a></li>
                    <li class="nav-item" role="presentation"><a class="nav-link" href="mySchedule.jsp">My Schedule</a></li>
                    <li class="dropdown"><a class="dropdown-toggle nav-link dropdown-toggle" data-toggle="dropdown" aria-expanded="false" href="#">Account</a>
                        <div class="dropdown-menu" role="menu"><a class="dropdown-item" role="presentation" href="chefOrderHistory.jsp">Order History</a><a class="dropdown-item" role="presentation" href="profile.jsp">Profile</a><a class="dropdown-item" role="presentation" href="paymentOptions.jsp">Payment Options</a></div>
                    </li>
                </ul><span class="navbar-text actions"> <a class="btn btn-light action-button" role="button" href="login.jsp">Logout</a></span></div>
        </div>
    </nav>
</body>
</html>