# Flutter Blog (Riverpod) 프로젝트 문서 (JIYUN)

이 프로젝트는 Flutter + Riverpod(NotifierProvider)를 사용해 **로그인/자동로그인(세션)** 과 **게시글 목록/상세/작성/수정 화면**의 기본 골격을 구성한 예제입니다.  
네트워크는 `dio`, 로컬 토큰 저장은 `flutter_secure_storage`를 사용합니다.

---

## 1) 프로젝트 구조 (요약)

```
lib/
  main.dart
  splash_page.dart
  _core/
    constants/ (move, size, theme)
    utils/     (my_device, my_http, validator_util)
  data/
    model/      (User, Post)
    repository/ (UserRepository, PostRepository)
    gvm/        (SessionGVM, SessionUser)
  ui/
    pages/
      auth/ (login/join)
      post/ (list/detail/write/update)
    widgets/ (공용 위젯 모음)
```

---

## 2) 앱 흐름 (화면/라우팅)

1. `SplashPage`에서 스플래시를 보여준 뒤 `LoginPage`로 이동
2. `LoginBody`에서 `SessionGVM.autoLogin()`을 호출해 저장된 토큰으로 자동 로그인 시도
3. 로그인 성공 시 `Move.postListPage`로 이동
4. `PostListVM`이 게시글 목록을 로딩하고 `PostListBody`가 리스트를 렌더링

라우팅은 `lib/_core/constants/move.dart`의 `Move`와 `getRouters()`에 정의되어 있습니다.

---

## 3) 클래스별 설명 & 주요 코드 포인트

아래는 프로젝트에 정의된 **주요 클래스**들과 역할/핵심 코드 흐름입니다.

### 3.1 앱 엔트리/네비게이션

#### `MyApp` (`lib/main.dart`)
- 역할: 앱 엔트리 위젯. `ProviderScope`로 Riverpod 범위를 구성하고 `MaterialApp` 설정을 담당합니다.
- 주요 코드:
  - `navigatorKey`: 전역 네비게이션 컨텍스트 확보(세션/VM에서 화면 이동에 사용)
  - `routes: getRouters()`: 라우트 테이블 등록
  - `theme: theme()`: 공통 테마 적용

#### `Move` (`lib/_core/constants/move.dart`)
- 역할: 라우트 경로 상수 모음 + 라우트 매핑 함수 제공.
- 주요 코드:
  - `static String ...`: 라우트 이름(예: `Move.loginPage`, `Move.postListPage`)
  - `Map<String, Widget Function(BuildContext)> getRouters()`: 라우트 → 화면 위젯 매핑

#### `SplashPage` / `_SplashPageState` (`lib/splash_page.dart`)
- 역할: 스플래시 화면 표시 후 로그인 화면으로 전환.
- 주요 코드:
  - `initState()`에서 `Future.delayed(Duration(seconds: 5), ...)`
  - `Navigator.pushReplacement(...)`로 `LoginPage`로 교체 이동

---

### 3.2 공통 상수/유틸

#### `theme()` / `appBarTheme()` (`lib/_core/constants/theme.dart`)
- 역할: 앱 테마 설정(현재는 AppBar 스타일 중심).
- 주요 코드:
  - `ThemeData(appBarTheme: appBarTheme())`
  - `AppBarTheme(...)`로 타이틀/배경/정렬 설정

#### 화면/간격 유틸 (`lib/_core/constants/size.dart`)
- 역할: UI에서 자주 쓰는 gap 상수 및 화면/드로어 폭 계산.
- 주요 코드:
  - `smallGap/mediumGap/largeGap/xlargeGap`
  - `getScreenWidth(context)`, `getDrawerWidth(context)`

#### HTTP 설정 (`lib/_core/utils/my_http.dart`)
- 역할: `dio` 전역 인스턴스 및 API `baseUrl` 설정.
- 주요 코드:
  - `final dio = Dio(BaseOptions(...))`
  - `validateStatus: (status) => true`로 HTTP status가 에러여도 응답을 받도록 구성

