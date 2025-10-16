#!/usr/bin/env pwsh

pushd $PSScriptRoot
cd ..

if($IsWindows){
    start win32_main.sln
}
else {
    echo "Not implimented for linux"
}
popd
