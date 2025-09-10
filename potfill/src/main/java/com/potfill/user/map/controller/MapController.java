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
	
	@GetMapping(value = "admin/map")
	public String adminMap(Model model) {
		model.addAttribute("holeList", mapService.getPotholeLists());
		return "admin/map/admin-real-time-pothole";
	}
	
	@GetMapping(value = "user/map")
	public String userMap(Model model) {
		model.addAttribute("holeList", mapService.getPotholeLists());
		return "user/real-time-pothole";
	}
}
