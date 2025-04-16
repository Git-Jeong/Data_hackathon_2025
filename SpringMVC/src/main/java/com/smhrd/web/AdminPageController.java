package com.smhrd.web;

import java.io.IOException;
import java.util.List;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.smhrd.config.aesUtils;
import com.smhrd.config.AESUtils;
import com.smhrd.config.JwtUtil;
import com.smhrd.database.AdminMapper;
import com.smhrd.database.ComplainMapper;
import com.smhrd.database.CommentMapper;
import com.smhrd.model.AdminDTO;
import com.smhrd.model.CommentDTO;
import com.smhrd.model.ComplainDTO;

import io.jsonwebtoken.Claims;

@Controller
@PropertySource("classpath:application.properties")
public class AdminPageController {

	@Autowired
	private AdminMapper mapperAdmin;

	@Autowired
	private ComplainMapper mapperComplain;
	
	@Autowired
	private CommentMapper mapperComment;

	@Autowired
	private S3Uploader s3Uploader;
	
	@Autowired
	private JwtUtil jwtUtil;
	
	@Autowired
	private AESUtils aesUtils;

	@Value("${kakaoMapAPI}")
	private String kakaoMapAPI;
	
	@Value("${token_name}")
	private String token_name;
	
	@GetMapping({ "/AdminLoginPage.do", "/admin", "/Admin" })
	public String memberLogin(HttpServletRequest request) {
		if (isValidAdminFromToken(request)) {
			return "redirect:/AdminBoardListPage.do";
		}
		return "/adminPage/AdminLoginPage";
	}

	//어드민 로그인
	@PostMapping("/AdminLogin.do")
	public String memberLogin(AdminDTO vo, HttpServletResponse response) {
		
    	vo.setAdmin_pw(aesUtils.encrypt(vo.getAdmin_pw()));
	    AdminDTO Admin_Info = mapperAdmin.adminLogin(vo);

	    if (Admin_Info != null) {
	        // 토큰 생성
	        String token = jwtUtil.createToke(Admin_Info);
	        
	        // 쿠키에 저장
	        Cookie cookie = new Cookie(token_name, token);
	        cookie.setPath("/"); 
	        cookie.setMaxAge(30 * 60);  // 30분

	        response.addCookie(cookie);

	        return "redirect:/AdminBoardListPage.do"; // 로그인 후 리다이렉트
	    } else {
	        return "adminPage/AdminLoginPage"; // 로그인 실패 시 로그인 페이지로 리다이렉트
	    }
	}


	//민원 목록 
	@GetMapping("/AdminBoardListPage.do")
	public String AdminBoardListPage(@RequestParam(value = "pageIdx", required = false, defaultValue = "0") int pageIdx,
			HttpServletRequest request, Model model) {

		if (!isValidAdminFromToken(request)) {
			return "redirect:/AdminLoginPage.do";
		}

		int max_count = mapperComplain.countComplain();
		int totalPages = (int) Math.ceil(max_count / 10.0);
		int offset = (pageIdx - 1) * 10;
		if (pageIdx < 1) {
			pageIdx = 1;
			offset = 0;
		}
		if (max_count < offset) {
			offset = max_count;
		}
		List<ComplainDTO> complainList = mapperComplain.selectComplainList(offset);
		model.addAttribute("complainList", complainList);
		model.addAttribute("pageIdx", pageIdx);
		model.addAttribute("totalPages", totalPages);
		return "adminPage/AdminBoardListPage";
	}

	// 게시글 상세 보기 
	@GetMapping("/AdminBoardContentPage.do")
	public String BoardContentPage(@RequestParam("cpl_idx") int cpl_idx, Model model,
			HttpServletRequest request) {

		if (!isValidAdminFromToken(request)) {
			return "redirect:/AdminLoginPage.do";
		}

		
		ComplainDTO boardContent = mapperComplain.BoardContentPage(cpl_idx);

		if (boardContent != null) {
			if(boardContent.getPicture() != null && !boardContent.getPicture().trim().isEmpty()) {
				String getImgUer = s3Uploader.generatePresignedUrl(boardContent.getPicture());
				boardContent.setPicture(getImgUer);
			}
			

			CommentDTO boardComment = mapperComment.BoardCommentPage(cpl_idx);
			if(boardComment != null) {
				String check_comment_img = mapperComment.selectCommentImg(cpl_idx);
				
				if(check_comment_img != null) {
					String getCommentImgUer = s3Uploader.generatePresignedUrl(check_comment_img);
					boardComment.setCmtfile(getCommentImgUer);
				}
				
			}
			
			model.addAttribute("boardContent", boardContent);
			model.addAttribute("boardComment", boardComment);
			
			return "adminPage/AdminBoardContentPage";
		} else {
			return "redirect:/AdminBoardListPage.do";
		}
	}

