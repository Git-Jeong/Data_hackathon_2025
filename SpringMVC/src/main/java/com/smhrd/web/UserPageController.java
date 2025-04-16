package com.smhrd.web;

import java.io.IOException;
import java.util.List;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.beans.factory.annotation.Value;

import com.smhrd.config.AESUtils;
import com.smhrd.config.aesUtils;
import com.smhrd.database.CommentMapper;
import com.smhrd.database.ComplainMapper;
import com.smhrd.model.CommentDTO;
import com.smhrd.model.ComplainDTO;

@Controller
public class UserPageController {

	@Autowired
	private ComplainMapper mapperComplain;
	
	@Autowired
	private CommentMapper mapperComment;

	@Autowired
	private AESUtils aesUtils;
	
	@Value("${kakaoMapAPI}")
    private String kakaoMapAPI;
	
	@Value("${spring.datasource.username}")
    private String connected_db_name;
	
	@Autowired
	private S3Uploader s3Uploader;
	
	// 최초 접속 페이지 -> url에 뭐가 없는 기본 '/'인 경우 접속되는 페이지
	@RequestMapping("/")
	public String MainPage() {
		return "userPage/MainPage";
	}

	// 유저들(=민원인)들이 이용하는 메인 페이지
	@GetMapping("/UserMainPage.do")
	public String userMainPage(Model model) {

		int total_count = mapperComplain.countComplain();
		int clear_count = mapperComplain.countClearComplain();

		int week_count = mapperComplain.countWeekDayComplain();
		int week_clear_count = mapperComplain.countWeekDayClearComplain();
				

//		System.out.println(total_count);
//		System.out.println(clear_count);
//		System.out.println(today_count);
//		System.out.println(week_count);

//		테스트용 더미데이터 삽입
//		total_count = 42;
//		clear_count = 40;
//		
//		week_count = 324;
//		week_clear_count = 224;
		
		model.addAttribute("total_count", total_count);
		model.addAttribute("clear_count", clear_count);
		model.addAttribute("week_count", week_count);
		model.addAttribute("week_clear_count", week_clear_count);
		
		return "userPage/UserMainPage";
	}

	// 게시글 목록 페이지
	@GetMapping("/BoardListPage.do")
	public String boardListPage(@RequestParam(value = "pageIdx", required = false, defaultValue = "0") int pageIdx,
			Model model) {

//		System.out.println("불러온 인덱스 : " + pageIdx); 
		int max_count = mapperComplain.countComplain();
		int totalPages = (int) Math.ceil(max_count / 10.0);
		int offset = (pageIdx - 1) * 10;
//		System.out.println(max_count);
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
		return "userPage/BoardListPage";
	}

	// 게시글 검색 페이지
	@GetMapping("/BoardSearchPage.do")
	public String boardSearchPage(@RequestParam(value = "searchTitle", required = false) String searchTitle,
			@RequestParam(value = "searchPageIdx", required = false, defaultValue = "0") int searchPageIdx,
			Model model) {

		if (searchTitle != null && !searchTitle.trim().isEmpty()) {
			int max_count = mapperComplain.countTitleComplain(searchTitle);
			int searchTotalPages = (int) Math.ceil(max_count / 10.0);
			int offset = (searchPageIdx - 1) * 10;
			if (searchPageIdx < 1) {
				searchPageIdx = 1;
				offset = 0;
			}

//			System.out.println("검색어: " + searchTitle + ", searchPageIdx: " + searchPageIdx + ", offset: " + offset + ", 찾은 게시글 수 : " + max_count + "searchTotalPages" + searchTotalPages);

			if (max_count < offset) {
				offset = max_count;
			}
			List<ComplainDTO> searchComplainList = mapperComplain.searchComplainTitleWithPaging(searchTitle, offset);

//			System.out.println(searchComplainList);
			model.addAttribute("searchComplainList", searchComplainList);
			model.addAttribute("searchTitle", searchTitle);
			model.addAttribute("searchPageIdx", searchPageIdx);
			model.addAttribute("searchTotalPages", searchTotalPages);

			return "userPage/BoardSearchListPage";
		} else {
			return "redirect:/BoardListPage.do";
		}
	}

	// 게시글 작성 페이지 이동
	@GetMapping("/BoardInsertPage.do")
	public String boardInsertPage(Model model) {
	    model.addAttribute("kakaoMapApiKey", kakaoMapAPI);
		return "userPage/BoardInsertPage";
	}

