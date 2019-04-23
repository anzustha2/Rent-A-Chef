package coreservlets;

import java.time.Instant;
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

public class CompleteOrder extends Action {
	@Override
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		User usr = null;
		ArrayList<String> responses = new ArrayList<String>();
		HttpSession session = request.getSession();
		Order order = null;
		int orderId = Integer.parseInt(request.getParameter("orderId"));
		order = DBAccess.JAK_SP_GetOrder(orderId);

		if (session.getAttribute("order") != null) {
			order = (Order) session.getAttribute("order");
			orderId = order.orderId;
		}

		User user = (User) session.getAttribute("user");
		if (user.userTypeCode.equals("CHEF")) {
			DBAccess.JAK_SP_UpdateOrder(orderId, user.userId, Instant.now().toString(), order.scheduledDateTime,
					order.scheduledAddressId, "", order.pickedUpDateTime, "COMP", order.estCostWithoutTax, order.estTax,
					0.0, 0.0);
		}
		session.removeAttribute("order");
		return (mapping.findForward("viewMyOrders"));

	}

}
