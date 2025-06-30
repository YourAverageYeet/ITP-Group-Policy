##############################    [!] NOTE [!]    ##############################
# The following three variables are *yours to modify*. The values that these   #
# need to contain can be found bt inspecting the URL generated when selecting  #
# ????. Everything after these two variables shouldn't be modified unless you  #
# know *exactly* what you are doing.                                           #
##############################    [!] NOTE [!]    ##############################

$clientID   =      # fill in
$ateraID    =   "" # fill in
$baseURL    =   "" # fill in

# Determine platform and, from that, assign the following to variables: 
## On Windows:
### The directory we are checking
### The paths to check *in*
## On macOS:
### TODO (I don't own a fruit product)
## On Linux
### The name of the package to grep for (possibly; I need to read the bash
###                                      script to determine what actually
###                                      happens on a Linux install)
#
# Granted, this script probably won't include those paths for a long time, so
# the original platform-checking code has been removed as of 06/30/2025. The
# above outline is kept for reference should either I or someone else deem it
# necessary to add it (back) in. Therefore, the following Windows-only check has
# been added to notify users about this change.

Write-Host "PowerShell version is:`t" -NoNewline -ForegroundColor DarkGray
$ver = (Get-Host).Version
if($ver.Major -eq 7 -or $ver.Major -ge 2025){ # Second condition is for VSCode
    Write-Host $ver -ForegroundColor Green
} else {
    Write-Host $ver -ForegroundColor Red
    Write-Host "PowerShell 7 (or the VSCode extension v2025 or greater) is 
needed to run (or test) this script" -ForegroundColor Red
    Exit 1
}

$noticeBlock = @(
    "`nNOTICE: The cross-platform capabilities of this script have been removed"
    "as of 06/30/2025. If you desire these to be added back in feel free to"
    "open either an issue or a pull request at the URL below:`n"
    "https://github.com/YourAverageYeet/ITP-Group-Policy`n"
)

if(!$IsWindows){
    foreach ($line in $noticeBlock){
        Write-Host $line -ForegroundColor Red
    }
    Exit 1
}

$checkFor = "ATERA Networks"
Write-Host "Checking for $checkFor in:" -ForegroundColor Yellow
$checkedPaths = @(
    Join-Path "C:" "Program Files"
    Join-Path "C:" "Program Files (x86)"
)
foreach ($path in $checkedPaths){
    Write-Host $path
}

$numFound = 0
$expected = $checkedPaths.Length
foreach ($base in $checkedPaths) {
    $path = Join-Path $base $checkFor
    Write-Host "Checking: $path...`t" -NoNewline -ForegroundColor DarkGray
    if(Test-Path $path){
        Write-Host "ok" -ForegroundColor Green
        $numFound++
    } else {
        Write-Host "not found" -ForegroundColor Red
    }
}

# If not found, install.

if($numFound -eq 0){
    Write-Host "ATERA not found or (currently) unable to be searched for." `
    -ForegroundColor DarkRed
} elseif($numFound -gt 0 -and $numFound -lt $expected){
    Write-Host "Broken ATERA install!" -ForegroundColor DarkRed
} else {
    Write-Host "ATERA is already installed!" -ForegroundColor Green
    Exit
}

$strCID = $clientID.ToString()
$saveTop = Join-Path "$env:APPDATA" "GP-ATERA-Temp"
if(!(Test-Path $saveTop)){
    New-Item $saveTop -ItemType Directory -Force
} else {
    Write-Host "$saveTop already exists! Debug exit..." -ForegroundColor Red
    Exit 1
}
$savePath = Join-Path $saveTop "atera.msi"
$downloadURL = $baseURL + "?cid=" + $strCID + "&aid=" + $ateraID
Write-Host "Pulling from: $downloadURL" -ForegroundColor Yellow
Write-Host "Saving to $savePath" -ForegroundColor Yellow
try{
    Invoke-WebRequest $downloadURL -OutFile $savePath
} catch {
    Write-Host "Download failed: $_" -ForegroundColor Red
    Exit 1
}
Start-Process "msiexec" -ArgumentList "/i `"$savePath`"", "/qn" -Wait
Write-Host "ATERA Installed!" -ForegroundColor Green
Write-Host "Now removing $saveTop" -ForegroundColor Yellow
Remove-Item -Force -Recurse $saveTop