	// 민원 처리 
	@PostMapping("/adminCommentInsert.do")
	public String adminCommentInsert(HttpServletRequest request, HttpServletResponse response, 
			CommentDTO comment, @RequestParam(value = "input_img_file", required = false) MultipartFile input_img_file) {

		AdminDTO adminInfo = getTokenValue(request);
		
        if (adminInfo.getAdmin_id() == null || adminInfo.getAdmin_name() == null) {
            return "redirect:/AdminLoginPage.do";
        }
		
		int state_check = mapperComplain.getState(comment.getCpl_idx());
		if(state_check == 0) {
			if(input_img_file != null && !input_img_file.isEmpty()) {
				try {
					String setCommentImgUer = s3Uploader.upload(input_img_file);
					comment.setCmtfile(setCommentImgUer);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					System.out.println("저장 실패... : " + input_img_file.getName());
				}
			}
			comment.setAdmin_id(adminInfo.getAdmin_id());
			comment.setAdmin_name(adminInfo.getAdmin_name());
			
			boolean result = mapperComment.insertComment(comment);
			if(result) {
				mapperComplain.changeState(comment.getCpl_idx());
			}
		}
		return "redirect:/AdminBoardContentPage.do?cpl_idx="+comment.getCpl_idx();
	}
	
	// 게시글 검색 페이지
	@GetMapping("/AdminBoardSearchPage.do")
	public String BoardSearch(@RequestParam(value = "searchTitle", required = false) String searchTitle,
			@RequestParam(value = "searchPageIdx", required = false, defaultValue = "0") int searchPageIdx,
			HttpServletRequest request, Model model) {

		if (!isValidAdminFromToken(request)) {
			return "redirect:/AdminLoginPage.do";
		}
		
		if (searchTitle != null && !searchTitle.trim().isEmpty()) {
			int max_count = mapperComplain.countTitleComplain(searchTitle);
			int searchTotalPages = (int) Math.ceil(max_count / 10.0);
			int offset = (searchPageIdx - 1) * 10;
			if (searchPageIdx < 1) {
				searchPageIdx = 1;
				offset = 0;
			}

			if (max_count < offset) {
				offset = max_count;
			}
			List<ComplainDTO> searchComplainList = mapperComplain.searchComplainTitleWithPaging(searchTitle, offset);

			model.addAttribute("searchComplainList", searchComplainList);
			model.addAttribute("searchTitle", searchTitle);
			model.addAttribute("searchPageIdx", searchPageIdx);
			model.addAttribute("searchTotalPages", searchTotalPages);

			return "adminPage/AdminSearchListPage";
		} else {
			return "redirect:/AdminBoardListPage.do";
		}
	}
	
	// 게시글 삭제 페이지
	@PostMapping("/BoardCommentDelete.do")
	public String BoardCommentDelete(HttpServletRequest request, ComplainDTO vo) {
		
		if (!isValidAdminFromToken(request)) {
			return "redirect:/AdminLoginPage.do";
		}

		String check_compain_img = mapperComplain.selectPicture(vo.getCpl_idx());
		if(check_compain_img != null) {
			s3Uploader.deleteFile(check_compain_img);
		}
		mapperComplain.BoardDeleteAdmin(vo);

		return "redirect:/AdminBoardListPage.do";
	}

	// 어드민의 로그인 정보를 관리하는 토큰
	private boolean isValidAdminFromToken(HttpServletRequest request) {
	    // 쿠키에서 Authorization 값 가져오기
	    String token = null;
	    Cookie[] cookies = request.getCookies();
	    if (cookies != null) {
	        for (Cookie cookie : cookies) {
	            if (token_name.equals(cookie.getName())) {
	                token = cookie.getValue();
	                break;
	            }
	        }
	    }

	    if (token == null) {
	        return false;
	    }

	    try {
	        Claims claims = jwtUtil.validateToken(token);
	        
	        String admin_id = (String) claims.get("admin_id");
	        String admin_name = (String) claims.get("admin_name");

	        // DB에서 유효한 관리자 확인
	        AdminDTO checkAdmin = new AdminDTO();

	        checkAdmin.setAdmin_id(admin_id);
	        checkAdmin.setAdmin_name(admin_name);
	        boolean result = mapperAdmin.findById(checkAdmin);
	        if(result) {
	        	System.out.println("토큰 검증 성공!");
	        }
	        return result;
	    } catch (Exception e) {
	        return false;
	    }
	}

	//토큰의 정보를 리턴하는메소
	private AdminDTO getTokenValue(HttpServletRequest request) {
        // 토큰 검증 및 정보 추출을 한 번에 처리
	    String token = null;
	    Cookie[] cookies = request.getCookies();
	    if (cookies != null) {
	        for (Cookie cookie : cookies) {
	            if (token_name.equals(cookie.getName())) {
	                token = cookie.getValue();
	                break;
	            }
	        }
	    }
        Claims claims = jwtUtil.validateswToken(token);
		
		AdminDTO adminInfo = new AdminDTO();
		adminInfo.setAdmin_id((String) claims.get("admin_id"));
		adminInfo.setAdmin_name((String) claims.get("admin_name"));
		
		return adminInfo;
	}
	
	//어드민 로그아웃
	@GetMapping("/AdminLogout.do")
	public String AdminLogout(HttpServletResponse response) {
		Cookie cookie = new Cookie(token_name, "");
		cookie.setPath("/"); 
		cookie.setMaxAge(0);  
		response.addCookie(cookie);
	    return "redirect:/AdminLoginPage.do";
	}


}
