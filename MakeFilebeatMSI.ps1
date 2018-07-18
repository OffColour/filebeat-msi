
# https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.3.1-windows-x86_64.zip


Param(
    [parameter(Mandatory=$true)]
    [string] $filebeatURL
    )

[Environment]::CurrentDirectory = $PSScriptRoot

$wixbinpath = 'C:\Program Files (x86)\WiX Toolset v3.11\bin\'
$wixbuildpath = $PSScriptRoot + '\build\'
$wixsourcefilespath = $PSScriptRoot + '\source\'
$filebeatzipname = Split-Path -Path $filebeatURL -Leaf
$zipfoldername = $filebeatzipname.Substring(0, $filebeatzipname.lastIndexOf('.'))

New-Item -ItemType Directory -Force -Path $wixbuildpath
Invoke-WebRequest -Uri $filebeatURL -OutFile $wixbuildpath$filebeatzipname
Expand-Archive $wixbuildpath$filebeatzipname -DestinationPath $PSScriptRoot -Force
Rename-Item -Path $PSScriptRoot'\'$zipfoldername -NewName "source"

$newProductID = New-Guid
$newProductID = $newProductID.ToString()
$parts = $zipfoldername.split('-')
$filebeatversion = $parts[1]


start-process -filepath $wixbinpath"heat.exe" -ArgumentList "dir", $wixsourcefilespath, "-cg FilebeatFiles -gg -scom -sreg -sfrag -srd -dr INSTALLLOCATION  -var `"var.FilebeatFilesDir`" -t", $PSScriptRoot"\FragmentTransfom.xslt", "-out", $wixbuildpath"FilesFragment.wxs" -NoNewWindow -Wait
start-process -filepath $wixbinpath"candle.exe" -ArgumentList "filebeat.wxs", "-dProductID=$newProductID", "-dVersion=$filebeatversion"," -arch x64 -out", $wixbuildpath -NoNewWindow -Wait
start-process -filepath $wixbinpath"candle.exe" -ArgumentList $wixbuildpath"FilesFragment.wxs -arch x64 -out", $wixbuildpath -NoNewWindow -Wait
start-process -filepath $wixbinpath"light.exe" -ArgumentList "-v", $wixbuildpath"filebeat.wixobj", $wixbuildpath"FilesFragment.wixobj", "-o",$wixbuildpath"filebeat.msi" -NoNewWindow -Wait

Remove-Item $wixsourcefilespath -Force -Recurse
Remove-Item $wixbuildpath -Exclude "filebeat.msi" -Force -Recurse