$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$Repo = if ($env:YOOFLOE_REPO) { $env:YOOFLOE_REPO } else { 'yoofloe/yoofloe-cli-releases' }

$arch = switch ($env:PROCESSOR_ARCHITECTURE) {
    'ARM64' { 'arm64' }
    default { 'x64' }
}

$asset = "yoofloe-windows-$arch.exe"
$url = "https://github.com/$Repo/releases/latest/download/$asset"
$installDir = if ($env:YOOFLOE_INSTALL_DIR) {
    $env:YOOFLOE_INSTALL_DIR
} else {
    Join-Path $env:LOCALAPPDATA 'Programs\Yoofloe\bin'
}

$tmpFile = Join-Path ([System.IO.Path]::GetTempPath()) $asset

function Download-ReleaseAsset {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Uri,
        [Parameter(Mandatory = $true)]
        [string]$OutFile
    )

    $curl = Get-Command curl.exe -ErrorAction SilentlyContinue
    if ($curl) {
        & $curl.Source --fail --location --retry 3 --silent --show-error $Uri --output $OutFile
        if ($LASTEXITCODE -eq 0 -and (Test-Path -LiteralPath $OutFile)) {
            return
        }
    }

    Invoke-WebRequest -UseBasicParsing -Uri $Uri -OutFile $OutFile
}

Write-Host "Downloading $asset from $url"
Download-ReleaseAsset -Uri $url -OutFile $tmpFile

New-Item -ItemType Directory -Force -Path $installDir | Out-Null
$targetPath = Join-Path $installDir 'yoofloe.exe'
Copy-Item $tmpFile $targetPath -Force

function Add-ToUserPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$PathEntry
    )

    $currentUserPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    $entries = @()

    if ($currentUserPath) {
        $entries = $currentUserPath.Split(';') | Where-Object { $_ }
    }

    if ($entries -contains $PathEntry) {
        return $false
    }

    $updatedEntries = @($entries + $PathEntry)
    [Environment]::SetEnvironmentVariable('Path', ($updatedEntries -join ';'), 'User')
    return $true
}

$pathUpdated = Add-ToUserPath -PathEntry $installDir
if ($pathUpdated -and -not (($env:Path -split ';') -contains $installDir)) {
    $env:Path = "$env:Path;$installDir"
}

Write-Host "Installed yoofloe to $targetPath"
if ($pathUpdated) {
    Write-Host "Added $installDir to the user PATH."
} else {
    Write-Host "$installDir is already in the user PATH."
}
Write-Host "Open a new terminal if 'yoofloe' is not found in the current session."
