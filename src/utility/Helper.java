package utility;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class Helper {
	public static String[] loginValidation = { "userName", "password" };

	private static List<String> validData;
	private static List<String> inValidData;
	private static HttpSession currentSession;
	public static String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\." + "[a-zA-Z0-9_+&*-]+)*@" + "(?:[a-zA-Z0-9-]+\\.)+[a-z"
			+ "A-Z]{2,7}$";

	public static String phoneRegex = "\\d{10}|(?:\\d{3}-){2}\\d{4}|\\(\\d{3}\\)\\d{3}-?\\d{4}|\\(d{3}\\) d{3}-?d{4}";

	public Helper() {
		// TODO Auto-generated constructor stub
	}

	public static void prepareNextPage(HttpSession session, ArrayList<String> responses, String content) {
		session.setAttribute("responses", responses);
		session.setAttribute("content", content);
	}

	public static boolean validateDataAndManageSession(HttpServletRequest request, String[] quickQuestionValidation2) {
		resetDataValidation(request);
		validData = new ArrayList<String>();
		inValidData = new ArrayList<String>();
		for (String s : quickQuestionValidation2) {
			request.getSession().removeAttribute(s);// clear if there exist anything in session that we might need in
													// future
			if (request.getParameter(s) != null) {
				if (request.getParameter(s).isEmpty()) {
					inValidData.add(s);
				} else {
					if ((s.equalsIgnoreCase("email") && !validateRegex(request, emailRegex, "email"))
							|| (s.equalsIgnoreCase("phone") && !validateRegex(request, phoneRegex, "phone"))) {
						inValidData.add(s);
					} else {
						validData.add(s);
					}
					request.getSession().setAttribute(s, request.getParameter(s));
				}
			}
		}
		if (!inValidData.isEmpty()) { // only populate the session if current data is invalid
			request.getSession().setAttribute("validData", validData);
			request.getSession().setAttribute("inValidData", inValidData);
		}
		return inValidData.isEmpty();
	}

	public static void resetDataValidation(HttpServletRequest request) {
		if (request.getSession().getAttribute("validData") != null) {
			validData = (List<String>) request.getSession().getAttribute("validData");
		}
		if (request.getSession().getAttribute("inValidData") != null) {
			request.getSession().removeAttribute("inValidData");
			if (inValidData != null)
				inValidData = null;
		}
		if (validData != null) {
			for (String s : validData) {
				request.getSession().removeAttribute(s);
			}
		}
		if (request.getSession().getAttribute("validData") != null) {
			request.getSession().removeAttribute("validData");
			if (validData != null)
				validData = null;
		}
	}

	public static void cleanupSession(HttpServletRequest request) {
		if (request.getSession().getAttribute("responses") != null) {
			ArrayList<String> data = new ArrayList<String>();
			request.getSession().setAttribute("responses", data);
		}
		if (request.getSession().getAttribute("validData") != null) {
			ArrayList<String> data = new ArrayList<String>();
			request.getSession().setAttribute("validData", data);
		}
		if (request.getSession().getAttribute("invalidData") != null) {
			ArrayList<String> data = new ArrayList<String>();
			request.getSession().setAttribute("invalidData", data);
		}
	}

	public static void initializeSessionDataForValidation(HttpServletRequest request) {
		// resetDataValidation(request);
		validData = new ArrayList<String>();
		inValidData = new ArrayList<String>();
		if (request.getSession().getAttribute("validData") != null) {
			validData = (List<String>) request.getSession().getAttribute("validData");
		}
		if (request.getSession().getAttribute("inValidData") != null) {
			inValidData = (List<String>) request.getSession().getAttribute("inValidData");
		}
		currentSession = request.getSession();
	}

	public static String validate(String field) {
		String error = "";
		if (inValidData.contains(field)) {
			error = "error";
		}
		return error;
	}

	public static int getStoredInt(String field) {
		int val = 0;
		if (validData.contains(field)) {
			val = Integer.parseInt((String) currentSession.getAttribute(field));
		}
		return val;
	}

	public static String getStoredString(String field) {
		String val = "";
		if (currentSession.getAttribute(field) != null) {
			val = (String) currentSession.getAttribute(field);
		}
		return val;
	}

	public static String isChecked(String field) {
		String val = "";
		if (currentSession.getAttribute(field) != null) {
			if (val.equalsIgnoreCase(field)) {
				val = "checked";
			}
		}
		return val;
	}

	public static boolean hasErrors() {
		return inValidData != null && !inValidData.isEmpty();
	}

	public static String getErrorClass() {
		return hasErrors() ? "error" : "";
	}

	private static boolean validateRegex(HttpServletRequest request, String regex, String field) {
		return request.getParameter(field).matches(regex);
	}

}