#### 디바이스 보안 저장소 (`lib/_core/utils/my_device.dart`)
- 역할: JWT 토큰 등의 민감 정보를 저장하는 `secureStorage` 제공.
- 주요 코드:
  - `final secureStorage = FlutterSecureStorage();`

#### 입력값 검증 유틸 (`lib/_core/utils/validator_util.dart`)
- 역할: 폼에서 사용할 validator 함수 팩토리 모음.
- 주요 코드:
  - `validateUsername()/validatePassword()/validateEmail()/validateTitle()/validateContent()`
  - 각 함수는 `(String? value) { ... return String? }` 형태의 validator를 반환

---

### 3.3 데이터 모델 (DTO)

#### `User` (`lib/data/model/user.dart`)
- 역할: 사용자 응답 데이터를 Dart 객체로 표현.
- 주요 코드:
  - `User.fromMap(Map<String,dynamic> m)`: 서버 응답(Map)을 필드로 매핑
  - `createdAt/updatedAt`을 `DateFormat(...).parse(...)`로 `DateTime?` 변환

#### `Post` (`lib/data/model/post.dart`)
- 역할: 게시글 응답 데이터를 Dart 객체로 표현.
- 주요 코드:
  - `Post.fromMap(...)`: `user = User.fromMap(m["user"])`로 중첩 객체 파싱
  - `bookmarkCount` 등 게시글 메타데이터 포함

---

### 3.4 Repository (API 호출)

#### `UserRepository` (`lib/data/repository/user_repository.dart`)
- 역할: 로그인/자동로그인 관련 API 호출을 캡슐화.
- 주요 코드:
  - 싱글톤: `static final instance` + private 생성자 `UserRepository._single()`
  - `login(username, password)`: `dio.post("/login", data: {...})`
  - `autoLogin(accessToken)`: `dio.post("/auto/login", options: Options(headers: {...}))`

#### `PostRepository` (`lib/data/repository/post_repository.dart`)
- 역할: 게시글 목록 등 게시글 관련 API 호출을 캡슐화.
- 주요 코드:
  - 싱글톤 패턴 동일
  - `getPosts({int page = 0})`: `dio.get("/api/post?page=$page")`

---

### 3.5 상태 관리 (Riverpod Notifier)

#### `SessionUser` (`lib/data/gvm/session_gvm.dart`)
- 역할: 앱 전역에서 참조하는 “현재 로그인 세션” 상태 모델.
- 주요 코드:
  - `isLogin` 플래그로 로그인 여부 표현
  - `SessionUser.fromMap(...)`으로 서버 응답을 세션 상태로 변환

#### `SessionGVM` (`lib/data/gvm/session_gvm.dart`)
- 역할: 로그인/자동로그인/로그아웃을 수행하고 `SessionUser` 상태를 갱신하는 전역 VM.
- 주요 코드:
  - `build()`에서 초기 상태 `SessionUser()` 반환
  - `autoLogin()`:
    - `secureStorage.read(key: "accessToken")`로 토큰 읽기
    - 성공 시 `state = SessionUser.fromMap(...)`로 상태 갱신
    - `dio.options.headers["Authorization"]`에 토큰 세팅
    - `Navigator.popAndPushNamed(..., Move.postListPage)`로 화면 이동
  - `login(username, password)`:
    - API 호출 → `state` 갱신 → `secureStorage.write(...)` 저장 → `dio` 헤더 세팅 → 게시글 목록 이동
  - `logout()`:
    - `state` 초기화 → 토큰 삭제 → `dio` 헤더 초기화

#### `sessionProvider` (`lib/data/gvm/session_gvm.dart`)
- 역할: `SessionGVM`을 전역에서 읽고/감시하기 위한 Provider.
- 주요 코드:
  - `final sessionProvider = NotifierProvider<SessionGVM, SessionUser>(...)`

#### `PostListModel` (`lib/ui/pages/post/list_page/post_list_vm.dart`)
- 역할: 게시글 목록 페이지의 상태 모델(페이지네이션 정보 + posts 리스트).
- 주요 코드:
  - `PostListModel.fromMap(...)`에서 `posts = (m["posts"] as List).map((e) => Post.fromMap(e)).toList()`

