#!/usr/bin/env pwsh

pushd $PSScriptRoot
cd ..

if($IsWindows){
    .\out\win32_main.exe
}
else {
    ./out/linux_main
}
popd
