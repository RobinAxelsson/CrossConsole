#!/usr/bin/env pwsh

$tools = Join-Path $PSScriptRoot "tools"
$pathSep = [System.IO.Path]::PathSeparator  # ';' on Win, ':' on Unix
$env:PATH = "$tools$pathSep$env:PATH"

if($IsWindows -eq $false){
    Write-Host "Setting up environment for Linux..."
}
else {
    echo "Setting up environment for win32..."

    pushd > $null # vswhere changes the dir

    $vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
    $vsPath  = & $vswhere -latest -products * `
        -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 `
        -property installationPath

    Import-Module "$vsPath\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
    Enter-VsDevShell -VsInstallPath $vsPath -Arch amd64 > $null

    popd > $null

    cd $PSScriptRoot
    code .
}

echo "Done"