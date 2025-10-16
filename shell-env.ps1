#!/usr/bin/env pwsh

$tools = Join-Path $PSScriptRoot "tools"
$pathSep = [System.IO.Path]::PathSeparator
$env:PATH = "$tools$pathSep$env:PATH"

if ($IsWindows -eq $false) {
    Write-Host "Setting up environment for Linux..."

    if (-not (Get-Command gcc -ErrorAction SilentlyContinue)) {
        Write-Host "gcc missing — install build tools:"
        Write-Host "sudo apt update && sudo apt install -y build-essential"
        exit 1
    }

    if (-not (Get-Command gdb -ErrorAction SilentlyContinue)) {
        Write-Host "gdb missing — install:"
        Write-Host "sudo apt update && sudo apt install -y gdb"
        exit 1
    }
}
else {
    echo "Setting up environment for win32..."

    pushd > $null # vswhere changes the dir

    $vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
    $vsPath  = & $vswhere -latest -products * `
        -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 `
        -property installationPath

    if(Test-Path($vsPath) -eq $false){
        "Visual studio not found, is it installed?"
        exit 1
    }

    Import-Module "$vsPath\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
    Enter-VsDevShell -VsInstallPath $vsPath -Arch amd64 > $null

    popd > $null

    cd $PSScriptRoot
    code .
}

echo "Done"
