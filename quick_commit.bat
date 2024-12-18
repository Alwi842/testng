@echo off
echo init..
git --version >nul 2>&1
if errorlevel 1 (
	echo Git is not installed. Please install Git and try again.
    exit /b
)
echo done
echo.

rem login username and email
echo login into username and email...
git config --global user.name "Alwi842">nul 2>&1
if errorlevel 1 (
    echo Failed to configure Git username.
    exit /b
)
git config --global user.email "alwi.abdullah1221@gmail.com">nul 2>&1
if errorlevel 1 (
    echo Failed to configure Git email.
    exit /b
)
echo login success
echo.

REM Prompt for the GitHub repository link
set /p link=Please enter the GitHub repository link: 
if "%link%"=="" (
    echo Repository link cannot be empty. Please try again.
    exit /b
)
REM Initialize Git repository
echo initialize git repository...
git init -b main >nul 2>&1
if errorlevel 1 (
    echo Failed to initialize Git repository.
    exit /b
)
REM Add files to staging area
echo adding files...
git add . >nul 2>&1
if errorlevel 1 (
    echo Failed to add files to staging area.
    exit /b
)

REM Commit changes
echo commit the changes...
git commit -m "Initial commit" >nul 2>&1
if errorlevel 1 (
    echo Commit failed. Ensure there are changes to commit.
    exit /b
)

REM Add remote origin
echo add remote origin...
git remote add origin "%link%" >nul 2>&1
if errorlevel 1 (
    echo Failed to add remote repository. Check the link and try again.
    exit /b
)
REM Push changes
echo pushing changes...
git push origin main >nul 2>&1
if errorlevel 1 (
    echo Initial push failed. There may be conflicts.
    choice /m "Do you want to force push? (y/n)"
    if errorlevel 2 (
        echo Push canceled.
        exit /b
    )
    git push --force origin main >nul 2>&1
    if errorlevel 1 (
        echo Force push failed. Please resolve issues manually.
        exit /b
    )
)
echo Push successful!
pause