package servlet.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import servlet.DTO.MapDTO;
import servlet.service.MapService;
import servlet.service.ServletService;

@Controller
public class ServletController {
   @Resource(name = "ServletService")
   private ServletService servletService;
   
   @Resource(name="MapService")
   private MapService mapService;
   
   @RequestMapping(value = "/main.do")
   public String mainTest(ModelMap model) throws Exception {
      List<MapDTO> list = mapService.selectsd();
      model.addAttribute("list",list);
      System.out.println(list.get(0).getSd_nm());
      return "main/main";
   }
   
   
   @RequestMapping("/test.do")
   public String test() {
      return "main/test";
   }
}