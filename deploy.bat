@echo off
chcp 65001 > nul
echo ========================================================
echo [3학년 시간모의고사] GitHub Pages 자동 배포 스크립트
echo ========================================================
echo.

set PATH=C:\Program Files\Git\cmd;C:\Program Files\GitHub CLI;%PATH%

echo 1. GitHub 로그인 상태를 확인합니다...
gh auth status > nul 2>&1
if %errorlevel% neq 0 (
    echo [안내] GitHub에 로그인이 필요합니다.
    echo 브라우저를 통한 인증을 시작합니다. (Enter를 눌러 진행하세요)
    echo.
    gh auth login -p https -w
)

echo.
echo 2. 최신 변경사항을 커밋합니다...
git add .
git commit -m "Update mock exam scheduler" > nul 2>&1

echo.
echo 3. GitHub 원격 저장소를 생성하고 푸시합니다...
gh repo create mock-exam-scheduler --public --source=. --remote=origin --push > nul 2>&1
if %errorlevel% neq 0 (
    echo 이미 존재하는 저장소이므로 최신 코드를 푸시합니다...
    git push -u origin main
)

echo.
echo 4. GitHub Pages(웹 호스팅)를 활성화합니다...
for /f "tokens=*" %%i in ('gh api user --jq .login') do set GH_USER=%%i

gh api -X POST "repos/%GH_USER%/mock-exam-scheduler/pages" -f "source[branch]=main" -f "source[path]=/" > nul 2>&1

echo.
echo ========================================================
echo [배포 완료!]
echo 배포된 웹사이트 주소 (1~2분 후 접속 가능):
echo https://%GH_USER%.github.io/mock-exam-scheduler/
echo ========================================================
echo.
pause
