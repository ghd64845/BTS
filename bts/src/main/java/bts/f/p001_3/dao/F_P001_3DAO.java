package bts.f.p001_3.dao;

import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import bts.d.p001_4.vo.D_P001_4VO;
import bts.f.p001_3.vo.F_P001_3VO;
import bts.f.p001_3.vo.F_P001_3VO_2;
import bts.f.p001_3.vo.F_P001_3VO_3;

public interface F_P001_3DAO {
	public void insertArticle(F_P001_3VO f_p001_3VO) throws DataAccessException;
	public void insertTagList(List<F_P001_3VO_2> list) throws DataAccessException;
	public void insertAnswer(F_P001_3VO_3 f_p001_3VO_3) throws DataAccessException;
	public void deleteTagList(F_P001_3VO f_p001_3VO);
	public int deleteAnswer(String answer_no) throws DataAccessException;
	public void updateArticle(F_P001_3VO f_p001_3VO);
	public String selectReviewTotal() throws DataAccessException;
	public String selectCommentTotal(Map<String,String> searchMap) throws DataAccessException;
	public List<F_P001_3VO> selectReviewList(Map<String,String> searchMap) throws DataAccessException;
	public List<String> selectTagList(F_P001_3VO f_p001_3VO) throws DataAccessException;
	public F_P001_3VO selectReviewContents(Map<String,String> searchMap) throws DataAccessException;
	public List<F_P001_3VO_3> selectAnswerList(Map<String,String> searchMap) throws DataAccessException;
	public String selectArticleCd(String menu);
	public int selectRecommendTotal(Map<String, String> searchMap);
	public int selectPlanTotal(Map<String, String> searchMap);
	public List<Map<String, String>> selectRecommend(Map<String, String> searchMap);
	public List<D_P001_4VO> selectPlan(Map<String, String> searchMap);
}
