# Download latest FIDO release from github

# powershell -command "& {Set-ExecutionPolicy -Scope LocalMachine Unrestricted -Force}"

# start "" powershell -command .\Fido.ps1

# :: Return the security policy to defaults, restricted...
# powershell -command "& {Set-ExecutionPolicy -Scope LocalMachine Restricted -Force}"
# powershell -command "& {Set-ExecutionPolicy -Scope CurrentUser Undefined -Force}"
# powershell -command "& {Set-ExecutionPolicy -Scope Process Undefined -Force}"



# https://github.com/pbatard/Fido/releases/latest/download/Fido.ps1.lzma'

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# Set-ExecutionPolicy -Scope LocalMachine Unrestricted -Force

$repo = "pbatard/Fido"
$file = "Fido.ps1.lzma"

$releases = "https://api.github.com/repos/$repo/releases"

Write-Host Determining latest release
$tag = (Invoke-WebRequest $releases | ConvertFrom-Json)[0].tag_name

$download = "https://github.com/$repo/releases/download/$tag/$file"
$name = $file.Split(".")[0]
# $zip = "$name-$tag.zip"
$zip = "$name-$tag.lzma"
$dir = "$name-$tag"

Write-Host Dowloading latest release
Invoke-WebRequest $download -Out $zip

# Write-Host Extracting release files
# Expand-Archive only works with zip files
# Expand-Archive $zip -Force

# # Cleaning up target dir
# Remove-Item $name -Recurse -Force -ErrorAction SilentlyContinue

# # Moving from temp dir to target dir
# Move-Item $dir\$name -Destination $name -Force

# # Removing temp files
# Remove-Item $zip -Force
# Remove-Item $dir -Recurse -Force

# :: Return the security policy to defaults, restricted...
# powershell -command "& {Set-ExecutionPolicy -Scope LocalMachine Restricted -Force}"
# powershell -command "& {Set-ExecutionPolicy -Scope CurrentUser Undefined -Force}"
# powershell -command "& {Set-ExecutionPolicy -Scope Process Undefined -Force}"
# Set-ExecutionPolicy -Scope LocalMachine Restricted -Force
# Set-ExecutionPolicy -Scope CurrentUser Undefined -Force
# Set-ExecutionPolicy -Scope Process Undefined -Force