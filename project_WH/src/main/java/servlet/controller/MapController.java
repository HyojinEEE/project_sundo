package servlet.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import servlet.DTO.MapDTO;
import servlet.service.FileService;
import servlet.service.MapService;

@RestController
public class MapController {

	@Resource(name = "MapService")
	private MapService mapService;
	
	@Resource(name="FileService")
	private FileService fileService;
	
	//시도 선택시 줌
	@PostMapping("/selectSgg.do")
	public List<MapDTO> selectSgg(@RequestParam("test") String name) { //name이라는 이름의 test 파라미터를 받습니다. 
		List<MapDTO> list = mapService.selectSgg(name);
		List<MapDTO> geom = mapService.selectGeom(name);
		
		MapDTO sdview = mapService.sdview(name);
		list.add(sdview);
		System.out.println(list);
		
		return list;
	}
	
	//시군구 선택시 줌
	@PostMapping("/selectB.do")
	public MapDTO selecB(@RequestParam("sggzoom") String name) {
		MapDTO sggview = mapService.sggview(name);
		System.out.println(name);
		System.out.println(sggview);
		return sggview;
	}
	
	//등간격
	@PostMapping("/legend.do")
	public Map<String, Object> legend(@RequestParam("legend") String legend) {
		Map<String , Object> response = new HashMap<>();
		
		if (legend.equals("hyojin")) {
			response.put("legend",mapService.hyojin());
			System.out.println(mapService.hyojin());
		} else if (legend.equals("natural")) {
			response.put("legend",mapService.natural());
			System.out.println(mapService.natural());
		}
		return response;
	}
	
	//파일 업로드
	@PostMapping("/fileUpload.do")
	public void fileUpload(@RequestParam("testfile") MultipartFile multi) throws IOException {

		System.out.println(multi.getOriginalFilename());
		System.out.println(multi.getName());
		System.out.println(multi.getContentType());
		System.out.println(multi.getSize());

		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();

		InputStreamReader isr = new InputStreamReader(multi.getInputStream());
		BufferedReader br = new BufferedReader(isr);

		String line = null;
		while ((line = br.readLine()) != null) {
			Map<String, Object> m = new HashMap<String, Object>();
			String[] lineArr = line.split("\\|");

			System.out.println(Arrays.toString(lineArr));
			m.put("yearMonthUse", lineArr[0]); // 사용년월
			m.put("landLocation", lineArr[1]); // 대지위치
			m.put("roadLandLocation", lineArr[2]); // 도로명대지위치 
			m.put("sggCode", lineArr[3]); // 시군구코드
			m.put("bjdCode", lineArr[4]); // 법정동코드 
			m.put("landCode", lineArr[5]); // 대지구분코드 
			m.put("bun", lineArr[6]); // 번 
			m.put("ji", lineArr[7]); // 지 
			m.put("newAddNumber", lineArr[8]); // 새주소일련번호
			m.put("newRoadCode", lineArr[9]); // 새주소도로코드 
			m.put("newLandCode", lineArr[10]);// 새주소지상지하코드
			m.put("newbonbeon", !lineArr[11].isEmpty() ? Integer.parseInt(lineArr[11]) : 0); // 새주소본번 
			m.put("newbubeon", !lineArr[12].isEmpty() ? Integer.parseInt(lineArr[12]) : 0); // 새주소부번 
			m.put("usage", !lineArr[13].isEmpty() ? Integer.parseInt(lineArr[13]) : 0); // 사용량
           
			list.add(m);
		}
		fileService.uploadFile(list);

		br.close();
		isr.close();
	}
}
