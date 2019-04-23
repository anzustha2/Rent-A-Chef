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
  	User user = (User)session.getAttribute("user");
  	List<Order> orders=DBAccess.JAK_SP_GetOrders(user.userId, "ALL");
  		%>
  		  <jsp:include page="/WEB-INF/templates/navBar.jsp" />
  		<div class="table-responsive">
        
        <%if (orders==null || orders.size()==0) {%>
        	<h4>You do not have any orders.</h4>
        	<%if (user.userTypeCode.equals("USR")) {%>
        		<a class="btn btn-primary" role="button" href="StartOrder.jsp">Click here to start order.</a>
     		<%} %>
     		<%if (user.userTypeCode.equals("CHEF")) {%>
        		<a class="btn btn-primary" role="button" href="PickOrder.jsp">Click here pick the order.</a>
     		<%} %>
        <%} else{ %>
   
        <div>
        	<table class="table">
        	<tbody>
        	<thead>
	        	<th>My order items</th>
	        	<th></th>
	        	<th></th>
	        	<th></th>
        	</thead>
        	
        	 <%
        	 	int i=0;
        	 	for(Order order:orders){ 
        	 		i++;
        	 		Address address=DBAccess.JAK_SP_GetAddress(order.scheduledAddressId);
        	 		%>
        	 		<tr>
        	 		<th>Order#<%=order.orderId +"  "%></th>
        	 		<th>Order Status: <%=order.orderStatusDescription%><%=((order.orderStatusCode.equals("PU")||order.orderStatusCode.equals("COMP")) && user.userTypeCode.equals("USR"))?" ( ChefId: "+order.chefId+")":"" %></th>
        	 		<th>EstimatedCost: $<%=order.estCostWithoutTax+order.estTax %></th>
        	 		<td rowSpan="2">
        	 			<% if(order.orderStatusCode.equals("OP")||order.orderStatusCode.equals("PU")){
        	 				%>
        	 				<form ACTION="cancelOrder.do" METHOD="POST"> 
        	
					        	<input type="hidden" id="orderId" name="orderId"value="<%=order.orderId%>"/>
					        	
					       			<input type="submit" onClick="" value="Cancel Order" class="btn btn-danger">
					       		</form>
					       		
					       		
        	 				<%
        	 				if(user.userTypeCode.equals("CHEF")&&order.orderStatusCode.equals("PU")){
        	 					%>
        	 					<form ACTION="completeOrder.do" METHOD="POST"> 
        	
					        	<input type="hidden" id="orderId" name="orderId"value="<%=order.orderId%>"/>
					        
					       			<input type="submit" onClick="" value="Complete Order" class="btn btn-primary">
					       		</form>
        	 					<%
        	 				}
        	 			}
        	 			
        	 			%>
        	 		</td></tr>
        	 		
        	 		<tr><td colSpan="3">Schedule:<%=address.address1+" "+address.city+", "+address.state+"-"+address.zip +" ("+order.scheduledDateTime+")"%></td></tr>
        	 		<%
        		 	List<OrderItem> orderItems = DBAccess.JAK_SP_GetOrderItems(order.orderId);
        		 	int j=0;
        		 	for( OrderItem item:orderItems){
        		 		Dish d = DBAccess.JAK_SP_GetDish(item.dishId);
        		 		j++;
        		%>
        		
        		<tr >
        			<td>&nbsp;<%=j %>&nbsp;</td>
        			<td >&nbsp;<%=d.name +" ("+ d.baseUnits + " "+d.unitDescription +")"%>&nbsp;</td>  
        			<td>&nbsp;<%="  $"+d.estCost %>&nbsp;</td>
     
        					
        		</tr>
        		<%}
        		 	%><tr><td colSpan="3"></td></tr><%
        	 } %>
        	 </tbody>
        	 </table>
        </div>
 
    <%} %>
  		