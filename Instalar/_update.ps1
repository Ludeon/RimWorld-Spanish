<#
	.SYNOPSIS
	Este script se encarga de instalar/actualizar las ultimas traducciones.
	.DESCRIPTION
	Este script se encarga de instalar/actualizar las traducciones del juego a las traducciones mas recientes disponibles para la traduccion al Español (Castellano) directamente desde los repositorios oficiales.
	
	Originalmente desarrollado por Xeros08 (Aser Granado Amores).

	.FUNCTIONALITY
	Para usar este script, asegurate de ponerlo dentro del directorio del juego, al lado del ejecutable del juego, la carpeta "Mods", y la carpeta "Data".
#>


# Adding a default to avoid problems non-english characters (like 'ñ' or 'ç')
$PSDefaultParameterValues.Add("*:Encoding", "utf8")

# Variables to use
$repo_owner = "Ludeon"
$official_repo = "RimWorld-Spanish"
$branch = "master"

$ingame_name = "Spanish (Español(Castellano))"


# Function declarations


function DownloadGithubRepo {
	<#
		.SYNOPSIS
		Descarga el repositorio de Github indicado.

		.DESCRIPTION
		Descarga el repositorio de Github indicado como un zip y lo extrae/descomprime.
		Al terminar borra el zip para ahorrar espacio.

		.PARAMETER Owner
		Especifica el dueño del repositorio.

		.PARAMETER Repo 
		Especifica el repositorio.
		
		.PARAMETER Branch
		Especifica la rama a descargar. Por defecto es "master".
	#>

	param(
		[Parameter(Mandatory=$True)] 
		[string]$Owner,

		[Parameter(Mandatory=$True)] 
		[string]$Repo,

		[Parameter(Mandatory=$False)] 
		[string]$Branch = "master"
	)

	# Create the download link for the repo using GitHub's REST API
	$repo_url = "https://api.github.com/repos/$Owner/$Repo/zipball/$Branch"

	# Create the zip file 
	$zip_file = ".\$Owner-$Repo-$Branch.zip"
	New-Item $zip_file -ItemType File -Force

	# Download the repo
	Invoke-RestMethod -Uri $repo_url -OutFile $zip_file

	# Extract the zip file
	Expand-Archive -Path $zip_file -DestinationPath ".\" -Force
	Remove-Item -Path $zip_file -Force
}


function UpdateContent {
	<#
		.SYNOPSIS
		Actualiza las traducciones del contenido oficial indicado.

		.DESCRIPTION
		Borra las traducciones anteriormente descargadas (si las hay) y copia las nuevas desde el repositorio local.

		.PARAMETER LocalRepo 
		Ruta al repositorio local desde el cual se quiere importar las traducciones de este contenido.
		
		.PARAMETER Name
		Especifica el contenido oficial al que actualizar las traducciones.

		.EXAMPLE
		UpdateContent -LocalRepo "Ludeon-RimWorld-Spanish" -Name "Core"

	#>
	param (
		[Parameter(Mandatory=$True)] 
		[string]$LocalRepo,

		[Parameter(Mandatory=$True)] 
		[string]$Name
	)

	# Create the path to that Content's languages folder
	$translations_folder = ".\Data\$Name\Languages"
	if (!(Test-Path $translations_folder)) { return } # IF you don't have the content or doesn't exist, skip.

	# If the old .tar is present, remove them
	if (Test-Path "$translations_folder\$ingame_name.tar") {
		Remove-Item "$translations_folder\$ingame_name.tar" -Force
	}

	# If there are old translation files, remove them
	if (Test-Path "$translations_folder\$ingame_name") {
		Remove-Item "$translations_folder\$ingame_name" -Force -Recurse
	}

	# Copy the new translations
	Copy-Item -Path ".\$LocalRepo\$Name" -Destination "$translations_folder\$ingame_name" -Recurse
}




# Script's Entrypoint 

DownloadGithubRepo -Owner $repo_owner -Repo $official_repo -Branch $branch

# Rename de directory of the repo to match the format (owner-repo)
$local_repo = "$repo_owner-$official_repo"
Get-ChildItem -Name -Directory ".\" -Filter "$local_repo*" | Select-Object -First 1 | Rename-Item -NewName $local_repo -Force

# Update the game's translation files with those from the downloaded repo
UpdateContent -LocalRepo $local_repo -Name "Core"
UpdateContent -LocalRepo $local_repo -Name "Royalty"
UpdateContent -LocalRepo $local_repo -Name "Ideology"
UpdateContent -LocalRepo $local_repo -Name "Biotech"

# Delete the downloaded repo
Remove-Item -Recurse -Force ".\$local_repo"