@echo off
echo ========================================
echo GitHub 推送助手
echo ========================================
echo.
echo 本地仓库已准备就绪，包含以下提交:
echo   19ec604 Add GitHub push guide
echo   8b643b0 Initial commit: Multi-browser anti-detect setup v3.0
echo.
echo ========================================
echo 步骤 1: 创建 GitHub 仓库
echo ========================================
echo.
echo 1. 访问: https://github.com/new
echo 2. 仓库名: multi-browser-antidetect
echo 3. 可见性: Public
echo 4. 不要勾选 "Initialize this repository with:"
echo 5. 点击 "Create repository"
echo.
pause
echo.
echo ========================================
echo 步骤 2: 输入你的 GitHub 用户名
echo ========================================
echo.
set /p username="GitHub 用户名: "
echo.
echo ========================================
echo 步骤 3: 添加远程仓库并推送
echo ========================================
echo.
git remote add origin https://github.com/%username%/multi-browser-antidetect.git
echo 远程仓库已添加: https://github.com/%username%/multi-browser-antidetect
echo.
echo 正在推送...
git push -u origin master
echo.
if %errorlevel% equ 0 (
    echo ========================================
    echo 推送成功！
    echo ========================================
    echo.
    echo 仓库地址: https://github.com/%username%/multi-browser-antidetect
    echo.
) else (
    echo ========================================
    echo 推送失败
    echo ========================================
    echo.
    echo 可能的原因:
    echo 1. 需要 Personal Access Token 认证
    echo 2. 仓库名已存在
    echo 3. 网络问题
    echo.
    echo 手动推送命令:
    echo   git push -u origin master
    echo.
)
pause
