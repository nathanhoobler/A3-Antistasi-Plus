$root = $PSScriptRoot;

$buildFolder = "C:\Program Files (x86)\Steam\steamapps\common\Arma 3\MPMissions";

$devFolderItem = Get-ChildItem -Path ".\Map-Templates\Antistasi-Khe-Sanh.vn_khe_sanh" | Select-Object -First 1;
$devFolder = $devFolderItem.parent;

$mainDataPath = Join-Path $root 'A3-Antistasi';
$stringTablePath = Join-Path $root 'A3-Antistasi\Stringtable.xml';

$stringTable = New-Object -TypeName XML;
$stringTable.Load($stringTablePath);

$versionId = $stringTable.Project.Package.Container | Where-Object { $_.name -eq "credits_generic" } | ForEach-Object {$_.Key} | Where-Object {$_.ID -eq "STR_antistasi_plus_credits_generic_version_text"} | ForEach {$_.Original};
$formattedVersionId = $versionId.Split("\.") -join "-";

$folderName = $devFolder.Name;
$pair = $folderName.Split("\.");
$missionFolderName = $pair[0] + "-" + $formattedVersionId + "-" + "Plus" + "-" + "dev" + "." + $pair[1]; 
$destinationPath = $(Join-Path $buildFolder $missionFolderName);

Remove-Item $destinationPath -Recurse -ErrorAction Ignore;

Copy-Item -Path $mainDataPath -Destination $destinationPath -Recurse;
Copy-Item -Path $(Join-Path $devFolder.FullName "*") -Destination $destinationPath -Recurse -Force;