# Inspired by https://youtu.be/FkVfVDlrfgk

$nvidia_cache_root = $env:USERPROFILE + "\AppData\Local\NVIDIA"

function Get-Keypress(){
    Read-Host
}

function Remove-NvidiaSubcache($subfolder){
    $nvidia_cache = $nvidia_cache_root + $subfolder
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
            Write-Host ("Error removing " + $fileItem.FullName) -ForegroundColor Red
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

Write-Host ("This script will delete NVIDIA cache files (will recursively delete files in " + $nvidia_cache_root + ").") -ForegroundColor Cyan
Write-Host ("Press 'Y' to acknowledge and continue:") -ForegroundColor Yellow

$KeyPress = Get-Keypress

if($KeyPress -eq "Y" || $KeyPress -eq "y"){
    Remove-NvidiaCache

    Write-Host "Use Disk Cleanup to clear the DirectX Shader Cache." -ForegroundColor Green
    Start-Process -FilePath CleanMgr.exe     
} else {
    Write-Host "Script aborted." -ForegroundColor Cyan
    return
}

