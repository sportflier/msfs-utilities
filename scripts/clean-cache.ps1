# Inspired by https://youtu.be/FkVfVDlrfgk

function Remove-NvidiaSubcache($subfolder){
    $nvidia_cache = $env:USERPROFILE + "/AppData/Local/NVIDIA" + $subfolder
    Remove-AllFiles -folder $nvidia_cache
}

function Remove-AllFiles($folder){
    $files = Get-ChildItem -Path $folder -File

    foreach ($fileItem in $files) {
        try {
            $ErrorActionPreference = "Stop"
            Remove-Item $fileItem.FullName
            Write-Host ("Removed " + $fileItem.FullName) -ForegroundColor Cyan
        }
        catch {
            <#Do this if an exception happens#>
            Write-Host ("Error removing " + $fileItem.FullName) -ForegroundColor Yellow -BackgroundColor Magenta
        }
        finally {
            $ErrorActionPreference = "Continue"
        }
    }

    $subfolders = Get-ChildItem -Path $folder -Directory

    foreach ($subfolder in $subfolders) {
        Remove-AllFiles -folder $subfolder.FullName
    }

}

function Remove-NvidiaCache {
    Remove-NvidiaSubcache -subfolder "/DXCache"
    Remove-NvidiaSubcache -subfolder "/GLCache"
}

$response = Read-Host -Prompt "This script will delete NVIDIA cache files. Press 'Y' to acknowledge and continue"

if($response -eq "Y"){
    Remove-NvidiaCache

    Write-Host "Use Disk Cleanup to clear the DirectX Shader Cache." -ForegroundColor Green
    Start-Process -FilePath CleanMgr.exe     
} else {
    Write-Host "Script aborted." -ForegroundColor Yellow
}

