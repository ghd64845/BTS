package bts.d.p001_4.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller("d_p001_4")
@RequestMapping(value="/community")
public class D_P001_4ControllerImpl implements D_P001_4Controller{

	@Override
	@RequestMapping(value="/plan_list" ,method={RequestMethod.POST,RequestMethod.GET})
	public ModelAndView searchArticle(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView("/d/p001_4/d001");
		return mav;
		
	}

}