#### `PostListVM` (`lib/ui/pages/post/list_page/post_list_vm.dart`)
- 역할: 게시글 목록을 로딩하여 `PostListModel?` 상태로 제공.
- 주요 코드:
  - `build()`에서 `init()` 호출 후 초기 `null` 반환(로딩 상태 표현)
  - `init({page})`에서 `postRepository.getPosts()` 호출 후 `state = PostListModel.fromMap(...)`

#### `postListProvider` (`lib/ui/pages/post/list_page/post_list_vm.dart`)
- 역할: `PostListVM` Provider.
- 주요 코드:
  - `final postListProvider = NotifierProvider<PostListVM, PostListModel?>(...)`

---

### 3.6 화면(Page) / 위젯(Widget)

#### `LoginPage` (`lib/ui/pages/auth/login_page/login_page.dart`)
- 역할: 로그인 화면의 Scaffold 구성(바디 위젯을 분리해 둠).
- 주요 코드:
  - `body: LoginBody()`

#### `LoginBody` (`lib/ui/pages/auth/login_page/widgets/login_body.dart`)
- 역할: 로그인 화면 레이아웃 + 자동로그인 트리거.
- 주요 코드:
  - `ref.read(sessionProvider.notifier).autoLogin();`로 자동로그인 시도
  - `LoginForm()` + 회원가입 이동 버튼 구성

#### `LoginForm` (`lib/ui/pages/auth/login_page/widgets/login_form.dart`)
- 역할: 로그인 입력 폼(아이디/비밀번호) 및 로그인 액션 수행.
- 주요 코드:
  - `TextEditingController`로 입력 관리
  - `SessionGVM gvm = ref.read(sessionProvider.notifier);`
  - 로그인 버튼에서 `await gvm.login(_username.text.trim(), _password.text.trim());`

#### `JoinPage` / `JoinBody` / `JoinForm`
- 위치: `lib/ui/pages/auth/join_page/...`
- 역할: 회원가입 화면 구성(현재는 UI/검증 로직 중심).
- 주요 코드:
  - `JoinForm`에서 `validateUsername/validateEmail/validatePassword`로 validator 연결
  - 가입 버튼 액션(`funPageRoute`)은 현재 비어 있음(추후 API 연동 필요)

#### `PostListPage` (`lib/ui/pages/post/list_page/post_list_page.dart`)
- 역할: 게시글 목록 화면의 Scaffold + Drawer 네비게이션 제공.
- 주요 코드:
  - `drawer: CustomNavigation(scaffoldKey)`
  - `SessionUser sessionUser = ref.read(sessionProvider);`로 사용자 정보 표시

#### `PostListBody` (`lib/ui/pages/post/list_page/wiegets/post_list_body.dart`)
- 역할: 게시글 목록 상태를 감시하고 리스트 렌더링.
- 주요 코드:
  - `PostListModel? model = ref.watch(postListProvider);`
  - `model == null`이면 `CircularProgressIndicator()` 표시
  - `ListView.separated`로 게시글 항목 출력

#### `PostListItem` (`lib/ui/pages/post/list_page/wiegets/post_list_item.dart`)
- 역할: 게시글 리스트 1개 아이템 UI.
- 주요 코드:
  - `Image.network("$baseUrl${post.user.imgUrl}")`로 프로필 이미지 표시
  - `TextOverflow.ellipsis`로 본문 한 줄 요약

#### `PostDetailPage` / `PostDetailBody` / `PostDetailTitle` / `PostDetailProfile` / `PostDetailContent` / `PostDetailButtons`
- 위치: `lib/ui/pages/post/detail_page/...`
- 역할: 게시글 상세 화면 UI를 작은 위젯으로 분리해 구성.
- 주요 코드:
  - `PostDetailButtons`에서 수정 버튼 클릭 시 `PostUpdatePage`로 이동
  - 삭제 버튼 액션은 현재 비어 있음(추후 API 연동 필요)

