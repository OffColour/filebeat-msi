
REM https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.3.1-windows-x86_64.zip


"C:\Program Files (x86)\WiX Toolset v3.11\bin\heat.exe" dir "Z:\WIX\Filebeat\source" -cg FilebeatFiles -gg -scom -sreg -sfrag -srd -dr INSTALLLOCATION  -var "var.FilebeatFilesDir" -t "FragmentTransform.xslt" -out "FilesFragment.wxs"
"C:\Program Files (x86)\WiX Toolset v3.11\bin\candle.exe" "filebeat.wxs" -arch x64
"C:\Program Files (x86)\WiX Toolset v3.11\bin\candle.exe" "FilesFragment.wxs" -arch x64
"C:\Program Files (x86)\WiX Toolset v3.11\bin\light.exe" -v filebeat.wixobj FilesFragment.wixobj -o filebeat.msi