package com.smhrd.web;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.smhrd.database.HeatRoadMapper;
import com.smhrd.model.HeatRoadDTO;

@Controller
@PropertySource("classpath:application.properties")
public class HeatRoadPageController {

	@Autowired
	private HeatRoadMapper mapperHeatRoad;

	@Value("${kakaoMapAPI}")
	private String kakaoMapAPI;

	@RequestMapping("/HeatRoadListPage.do")
	public String heatRoadListPage(Model model) {
		
		ArrayList<HeatRoadDTO> roadList = (ArrayList<HeatRoadDTO>)mapperHeatRoad.selecAllHeatRoad();
		
		model.addAttribute("roadList", roadList);
		model.addAttribute("kakaoMapAPI", kakaoMapAPI);
		System.out.println("로드리스트"+roadList);
		return "heatloadPage/HeatRoadListPage";
	}

}
