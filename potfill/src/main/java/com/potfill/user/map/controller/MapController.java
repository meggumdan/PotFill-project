package com.potfill.user.map.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MapController {
	
	@GetMapping(value = "map")
	public String home() {
		return "user/map/map";
	}
}
