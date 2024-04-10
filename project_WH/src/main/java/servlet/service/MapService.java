package servlet.service;

import java.util.List;

import org.springframework.stereotype.Service;

import servlet.DTO.MapDTO;

@Service
public interface MapService {

	List<MapDTO> selectsd();

	List<MapDTO> selectSgg(String sdname);

	MapDTO sdview(String name);

	MapDTO sggview(String name);

	List<MapDTO> selectGeom(String name);
	
	List<MapDTO> selectB(String name);
	
	List<MapDTO> natural();

	List<MapDTO> hyojin();	
	
}
