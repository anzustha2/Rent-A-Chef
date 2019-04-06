<%@ page import="java.util.*" %>  
<%@ page import="utility.Helper" %>
   <form class="login" ACTION="processLogin.do" METHOD="POST">  
       	<input type="text" name="userName" id="userName" class="adjustInputFieldCSForm <%=Helper.validate("userName") %>" placeholder="UserName" value="<%=Helper.getStoredString("userName") %>" >
	    <input type="password" name="password" id="password" class="adjustInputFieldCSForm <%=Helper.validate("password") %>" placeholder="Password" value="<%=Helper.getStoredString("password") %>">
  		<input type="submit" onClick="" value="Login" class="login">  
   </form>