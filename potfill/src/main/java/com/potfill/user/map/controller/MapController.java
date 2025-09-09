package com.potfill.user.map.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.potfill.user.map.service.MapService;

@Controller
public class MapController {
	
	@Autowired
	MapService mapService;
	
	@GetMapping(value = "map")
	public String home() {
		return "user/map/map";
	}
	
	@GetMapping(value = "map2")
	public String home2(Model model) {
		model.addAttribute("holeList", mapService.getPotholeLists());
		return "user/map/map2";
	}
}
