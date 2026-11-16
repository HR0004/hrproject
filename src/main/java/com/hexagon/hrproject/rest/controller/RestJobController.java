package com.hexagon.hrproject.rest.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.hexagon.hrproject.common.response.ApiResponse;
import com.hexagon.hrproject.common.web.Pager;
import com.hexagon.hrproject.domain.Job;
import com.hexagon.hrproject.dto.JobDTO;
import com.hexagon.hrproject.service.JobService;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
public class RestJobController {

	private final JobService jobService;

	@PostMapping("/api/jobs")
	public ResponseEntity<ApiResponse<Void>> regist(@RequestBody JobDTO jobDTO) {

		jobService.regist(jobDTO);

		ApiResponse<Void> response = ApiResponse.success("役職を登録しました", null);

		return ResponseEntity.status(HttpStatus.CREATED).body(response);
	}

	@GetMapping("/api/jobs")
	public ResponseEntity<ApiResponse<List<Job>>> getList() {
		List<Job> jobList = jobService.getList();

		ApiResponse<List<Job>> response = ApiResponse.success("役職一覧を取得しました", jobList);

		return ResponseEntity.status(HttpStatus.OK).body(response);

	}

	@GetMapping("/api/jobs/{jobId}")
	public ResponseEntity<ApiResponse<Job>> getDetail(@PathVariable int jobId) {

		Job job = jobService.getDetail(jobId);

		ApiResponse<Job> response = ApiResponse.success("役職の詳細を取得しました", job);

		return ResponseEntity.status(HttpStatus.OK).body(response);
	}

	@GetMapping("/api/jobs/search")
	public ResponseEntity<ApiResponse<List<Job>>> search(
			@RequestParam(value = "jobName", required = false) String jobName) {

		List<Job> jobList = jobService.search(jobName);

		ApiResponse<List<Job>> response = ApiResponse.success("役職の検索が完了しました", jobList);

		return ResponseEntity.status(HttpStatus.OK).body(response);
	}

	@PutMapping("/api/jobs/{jobId}")
	public ResponseEntity<ApiResponse<Void>> update(@PathVariable int jobId, @RequestBody JobDTO jobDTO) {
		jobService.update(jobId, jobDTO);

		ApiResponse<Void> response = ApiResponse.success("役職情報を更新しました", null);

		return ResponseEntity.status(HttpStatus.OK).body(response);
	}

	// 직급 비활성화
	@DeleteMapping("/api/jobs/{jobId}")
	public ResponseEntity<ApiResponse<Void>> deactivity(@PathVariable int jobId) {

		jobService.deactivity(jobId);

		ApiResponse<Void> response = ApiResponse.success("役職を無効にしました", null);

		return ResponseEntity.status(HttpStatus.OK).body(response);
	}

	// 직급 페이징 목록 조회
	@GetMapping("/api/jobs/page")
	public ResponseEntity<ApiResponse<Pager>> getPageList(HttpServletRequest request) {

		// Service에서 페이지 계산 및 목록 조회
		Pager pager = jobService.getPageList(request);

		// 공통 API 응답 생성
		ApiResponse<Pager> response = ApiResponse.success("役職一覧ページを取得しました", pager);

		return ResponseEntity.ok(response);
	}

}
