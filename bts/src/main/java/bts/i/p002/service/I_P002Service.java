package bts.i.p002.service;

import java.util.List;
import java.util.Map;

import bts.i.p002.VO.I_P002VO_1;
import bts.i.p002.VO.I_P002VO_2;
import bts.i.p002.VO.I_P002VO_3;

public interface I_P002Service {
	public Map<String, List<String>> planList()throws Exception;
	public Map<String, List<String>> planRoot(String plan_no)throws Exception;
	public void insertPlan(I_P002VO_1 i_p002VO_1,List<I_P002VO_2>contentVO, List<I_P002VO_3> list)throws Exception ;
}
