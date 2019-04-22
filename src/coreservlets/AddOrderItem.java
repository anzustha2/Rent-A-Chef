package coreservlets;

import java.time.LocalDateTime;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import database.DBAccess;
import model.Dish;
import model.Order;
import model.User;

public class AddOrderItem extends Action {
	@Override
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		User usr = null;
		ArrayList<String> responses = new ArrayList<String>();
		HttpSession session = request.getSession();
		Order order;
		int orderId;
		int dishId = 0;
		if (request.getParameter("dishId") != null) {
			dishId = Integer.parseInt(request.getParameter("dishId"));
		}
		User user = (User) session.getAttribute("user");

		Dish dish = DBAccess.JAK_SP_GetDish(dishId);
		if (session.getAttribute("order") != null) {
			order = (Order) session.getAttribute("order");
			orderId = order.orderId;
		} else {
			LocalDateTime d = LocalDateTime.now();
			java.sql.Date sqlDate = java.sql.Date.valueOf(d.toLocalDate());
			orderId = DBAccess.JAK_SP_CreateOrder(user.userId, 0, sqlDate, sqlDate);
		}
		DBAccess.JAK_SP_AddOrderItem(orderId, dish.dishId, dish.unitTypeCode, 1.0, dish.estCost, 0.0);

		order = DBAccess.JAK_SP_GetOrder(orderId);

		session.setAttribute("order", order);
		return (mapping.findForward("startOrder"));

	}

}
