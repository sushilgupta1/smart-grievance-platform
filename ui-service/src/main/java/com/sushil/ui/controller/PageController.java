package com.sushil.ui.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PageController {

	@GetMapping({"/login","/"})
	public String loginPage()
	{
		return "login";
	}
	
	@GetMapping("/register")
	public String registerPage()
	{
		return "register";
	}
	
	@GetMapping("/grievance")
	public String grievancePage()
	{
		return "grievance";
	}

	@GetMapping("/dashboard")
	public String dashboardPage()
	{
		return "dashboard";
	}
	
}