	// 게시글 작성 
	@PostMapping("/BoardInsertPage.do")
	public String boardInsertPage(ComplainDTO boardContent,
            @RequestParam(value = "input_picture_file", required = false) MultipartFile input_picture_file) { 
		
//		System.out.println("boardContent = " + boardContent);
//
//		System.out.println("파일 이름: " + picture.getOriginalFilename());
//		System.out.println("파일 크기: " + picture.getSize());


	    try {
	        if (input_picture_file != null && !input_picture_file.isEmpty()) {
	            // S3에 업로드
	            String imageUrl = s3Uploader.upload(input_picture_file);

	            // 업로드된 이미지 URL을 boardContent에 설정
	            boardContent.setPicture(imageUrl);
	        }
	    } catch (IOException e) {
	        e.printStackTrace();
	        return "userPage/BoardInsertPage";
	    }
	    
	    boardContent.setPw(aesUtils.encrypt(boardContent.getPw()));
	    
//	    System.out.println("저장하는 데이터 : " + boardContent);
	    int result = mapperComplain.BoardInsertPage(boardContent);
	    if (result > 0) {
	    	int find_cpl_idx = mapperComplain.findNowComplain(boardContent);
	        return "redirect:/BoardContentPage.do?cpl_idx="+find_cpl_idx;
	    }
        return "userPage/BoardInsertPage";
	}



	// 게시글 상세보기 페이지
	@GetMapping("/BoardContentPage.do")
	public String boardContentPage(@RequestParam("cpl_idx") int cpl_idx, Model model) {
		ComplainDTO boardContent = mapperComplain.BoardContentPage(cpl_idx);
		CommentDTO boardComment = mapperComment.BoardCommentPage(cpl_idx); 
		if (boardContent != null) {

//			System.out.println("가지고 온 데이터  = " + boardContent);

			if(boardContent.getPicture() != null) {
				String complain_img_url = s3Uploader.generatePresignedUrl(boardContent.getPicture());
				boardContent.setPicture(complain_img_url);
			}
			if(boardComment != null && boardComment.getCmtfile() != null) {
				String complain_img_url = s3Uploader.generatePresignedUrl(boardComment.getCmtfile());
				boardComment.setCmtfile(complain_img_url);
			}
			model.addAttribute("boardContent", boardContent);
			model.addAttribute("boardComment", boardComment);
			return "userPage/BoardContentPage";
		} else {
			return "redirect:/BoardListPage.do";
		}

	}

	//사용자 검증 절차 
	@PostMapping("/PwAuth.do")
	public String pwAuth(@RequestParam("cpl_idx") int cpl_idx, @RequestParam("password") String password,
			@RequestParam("nextAction") String nextAction, HttpSession session) {

		Integer target_cpl_idx = (Integer) cpl_idx;
		String target_pw = password;

		if ((target_cpl_idx != null) && (target_pw != null)) {
			target_pw = aesUtils.encrypt(target_pw);
			
			ComplainDTO checkUser = new ComplainDTO();
			checkUser.setCpl_idx(target_cpl_idx);
			checkUser.setPw(target_pw);

			int result = mapperComplain.PwAuth(checkUser);

			if (result != 0) {
				
				if ("update".equals(nextAction)) { 
					session.setAttribute("auth_cpl_idx", cpl_idx);
					session.setAttribute("auth_cpl_idx_time", System.currentTimeMillis());
					return "redirect:/BoardUpdatePage.do?cpl_idx=" + target_cpl_idx;
				}

				else if ("delete".equals(nextAction)) {
					session.setAttribute("target_cpl_idx", target_cpl_idx); 
					session.setAttribute("target_pw", target_pw);
					return "redirect:/BoardDelete.do";
				}
			}
		}

		return "redirect:/BoardContentPage.do?cpl_idx=" + target_cpl_idx; // 게시글 상세 페이지로 이동
	}

