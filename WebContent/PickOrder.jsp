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
  	List<Order> orders=DBAccess.JAK_SP_GetOrders(0, "OP");
  		%>
  		  <jsp:include page="/WEB-INF/templates/navBar.jsp" />
  		<div class="table-responsive">
        
        <%if (orders==null || orders.size()==0) {%>
        	<h4>Sorry we do not have any orders at the moment</h4>
        	
    
        <%} else{ %>
   
        <div>
        	<table class="table">
        	<tbody>
        	<thead>
	        	<th>Available Orders to pick</th>
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
        	 		<th>Order Status: <%=order.orderStatusDescription %></th>
        	 		<th>EstimatedCost: $<%=order.estCostWithoutTax+order.estTax %></th>
        	 		
        	 		<td rowSpan="2">
        	 			<% if(order.orderStatusCode.equals("OP")||order.orderStatusCode.equals("PU")){
        	 				%>
        	 				<form ACTION="pickOrder.do" METHOD="POST"> 
        	
					        	<input type="hidden" id="orderId" name="orderId"value="<%=order.orderId%>"/>
					        	
					       			<input type="submit" onClick="" value="Pick Order" class="btn btn-primary">
					       		</form>
        	 				<%
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
  		