$destpath = "C:\Program Files\Mozilla Firefox\distribution"

if (-not (Test-Path -LiteralPath $destpath)) {
    New-Item -ItemType Directory -Path $destpath -Force | Out-Null
}

Invoke-WebRequest  -Uri "https://raw.githubusercontent.com/HimadriChakra12/.dotfiles/refs/heads/master/firefox/policies.json"  -OutFile "$destpath\policies.json"

Write-Host "Select Firefox Profile:"

$configpath = "$env:APPDATA\Mozilla\Firefox\Profiles"
$profile = Get-ChildItem -Name -Directory $configpath | fzf

if (-not $profile) {
    exit
}

$path = "$configpath\$profile"

Write-Host "Using profile: $path"

$dotfiles = @(
    @{
        Source = "$pwd\chrome"
        Path   = "$path\chrome"
    },
    @{
        Source = "$pwd\user.js"
        Path   = "$path\user.js"
    }
)

foreach ($dotfile in $dotfiles) {
    if (Test-Path -LiteralPath $dotfile.Path) {
        Remove-Item -LiteralPath $dotfile.Path -Force -Recurse
    }

    New-Item  -ItemType SymbolicLink  -Path $dotfile.Path  -Target $dotfile.Source  | Out-Null
}

