##############################    [!] NOTE [!]    ##############################
# The following two variables are *yours to modify*. The values that these need#
# to contain can be found bt inspecting the URL generated when selecting ????. #
# Everything after these two variables shouldn't be modified unless you know   #
# *exactly* what you are doing.                                                #
##############################    [!] NOTE [!]    ##############################

$clinetID   =   
$ateraID    =   ""

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

Write-Host "PowerShell version is:`t" -NoNewline -ForegroundColor DarkGray
$ver = (Get-Host).Version
if($ver.Major -eq 7 -or $ver.Major -ge 2025){ # Second condition for VSCode
    Write-Host $ver -ForegroundColor Green
} else {
    Write-Host $ver -ForegroundColor Red
    Write-Host "PowerShell 7 (or the VSCode extension v2025 or greater) is 
needed to run (or test) this script" -ForegroundColor Red
    Exit
}

Write-Host "Machine type is...`t" -NoNewline -ForegroundColor DarkGray

if($IsWindows){
    Write-Host "Windows" -ForegroundColor Yellow
    $checkedPaths = @(
        Join-Path "C:" "Program Files"
        Join-Path "C:" "Program Files (x86)"
    )
} elseif ($IsMacOS) {
    Write-Host "macOS" -ForegroundColor Yellow
    # macOS dirs
} else {
    Write-Host "Linux" -ForegroundColor Yellow
    # Linux
}

$notFound = 0
if($IsWindows){
    foreach ($base in $checkedPaths) {
        $path = Join-Path $base $checkFor
        Write-Host "Checking: $path...`t" -NoNewline -ForegroundColor DarkGray
        if(Test-Path $path){
            Write-Host "ok" -ForegroundColor Green
        } else {
            Write-Host "not found" -ForegroundColor Red
            $notFound++
        }
    }
} else {
    $notFound++
}

# If not found, install.

if($notFound){
    Write-Host "ATREA not found or (currently) unable to be searched for." `
    -ForegroundColor DarkRed
}
