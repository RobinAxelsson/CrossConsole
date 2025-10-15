#!/usr/bin/env pwsh

if($IsWindows -eq $false){
    Write-Error "Windows environment is required"
    exit 1
}

$tools = Join-Path $PSScriptRoot "tools"

echo "Setting up environment for win32..."
$env:PATH = "$tools\;$env:PATH"

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

echo "Done"