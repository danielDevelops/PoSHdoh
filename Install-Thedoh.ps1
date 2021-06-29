try {
	Test-Path $env:PSModulePath.Split(';')[0] | Out-Null
	$dst = (Join-Path $env:PSModulePath.Split(';')[0] PoShdoh)
} catch {
	$dst = "$env:ProgramFiles\WindowsPowerShell\Modules\PoShdoh"
}
$pfk = (Join-Path $env:temp "poshdoh.zip")

md $dst -ea silentlycontinue

[Net.ServicePointManager]::SecurityProtocol = "tls12"
Invoke-WebRequest 'https://github.com/danielDevelops/PoShdoh/archive/master.zip' -OutFile $pfk

$shell = New-Object -ComObject Shell.Application; $shell.Namespace($dst).copyhere(($shell.NameSpace($pfk)).items(),20)

Move-Item "$dst\PoShdoh-master\*" "$dst" -Force
Remove-Item "$dst\PoShdoh-master" -Recurse -Force
Remove-Item $pfk -Force

if ($null -eq $profile -or (-not(Test-Path $profile))) {
	Write-Output "Import-Module PoShdoh" | Out-File $profile -Force -encoding utf8
	Write-Output "Created $profile"
} elseif ( -not(Select-String -Path $profile -Pattern "Import-Module PoShdoh")) {
	Write-Output "`nImport-Module PoShdoh" | Out-File $profile -Append -encoding utf8
	Write-Output "Added PoShdoh to profile"
}

Import-Module PoShdoh

Write-Output "Installation complete."