#### `PostWritePage` / `PostWriteBody` / `PostWriteForm`
- 위치: `lib/ui/pages/post/write_page/...`
- 역할: 게시글 작성 폼.
- 주요 코드:
  - `CustomTextFormField` + `CustomTextArea` + validator(제목/내용)
  - 작성 버튼에서 `_formKey.currentState!.validate()`로 검증

#### `PostUpdatePage` / `PostUpdateBody` / `PostUpdateForm`
- 위치: `lib/ui/pages/post/update_page/...`
- 역할: 게시글 수정 폼(기본값 입력 지원).
- 주요 코드:
  - `CustomTextFormField(initValue: ...)`, `CustomTextArea(initValue: ...)`
  - 검증 성공 시 `Navigator.pop(context)`로 이전 화면 복귀

---

### 3.7 공용 UI 컴포넌트 (`lib/ui/widgets/*`)

#### `CustomNavigation` (`lib/ui/widgets/custom_navigator.dart`)
- 역할: Drawer 메뉴(글쓰기/로그아웃).
- 주요 코드:
  - 글쓰기: `Navigator.pushNamed(context, Move.postWritePage)`
  - 로그아웃: `ref.read(sessionProvider.notifier).logout()` 후 로그인 화면으로 이동

#### `CustomLogo` (`lib/ui/widgets/custom_logo.dart`)
- 역할: SVG 로고 + 타이틀 텍스트.
- 주요 코드:
  - `SvgPicture.asset("assets/logo.svg")`

#### `CustomElevatedButton` (`lib/ui/widgets/custom_elavated_button.dart`)
- 역할: 공통 버튼 스타일 + 클릭 콜백 주입.
- 주요 코드:
  - `onPressed: funPageRoute`
  - `ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50), ...)`

#### `CustomTextButton` (`lib/ui/widgets/custom_text_button.dart`)
- 역할: 밑줄 스타일의 텍스트 버튼.
- 주요 코드:
  - `TextButton(onPressed: function, child: Text(...))`

#### `CustomAuthTextFormField` (`lib/ui/widgets/custom_auth_text_form_field.dart`)
- 역할: 인증 화면용 입력 필드(라벨 + TextFormField).
- 주요 코드:
  - `TextFormField(controller: controller, obscureText: obscureText, ...)`
  - 현재 `validator` 연결이 주석 처리되어 있어 검증이 적용되지 않음(확장 포인트)

#### `CustomTextFormField` (`lib/ui/widgets/custom_text_form_field.dart`)
- 역할: 일반 입력 필드(초기값(initValue) 지원).
- 주요 코드:
  - `controller.text = initValue!`로 초기값 세팅(수정 화면에서 사용)
  - `validator: funValidator`

#### `CustomTextArea` (`lib/ui/widgets/custom_text_area.dart`)
- 역할: 여러 줄 입력(본문 입력).
- 주요 코드:
  - `maxLines: 10`
  - `controller.text = initValue`로 초기값 세팅

#### `CustomBottomIconButton` (`lib/ui/widgets/custom_bottom_icon_button.dart`)
- 역할: 아이콘 + 텍스트 형태의 하단 버튼 UI(레이아웃 전용).
- 주요 코드:
  - `Column(children: [Icon(...), Text(...)])`

#### `CustomRoundIconButton` (`lib/ui/widgets/custom_round_icon_button.dart`)
- 역할: 원형 테두리 아이콘 UI(레이아웃 전용).
- 주요 코드:
  - `BoxDecoration(shape: BoxShape.circle, border: Border.all(...))`

---

## 4) 확장/개선 포인트 (메모)

- 회원가입(`JoinForm`)은 UI/검증만 있고 API 호출/상태관리가 아직 연결되지 않았습니다.
- 게시글 상세/작성/수정/삭제는 현재 UI 중심이며, 실제 API 연동 및 상태관리(상세 데이터 전달 등)가 추가로 필요합니다.
- `CustomAuthTextFormField`의 validator가 주석 처리되어 있어(현재 상태 기준) 로그인 폼 검증이 적용되지 않습니다.


