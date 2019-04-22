package coreservlets;

import java.text.SimpleDateFormat;
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
import utility.Helper;

public class SubmitOrder extends Action {
	@Override
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		User usr = null;
		ArrayList<String> responses = new ArrayList<String>();
		HttpSession session = request.getSession();
		Order order = null;
		int orderId = 0;
		int addressId = 0;
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd,HH:mm");
		String scheduledDateTime = request.getParameter("scheduledDateTime");

		if (session.getAttribute("order") != null) {
			order = (Order) session.getAttribute("order");
			orderId = order.orderId;
		}

		if (request.getParameter("addressId") != null) {
			addressId = Integer.parseInt(request.getParameter("addressId"));
		}
		if (request.getParameter("addressId") != null) {
			addressId = Integer.parseInt(request.getParameter("addressId"));
		}
		User user = (User) session.getAttribute("user");

		DBAccess.JAK_SP_UpdateOrder(orderId, 0, "", scheduledDateTime, addressId, "", "", "OP", order.estCostWithoutTax,
				order.estTax, 0.0, 0.0);

		session.removeAttribute("order");
		Helper.prepareNextPage(request.getSession(), responses, "usr-home-content");
		return (mapping.findForward("main"));

	}

}
