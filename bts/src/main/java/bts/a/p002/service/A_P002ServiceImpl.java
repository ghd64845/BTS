package bts.a.p002.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import bts.a.p002.dao.A_P002DAO;
import bts.common.report.vo.PnishVO;
import bts.common.report.vo.ReportVO;

@Service("a_p002Service")
public class A_P002ServiceImpl implements A_P002Service{
	@Autowired
	A_P002DAO a_p002DAO;

	@Override
	public List<PnishVO> selectPnishList(String p_name) {
		List<PnishVO> list = a_p002DAO.selectPnishList(p_name);
		return list;
	}

	@Override
	public void savePnishList(Map<String, String[]> dataMap) {
		String[] status = dataMap.get("STATUS");
		int length = status.length; // row수
		int i = 0;
		
		for(String str : status) {
			Map<String, String> row = getRow(dataMap, length, i); // 현재 Index의 Row Map
			if("I".equals(str)) { // 추가
				a_p002DAO.insertPnish(row);
			}else if("U".equals(str)) { // 수정
				a_p002DAO.updatePnish(row);
			}else if("D".equals(str)) { // 삭제
				a_p002DAO.deletePnish(row);
			}
			i++;
		}
	}
	
	private Map<String, String> getRow(Map<String, String[]> dataMap, int length, int index) {
		Map<String, String> row = new HashMap<String, String>();
		for(String name : dataMap.keySet()) {
			String[] data = dataMap.get(name);
			if(length == data.length) {
				row.put(name, data[index]);
			}
		}		
		return row;
	}

	@Override
	public List<ReportVO> selectReportList(Map<String, String> searchMap) {
		List<ReportVO> list = a_p002DAO.selectReportList(searchMap);
		return list;
	}

	@Override
	public ReportVO selectReportContent(int report_no) {
		ReportVO result = a_p002DAO.selectReportContent(report_no);
		return result;
	}

	@Override
	public String selectMenuName(String report_se) {
		String result = a_p002DAO.selectMenuName(report_se);
		return result;
	}	
}
