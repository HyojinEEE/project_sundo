package servlet.Impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import servlet.DTO.MapDTO;
import servlet.service.MapService;

@Service("MapService")
public class MapImpl implements MapService {
	
	@Autowired
	public MapDAO mapdao;
	
	@Override
	public List<MapDTO> selectsd() {
		return mapdao.selectsd();
	}

	@Override
	public List<MapDTO> selectSgg(String sdname) {
		return mapdao.selectSgg(sdname);
	}

	@Override
	public MapDTO sdview(String name) {
		return mapdao.sdview(name);
	}

	@Override
	public MapDTO sggview(String name) {
		return mapdao.sggview(name);
	}
	
}