	// 게시글 수정할 값을  불러오기
	@GetMapping("/BoardUpdatePage.do")
	public String boardUpdatePage(@RequestParam("cpl_idx") int cpl_idx, Model model, HttpSession session) {
	    Integer authIdx = (Integer) session.getAttribute("auth_cpl_idx");
	    Long authIdxTime = (Long) session.getAttribute("auth_cpl_idx_time"); // 세션에 저장된 시간 가져오기
	    
	    // 세션이 존재하고, 시간도 만료되지 않았다면
	    if (authIdx != null && authIdx == cpl_idx) {
	    	long authIdxTimeLong = (long) authIdxTime;
	    	int time = (int)((System.currentTimeMillis() - authIdxTimeLong) / 1000);
	    	
//		    System.out.println("세션 경과시간 : " + time + "초");
		    
	        if (authIdxTime != null && time <= 30 * 60) {
	            ComplainDTO boardContent = mapperComplain.BoardContentPage(cpl_idx); 
	            
				if(boardContent.getPicture() != null) {
					String complain_img_url = s3Uploader.generatePresignedUrl(boardContent.getPicture());
					boardContent.setPicture(complain_img_url);
				}
				
	            model.addAttribute("kakaoMapApiKey", kakaoMapAPI);
	            model.addAttribute("boardContent", boardContent);
	            return "userPage/BoardUpdatePage";
	        } else {
	            // 세션이 만료된 경우 처리
	            session.removeAttribute("auth_cpl_idx");
	            session.removeAttribute("auth_cpl_idx_time");
	            return "redirect:/BoardContentPage.do?cpl_idx=" + cpl_idx; 
	        }
	    }
	    return "redirect:/BoardContentPage.do?cpl_idx=" + cpl_idx; // 게시글 상세 페이지로 이동
	}


	// 게시글 수정값 보내주기
	@PostMapping("/BoardUpdatePage.do")
	public String boardUpdatePage(ComplainDTO dto, HttpSession session, 
            @RequestParam(value = "input_picture_file", required = false) MultipartFile input_picture_file) {
		
		Integer authIdx = (Integer) session.getAttribute("auth_cpl_idx");
		System.out.println(authIdx);
		if (authIdx != null && authIdx.equals(dto.getCpl_idx())){
			
			//사진 삭제 및 재등록
			if(input_picture_file != null  && !input_picture_file.isEmpty()) {
				String deletePictureFile = mapperComplain.selectPicture(dto.getCpl_idx());
				if(deletePictureFile != null) {
					System.out.println("삭제하는 파일 : " + deletePictureFile);
					s3Uploader.deleteFile(deletePictureFile);
				}
				try {
					String complain_img_url = s3Uploader.upload(input_picture_file);
					dto.setPicture(complain_img_url);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			int result = mapperComplain.BoardUpdatePage(dto);
			System.out.println(result);
				if (result > 0) {
					session.removeAttribute("auth_cpl_idx");
					session.removeAttribute("auth_cpl_idx_time");
					return "redirect:/BoardContentPage.do?cpl_idx=" + dto.getCpl_idx();
				} else {
					return "userPage/BoardUpdatePage"; // 실패 시 다시 수정 페이지
				}
		}
		return "redirect:/BoardContentPage.do?cpl_idx=" + dto.getCpl_idx();// 게시글 상세 페이지로 이동
	}
	
	// 게시글 수정을 취소하기 
	@GetMapping("/BoardUpdatCancel.do")
	public String boardUpdateCancel(@RequestParam("cpl_idx") int cpl_idx,  HttpSession session) {
		session.removeAttribute("auth_cpl_idx");
		System.out.println("auth_cpl_idx 세션을 삭제함.");
		return "redirect:/BoardContentPage.do?cpl_idx=" +cpl_idx;// 게시글 상세 페이지로 이동
	}
	
	// 게시글 삭제 페이지
	@GetMapping("/BoardDelete.do")
	public String boardDelete(HttpSession session) {

		if (session.getAttribute("target_cpl_idx") != null && session.getAttribute("target_pw") != null) {
			int target_cpl_idx = (int) session.getAttribute("target_cpl_idx");
			String target_pw = (String) session.getAttribute("target_pw");

			target_pw = aesUtils.encrypt(target_pw);
			
			ComplainDTO info = new ComplainDTO();
			info.setCpl_idx(target_cpl_idx);
			info.setPw(target_pw);

			String deletePictureFile = mapperComplain.selectPicture(target_cpl_idx);
			if(deletePictureFile != null) {
				System.out.println("삭제하는 파일 : " + deletePictureFile);
				s3Uploader.deleteFile(deletePictureFile);
			}
			
			mapperComplain.BoardDelete(info);

			session.removeAttribute("target_cpl_idx");
			session.removeAttribute("target_pw");
		}

		return "redirect:/BoardListPage.do";
	}

}
