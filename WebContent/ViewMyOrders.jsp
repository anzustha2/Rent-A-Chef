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
  		 
  		<div class="table-responsive">
        
        <%if (orders==null || orders.size()==0) {%>
        	<h4>You do not have any orders.</h4>
        	
        	<a class="btn btn-primary" role="button" href="StartOrder.jsp">Click here to start order.</a>
     
        <%} else{ %>
   
        <div>
        	 <strong>My order items:</strong>
        	<table>
        	<tbody>
        	<thead>
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
        	 		<tr><td>Order#<%=i +"  "%></td><td>Order Status: <%=order.orderStatusDescription %></td><td>
        	 			<% if(order.orderStatusCode.equals("OP")||order.orderStatusCode.equals("PU")){
        	 				%>
        	 				<form ACTION="cancelOrder.do" METHOD="POST"> 
        	
					        	<input type="hidden" id="orderId" name="orderId"value="<%=order.orderId%>"/>
					        	
					       			<input type="submit" onClick="" value="Cancel Order" class="cancel">
					       		</form>
        	 				<%
        	 			}
        	 			
        	 			%>
        	 		</td></tr>
        	 		<tr><td colSpan="3">Scheduled Date and Time: <%=order.scheduledDateTime %></td></tr>
        	 		<tr><td colSpan="3">EstimatedCost: $<%=order.estCostWithoutTax+order.estTax %></td></tr>
        	 		<tr><td colSpan="3">Address:<%=address.address1+" "+address.city+", "+address.state+"-"+address.zip %></td>
        	 		<%
        		 	List<OrderItem> orderItems = DBAccess.JAK_SP_GetOrderItems(order.orderId);
        		 	int j=0;
        		 	for( OrderItem item:orderItems){
        		 		Dish d = DBAccess.JAK_SP_GetDish(item.dishId);
        		 		j++;
        		%>
        		
        		<tr >
        			<td>&nbsp;<%=j %>&nbsp;</td>
        			<td>&nbsp;<%=d.name +" ("+ d.baseUnits + " "+d.unitDescription +")"%>&nbsp;</td>  
        			<td>&nbsp;<%="  $"+d.estCost %>&nbsp;</td>
        					
        		</tr>
        		<%}
        		 	%><tr><td colSpan="3"></td></tr><%
        	 } %>
        	 </tbody>
        	 </table>
        </div>
 
    <%} %>
  		