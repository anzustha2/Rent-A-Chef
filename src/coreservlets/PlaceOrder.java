package coreservlets;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import database.DBAccess;
import model.User;
import utility.Helper;

public class PlaceOrder extends Action {
	@Override
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		User usr = null;
		ArrayList<String> responses = new ArrayList<String>();
		if (Helper.validateDataAndManageSession(request, Helper.loginValidation)) {
			String userName = request.getParameter("userName");
			String password = request.getParameter("password");
			usr = DBAccess.JAK_SP_ProcessLogin(userName, password);

			if (usr == null) {
				responses.add("Invalid username.");
			} else if (usr.hasInvalidPassword()) {
				responses.add("Incorrect password.");
			}
			if (usr != null && !usr.hasInvalidPassword()) {
				Helper.resetDataValidation(request);
			}
		} else {
			responses.add("Please provide the missing information.");
		}
		if (responses.size() > 0) {
			Helper.prepareNextPage(request.getSession(), responses, "login-content");
		} else if (usr.getUserType().equals("ADMIN")) {
			Helper.prepareNextPage(request.getSession(), responses, "admin-home-content");
		} else if (usr.getUserType().equals("USR")) {
			Helper.prepareNextPage(request.getSession(), responses, "usr-home-content");
		} else if (usr.getUserType().equals("CHEF")) {
			Helper.prepareNextPage(request.getSession(), responses, "chef-home-content");
		}
		return (mapping.findForward("main"));
	}

}
