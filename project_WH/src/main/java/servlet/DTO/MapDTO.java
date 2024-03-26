package servlet.DTO;

import lombok.Data;

@Data
public class MapDTO {
	//시도 data
	private String geom, ufid, sd_cd, sd_nm, divi;
	//시군구 data
	private String geometry, adm_sect_c, sgg_nm, sgg_oid, col_adm_se, gid, sgg_cd;

	private String xmax, ymax, xmin, ymin;
}
