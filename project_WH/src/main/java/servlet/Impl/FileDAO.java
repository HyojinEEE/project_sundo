package servlet.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class FileDAO {

	@Autowired
	private SqlSession sqlSession;

	public void uploadFile(List<Map<String, Object>> list) {
		for (Map<String, Object> data : list) {   // list라는 이름의 리스트에 대한 향상된 for 루프를 시작. Map<String, Object> 타입의 요소를 가지고 있습니다.
			sqlSession.insert("map.uploadFile", data);
		}
		
	}

}
