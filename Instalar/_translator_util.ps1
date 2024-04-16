<#
	.SYNOPSIS
	Este script se encarga de vincular las traducciones de tu repositorio local con el juego.
	.DESCRIPTION
	Este script se encarga de crear los enlaces simbólicos necesarios para vincular los ficheros del juego a las traducciones de tu repositorio local, para hacer el proceso de traducción más sencillo y liviano.
	
	Originalmente desarrollado por Xeros08 (Aser Granado Amores).

	.FUNCTIONALITY
	Para usar este script, asegurate de ponerlo dentro del directorio del juego, al lado del ejecutable del juego, la carpeta "Mods", y la carpeta "Data".
#>


#WARNING: Save file with "Windows-1252" encoding
# Adding a default to avoid problems non-english characters (like 'ñ' or 'ç')
$PSDefaultParameterValues.Add("*:Encoding", "utf8")

# Variables to use
$ingame_name = "Spanish (Español(Castellano))"
$example_path = "C:/Translations/RimWorld-Spanish"


function LinkTranslationFiles {
    <#
		.SYNOPSIS
		Vincula las traducciones del contenido oficial indicado.

		.DESCRIPTION
		Borra las traducciones actuales de los ficheros del juego y las reemplaza por un enlace simbolico al repositorio local.

        .PARAMETER LocalRepoPath
		Especifica la ruta al repositorio local.

		.PARAMETER Name
		Especifica el contenido oficial al que actualizar las traducciones.

		.EXAMPLE
		LinkTranslationFiles -Name "Core"

	#>
	param (
        [Parameter(Mandatory=$True)] 
		[string]$LocalRepoPath,
		[Parameter(Mandatory=$True)] 
		[string]$Name
	)
    
    # Create the path to that Content's languages folder
    $translations_folder = ".\Data\$Name\Languages\$ingame_name"

    # Delete original translations
    if (Test-Path "$translations_folder.tar") {
		Remove-Item "$translations_folder.tar" -Force
	}

    # Delete old patched translations
    if (Test-Path "$translations_folder") {
		Remove-Item "$translations_folder" -Force
	}

    # Create new link
    New-Item -ItemType Junction -Path $translations_folder -Target "$LocalRepoPath\$Name"
}


function ValidateLocalRepoPath {
    <#
		.SYNOPSIS
		Valida que la ruta sea valida.

		.DESCRIPTION
		Comprueba que la ruta de a la carpeta del repositorio local sea válida, revisando que exista una carpeta .git, lo cual indica que la carpeta es un repositorio.

		.PARAMETER Path
		Especifica la ruta a la carpeta de tu repositorio local.

		.EXAMPLE
		ValidateLocalRepoPath -Path $example_path

	#>
    param (
		[Parameter(Mandatory=$True)] 
		[string]$Path
	)

    $result = $false

    # Check the path exists and is a directory
    if (Test-Path -PathType Container "$Path") {
        # Check that there's a .git subfolder, which indicates it's a github repo
        if (Test-Path -PathType Container "$Path\.git") {
            $result = $true
        }
    } 
    else {
        
    }

    return $result
    
}


function Get-Folder {
    <#
		.SYNOPSIS
		Le solicita al usuario una carpeta.

		.DESCRIPTION
		Solicita al usuario una carpeta y la devuelve

		.PARAMETER DefaultLocation
		Especifica la ruta a abrir por defecto.

		.EXAMPLE
		ValidateLocalRepoPath -Path $example_path

	#>
    param (
		[Parameter(Mandatory=$False)] 
		[string]$DefaultLocation = $null
	)
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

    # Create a folder selection dialog
    $parent = New-Object System.Windows.Forms.Form -Property @{TopMost = $true; TopLevel = $true }
    $folderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderDialog.Description = "Elige la carpeta donde se encuentra tu repositorio local"
    $folderDialog.SelectedPath = [Environment]::GetFolderPath('Desktop')

    # Load default location
    if ($DefaultLocation) {
        if (Test-Path -PathType Container "$DefaultLocation") {
            $folderDialog.SelectedPath = $DefaultLocation
        }
    }

    # Check a folder was selected
    if($folderDialog.ShowDialog($parent) -eq "OK") {
        $folder = $folderDialog.SelectedPath
    }

    return $folder
}


function AskLocalRepoPath {
    $done = $false
    $folder = $null
    $temp_path = $null

    # Keep asking for a path until it's valid
    while ($done -eq $false){
        $temp_path = Get-Folder -DefaultLocation $temp_path
        
        # If use selected a folder
        if ($temp_path) {
            # If folder is valid, save
            if (ValidateLocalRepoPath -Path $temp_path) {
                $folder = $temp_path
                $done = $true
            }
        }

        # User canceled operation
        else {
            $done = $true
        }
    }

    return $folder
}


###### EXECUTION START ######

$local_repo = AskLocalRepoPath


if (-not ($local_repo -eq $null)) {
    LinkTranslationFiles -LocalRepoPath $local_repo -Name "Core"
    LinkTranslationFiles -LocalRepoPath $local_repo -Name "Royalty"
    LinkTranslationFiles -LocalRepoPath $local_repo -Name "Ideology"
    LinkTranslationFiles -LocalRepoPath $local_repo -Name "Biotech"
    LinkTranslationFiles -LocalRepoPath $local_repo -Name "Anomaly"

    Write-Host "Finalizado"
}
else {
    Write-Host "Cancelado"
}