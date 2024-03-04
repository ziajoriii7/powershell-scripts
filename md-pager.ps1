# to make this script work:
# > pipx install rich-cli 

param(
	[string]$FilePath
)

if (Test-Path $FilePath) {
	rich $FilePath --hyperlinks --theme perldoc --markdown --pager
} else {
	Write-Error "$FilePath was not found."
}
