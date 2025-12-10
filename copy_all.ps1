<#!
.SYNOPSIS
Copies all non-hidden files from the current folder (B) to a destination folder (A), preserving subfolders and overwriting existing files.

.DESCRIPTION
Recursively enumerates files under the current working directory. Files with the Hidden attribute are excluded. The directory structure is preserved at the destination. Existing files at the destination are overwritten.

.PARAMETER Source
The source folder (B). Files will be copied from this path. Use an absolute or relative path.

.PARAMETER Destination
The destination folder (A). If it does not exist, it will be created. Use an absolute or relative path.

.EXAMPLE
PS C:\Path\To\Anywhere> .\copy_all.ps1 -Source "C:\Path\To\B" -Destination "C:\Path\To\A"
Copies all non-hidden files from `B` (given via -Source) to `A`, preserving subfolders and overwriting files.

.EXAMPLE
PS C:\Path\To\B> .\copy_all.ps1 -Source . -Destination .\backup
Copies from the current directory into a `backup` folder under the current directory.

.NOTES
Hidden files are excluded; files inside hidden directories are included unless those files themselves are hidden.
#>

param(
	[Parameter(Mandatory = $true)]
	[ValidateNotNullOrEmpty()]
	[string]$Source,

	[Parameter(Mandatory = $true)]
	[ValidateNotNullOrEmpty()]
	[string]$Destination
)

# Resolve source path and validate
if (-not (Test-Path -LiteralPath $Source)) {
	throw "Source path not found: $Source"
}

$srcRoot = (Resolve-Path -LiteralPath $Source).Path

# Ensure destination directory exists
if (-not (Test-Path -LiteralPath $Destination)) {
	New-Item -ItemType Directory -Path $Destination -Force | Out-Null
}

# Gather all non-hidden files from the source directory recursively
$files = Get-ChildItem -LiteralPath $srcRoot -Recurse -File -ErrorAction Stop |
	Where-Object { -not ($_.Attributes -band [System.IO.FileAttributes]::Hidden) }

foreach ($file in $files) {
	# Build the relative path under destination, preserving structure
	$relative = $file.FullName.Substring($srcRoot.Length).TrimStart('\')
	$targetPath = Join-Path -Path $Destination -ChildPath $relative
	$targetDir = Split-Path -Path $targetPath -Parent

	if (-not (Test-Path -LiteralPath $targetDir)) {
		New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
	}

	# Overwrite existing files
	Copy-Item -LiteralPath $file.FullName -Destination $targetPath -Force
}

Write-Host "Copied $($files.Count) non-hidden file(s) from '$srcRoot' to '$Destination'."
