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
  	Address address = DBAccess.JAK_SP_GetUserAddress(user.userId).get(0);
  	session.setAttribute("addressId", address.addressId);
    Order order=null;
  	if(session.getAttribute("order")!=null){
  		order =(Order)session.getAttribute("order");
  	}
  	dishes=DBAccess.JAK_SP_GetDishes("ALL");
  	
  		%>
  		 <jsp:include page="/WEB-INF/templates/navBar.jsp" />
  		<div class="table-responsive">
        <table class="table">
            <thead>
                <tr>
                    <th colSpan="3">Available Dishes</th>
                </tr>
            </thead>
            <tbody>
            <%for(Dish d: dishes){ %>
            <tr style="background-color: #f2f2f2;"><td>
                <tr>
                    <td colSpan="2"><%=d.name +" ("+ d.baseUnits + " "+d.unitDescription +") $" +d.estCost%></td>
                    <td rowSpan="2">
	                	<form ACTION="addOrderItem.do" METHOD="POST"> 
	                    	<input type="hidden" name="dishId" id="dishId" value="<%=d.dishId%>"/>
	                    	<input type="submit" onClick="" value="Pick" class="btn btn-primary">
	                    </form>
                	</td>
                </tr>
                <tr>
                    <td colSpan="2">
                    	<p style="font-size:10px;">
                    	<strong>Description:</strong><%=" "+d.description+" "%>
                    	<strong>Ingredients:</strong><%=" "+d.writeIngredients() %>  
                    	</p>
                    </td>    
                </tr>
         
              <%} %>
            </tbody>
        </table>
        <% if (order!=null){ %>
        <div>
        	<h4> Order estimated cost without tax: $<%=order.estCostWithoutTax %></h3>
        	<form ACTION="submitOrder.do" METHOD="POST"> 
        	
        	<label for="scheduleDateTime">Choose a scheduled date time:</label>
        	<input type="hidden" id="addressId" name="addressId"value="<%=address.addressId%>"/>
        	<input type="datetime-local" id="scheduledDateTime"
       				name="scheduledDateTime" value="2019-04-25T19:30"
       				min="2019-04-25T00:00" max="2019-04-30T00:00">
       			<input type="submit" onClick="" value="Place Order" class="btn btn-primary">
       		</form>
       		
       		<p> <strong>Scheduled Address:</strong></p>
        	<p><%=address.address1%><br><%=address.address2%><br><%=address.city+", "+address.state+" - "+address.zip %>
        	</p>
        	<p> <strong>Order Items:</strong></p>
       		
        <%
        	List<OrderItem> orderItems = DBAccess.JAK_SP_GetOrderItems(order.orderId);
        	int i=0;
        	%>
        	<table class="table" style="">
            <thead>
                <tr>
                    <th>SN.&nbsp;</th>
                    <th style="text-align:left;">&nbsp;Dish&nbsp;</th>
                    <th>&nbsp;Est. Cost&nbsp;</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
        	<%
        	for(OrderItem item: orderItems){
        		i++;
        		Dish d = DBAccess.JAK_SP_GetDish(item.dishId);
        		%>
        		
        		<tr style="border:1;">
        			<td>&nbsp;<%=i %>&nbsp;</td>
        			<td>&nbsp;<%=d.name +" ("+ d.baseUnits + " "+d.unitDescription +")"%>&nbsp;</td>  
        			<td>&nbsp;<%="  $"+d.estCost %>&nbsp;</td>
        			<td>
        			<form ACTION="removeOrderItem.do" METHOD="POST"> 
	                    	<input type="hidden" name="dishId" id="dishId" value="<%=item.dishId%>"/>
	                    	<input type="submit" onClick="" value="Remove" class="remove">
	                    </form>
        			</td>		
        		</tr>
        		<%
        	}
			%>
			<tfoot>
				<tf>
					<tr>
					<td colSpan="2"style="padding:20px; text-align:right;"><strong>Total Estimated Cost (before tax)
					</strong>
					</td>
					<td><strong>&nbsp;$<%=order.estCostWithoutTax %></strong>
					</td>
					<td></td>
					</tr>
				</tf>
			</tfoot>
        	</tbody>
        	</table> 
        	</div>      
    </div>
 
    <%} %>
  		