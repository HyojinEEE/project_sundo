package servlet.DAO;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import servlet.DTO.MapDTO;

@Repository
public class MapDAO {

	@Autowired
	public SqlSession sqlsession;
	
	public List<MapDTO> selectsd() {
		return sqlsession.selectList("map.selectsd");
	}

	public List<MapDTO> selectSgg(String sdname) {
		return sqlsession.selectList("map.selectsgg", sdname);
	}

	public MapDTO sdview(String name) {
		return sqlsession.selectOne("map.sdview", name);
	}

	public MapDTO sggview(String name) {
		return sqlsession.selectOne("map.sggview", name);
	}


}
