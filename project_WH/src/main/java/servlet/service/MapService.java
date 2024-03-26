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

}
