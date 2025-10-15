#!/usr/bin/env pwsh

pushd $PSScriptRoot
cd ..

if($Windows){
    .\out\win32_main.exe
}
else {
    ./out/linux_main
}
popd
