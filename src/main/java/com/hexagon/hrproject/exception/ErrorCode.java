package com.hexagon.hrproject.exception;

import lombok.Getter;

/* 열거형: 상수를 객체 차원으로 사용할 수 있는 자료형
		public static final int x=5;
		상수  = 복합 데이터(예외의 이름, 예외의 메시지.., Http Status code 200)
		Color.RED, Color.Yellow, HttpStatus.OK
*/

@Getter
public enum ErrorCode {

	// 부서 관련 상수
	DEPARTMENT_NOT_FOUND(404, "DEPARTMENT_NOT_FOUND", "部署名を入力してください。"),
	DEPARTMENT_NAME_REQUIRED(404, "DEPARTMENT_NAME_REQUIRED", "部署名が見つかりません。"),
	DEPARTMENT_REGIST_FAIL(500, "DEPARTMENT_REGIST_FAIL", "部署が見つかりません。"),
	DEPARTMENT_UPDATE_FAIL(500, "DEPARTMENT_UPDATE_FAIL", "部署情報の更新に失敗しました。"),
	DEPARTMENT_DELETE_FAIL(500, "DEPARTMENT_DELETE_FAIL", "部署の無効化に失敗しました。"),
	DEPARTMENT_ALREADY_EXISTS(409, "DEPARTMENT_ALREADY_EXISTS", "部署はすでに存在します。 登録できません。"),

	// 직급 관련 상수
	JOB_NOT_FOUND(404, "JOB_NOT_FOUND", "役職が見つかりません。"), JOB_NAME_REQUIRED(400, "JOB_NAME_REQUIRED", "役職名を入力してください。"),
	JOB_REGIST_FAIL(500, "JOB_REGIST_FAIL", "役職の登録に失敗しました。"),
	JOB_UPDATE_FAIL(500, "JOB_UPDATE_FAIL", "役職情報の更新に失敗しました。"),
	JOB_DELETE_FAIL(500, "JOB_DELETE_FAIL", "役職の無効化に失敗しました。"),
	JOB_ALREADY_INACTIVE(409, "JOB_ALREADY_INACTIVE", "この役職はすでに無効になっています。"),
	JOB_INACTIVE_UPDATE(409, "JOB_INACTIVE_UPDATE", "無効な役職は編集できません。"),
	JOB_CODE_GENERATION_FAIL(500, "JOB_CODE_GENERATION_FAIL", "役職コードの生成に失敗しました。"),
	JOB_ALREADY_EXISTS(409, "JOB_ALREADY_EXISTS", "役職はすでに存在します。 登録できません。"),

	UNAUTHORIZED_DEPARTMENT_ACCESS(500, "DEPARTMENT_NOT_FOUND", "この部署へのアクセス権限がありません。"),

	// 사원 관련
	EMPLOYEE_NOT_FOUND(404, "EMPLOYEE_NOT_FOUND", "社員情報が見つかりません。"),
	EMPLOYEE_NAME_REQUIRED(400, "EMPLOYEE_NAME_REQUIRED", "社員の氏名を入力してください。"),
	EMPLOYEE_EMAIL_REQUIRED(400, "EMPLOYEE_EMAIL_REQUIRED", "メールアドレスを入力してください。"),
	EMPLOYEE_EMAIL_INVALID(400, "EMPLOYEE_EMAIL_INVALID", "メールアドレスの形式が正しくありません。"),
	EMPLOYEE_REGIST_FAIL(500, "EMPLOYEE_REGIST_FAIL", "社員の登録に失敗しました。"),
	EMPLOYEE_UPDATE_FAIL(500, "EMPLOYEE_UPDATE_FAIL", "社員情報の更新に失敗しました。"),
	EMPLOYEE_RETIRE_FAIL(409, "EMPLOYEE_RETIRE_FAIL", "社員を退職扱いにできません。"),

	// 계정 관련
	ACCOUNT_NOT_FOUND(404, "ACCOUNT_NOT_FOUND", "アカウントが見つかりません。"),
	PASSWORD_REQUIRED(400, "PASSWORD_REQUIRED", "パスワードを入力してください。"),
	CURRENT_PASSWORD_MISMATCH(400, "CURRENT_PASSWORD_MISMATCH", "現在のパスワードが一致しません。"),
	PASSWORD_TOO_SHORT(400, "PASSWORD_TOO_SHORT", "新しいパスワードは 8文字以上である必要があります。"),
	PASSWORD_SAME_AS_CURRENT(400, "PASSWORD_SAME_AS_CURRENT", "現在のパスワードとは異なるパスワードを入力してください。"),
	PASSWORD_UPDATE_FAIL(500, "PASSWORD_UPDATE_FAIL", "パスワードの変更に失敗しました。"),
	LOGIN_ID_REQUIRED(400, "LOGIN_ID_REQUIRED", "ログイン IDを入力してください。"),
	LOGIN_ID_DUPLICATED(409, "LOGIN_ID_DUPLICATED", "すでに使用されているログイン IDです。"),

	// 로그인 상태 관련
	LOGIN_REQUIRED(401, "LOGIN_REQUIRED", "ログインが必要です。"),
	EMPLOYEE_ACCOUNT_NOT_LINKED(404, "EMPLOYEE_ACCOUNT_NOT_LINKED", "アカウントに社員情報が紐付いていません。"),

	INVALID_INPUT(500, "INVALID_INPUT", "アクセスできません。");

	private final int status; // HTTP Status code 200, 500 등등..
	private final String code; // 에러코드
	private final String message; // 에러 메시지 ex) "등록 실패입니다."

	private ErrorCode(int status, String code, String message) {
		this.status = status;
		this.code = code;
		this.message = message;
	}

}
