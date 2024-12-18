@echo off

REM =============== INITIALIZING ===============
echo =============== INITIALIZING ===============
echo checking git...
git --version >nul 2>&1
if errorlevel 1 (
	echo Git is not installed. Please install Git and try again.
    pause && exit /b
)

rem login username and email
echo login into username and email...
git config --global user.name "Alwi842">nul 2>&1
if errorlevel 1 (
    echo Failed to configure Git username.
    pause && exit /b
)
git config --global user.email "alwi.abdullah1221@gmail.com">nul 2>&1
if errorlevel 1 (
    echo Failed to configure Git email.
    pause && exit /b
)

REM Check if the folder is already a Git repository
echo Checking existing Git repository...
git rev-parse --is-inside-work-tree >nul 2>&1
if not errorlevel 1 (
    echo This folder is already a Git repository.
    set skip_init=1
)
if %skip_init%==1 (
	echo checking existing remote origin...
	git remote get-url origin
	set isOrigin=1
	if errorlevel 1 (
		set isOrigin=0
	)
)
echo initializing succeed
echo ===========================================
echo.

REM =============== User Input ===============
REM check and Prompt for the GitHub repository link
if %isOrigin%==1 (
	git remote get-url origin
	choice /m "Do you want to replace the existing remote 'origin' with the new link? (y/n)"	
	if errorlevel 1 set replace_origin=1
	if errorlevel 2 (
		set replace_origin=0
		set link=""
		goto input2
	)
)
set /p link=Please enter the GitHub repository link: 
if "%link%"=="" (
    echo Repository link cannot be empty. Please try again.
    pause && exit /b
)

:input2
set /p commit_message=Enter your commit message (default: Initial commit): 
if "%commit_message%"=="" set commit_message=Initial commit
echo ===========================================
echo.
echo =============== COMMIT ===============
REM Initialize Git repository
if %skip_init%==0 (
	echo initialize git repository...
	git init -b main >nul 2>&1
	if errorlevel 1 (
		echo Failed to initialize Git repository.
		pause && exit /b
	)
)
REM Add files to staging area
echo adding files...
git add . >nul 2>&1
if errorlevel 1 (
    echo Failed to add files to staging area.
    pause && exit /b
)

REM Commit changes
echo commit the changes...
git commit -m "%commit_message%" >nul 2>&1
if errorlevel 1 (
    echo Commit failed. Ensure there are changes to commit.
    pause && exit /b
)

REM Add remote origin
echo configure remote origin...
if %isOrigin%==0 (
	set init_origin=1
) 
if %isOrigin%==1 (
	if %replace_origin%==1 (
		echo Removing the existing remote 'origin'...
		git remote remove origin >nul 2>&1
		if errorlevel 1 (
			echo Failed to remove the existing remote 'origin'. Please check manually.
			pause && exit /b
		)
		set init_origin=1
	)
)
if %init_origin%==1 (
	echo Adding the new remote 'origin'...
	git remote add origin "%link%" >nul 2>&1
	if errorlevel 1 (
		echo Failed to add the new remote 'origin'. Please check the link and try again.
		pause && exit /b
	)
)
pause
REM Push changes
echo pushing changes...
git push origin main >nul 2>&1
if errorlevel 1 (
    echo Initial push failed. There may be conflicts.
    choice /m "Do you want to force push? (y/n)"
    if errorlevel 2 (
        echo Push canceled.
        pause && exit /b
    )
    git push --force origin main >nul 2>&1
    if errorlevel 1 (
        echo Force push failed. Please resolve issues manually.
        pause && exit /b
    )
)
echo Push successful!
pause