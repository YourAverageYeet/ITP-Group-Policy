# This is an "infini-run" wrapper script around the cmdlets found in ./parts
# Each is run with dot sourcing so that variables can shared between them and/or
# modified as need be.

# Connect to local network (Connect-LocalNetwork)

# Read all present objects (Get-AlreadyPresent)

# Store as "Already Installed" (Save-FoundObjects)

# Start looping

## Scan for new/un-policied objects on network (Find-NewObjects)

## If a (set of) new object(s) is found:

### Decide on necessary MSI to download (Select-NeededMSI)

### Download MSI (Receive-NeededMsi)

### Run/Install MSI (Install-DownloadedMsi)
    ### (Will be referencing Chocolatey for this...)

### Start installed application if not autostarted (Start-InstalledApp)

### Remove downloaded MSI to free up space (Remove-DownloadedMsi)

## Else / After IF: Loop
