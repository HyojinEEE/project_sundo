package servlet.Impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import servlet.DAO.BeomDAO;
import servlet.DAO.GeomDAO;
import servlet.DAO.MapDAO;
import servlet.DTO.MapDTO;
import servlet.service.MapService;

@Service("MapService")
public class MapImpl implements MapService {
	
	@Autowired
	public MapDAO mapdao;
	
	@Autowired
	public BeomDAO beomdao;
	
	@Autowired
	public GeomDAO geomdao;
	
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
	
	@Override
	public List<MapDTO> natural() {
		return beomdao.natural();
	}
	
	@Override
	public List<MapDTO> hyojin() {
		return beomdao.hyojin();
	}

	@Override
	public List<MapDTO> selectGeom(String name) {
		return geomdao.selectGeom(name);
	}

	@Override
	public List<MapDTO> selectB(String name) {
		return geomdao.selectB(name);
	}
	
}
