#!/usr/bin/env pwsh

pushd $PSScriptRoot
cd ..

if($IsWindows){
    .\bin\win32_main.exe
}
else {
    ./bin/linux_main
}
popd
