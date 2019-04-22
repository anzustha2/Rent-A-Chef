package coreservlets;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import database.DBAccess;
import model.Order;
import model.User;

public class RemoveOrderItem extends Action {
	@Override
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		User usr = null;
		ArrayList<String> responses = new ArrayList<String>();
		HttpSession session = request.getSession();
		Order order;
		int orderId = 0;
		int dishId = 0;
		if (request.getParameter("dishId") != null) {
			dishId = Integer.parseInt(request.getParameter("dishId"));
		}

		User user = (User) session.getAttribute("user");
		if (session.getAttribute("order") != null) {
			order = (Order) session.getAttribute("order");
			orderId = order.orderId;
		}
		if (orderId > 0 && dishId > 0) {
			DBAccess.JAK_SP_RemoveOrderItem(orderId, dishId);
		}
		order = DBAccess.JAK_SP_GetOrder(orderId);

		session.setAttribute("order", order);
		return (mapping.findForward("startOrder"));

	}

}
