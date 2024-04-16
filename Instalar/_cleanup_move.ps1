<#
	.SYNOPSIS
	Este script se encarga de mover las últimas traducciones al workspace de GitHub.
	.DESCRIPTION
    Este script se encarga de mover las últimas traducciones del juego tras haber usado la herramienta de limpieza al directorio desde donde subimos las cosas a GitHub usando VSCode, para evitar tenerlo que hacer manualmente.

    Script creado por Anth (16-4-2024)
	.FUNCTIONALITY
	Para usar este script, asegurate de ponerlo dentro del directorio del juego, al lado del ejecutable del juego, la carpeta "Mods", y la carpeta "Data".
#>

# Adding a default to avoid problems non-english characters (like 'ñ' or 'ç')
$PSDefaultParameterValues.Add("*:Encoding", "utf8")

# Solicitar al usuario que ingrese la ruta de origen y de destino
$origen = ".\Data\$Name\Languages"
$ingame_name = "Spanish (Español(Castellano))"

$destino = Read-Host "Ingrese la ruta de destino (carpeta donde se copiarán los archivos)"

# Verificar si las rutas ingresadas son válidas
if (-not (Test-Path -Path $origen -PathType Container)) {
    Write-Host "La ruta de origen no es válida o la carpeta no existe."
    exit
}
if (-not (Test-Path -Path $destino -PathType Container)) {
    Write-Host "La ruta de destino no es válida o la carpeta no existe."
    exit
}

# Obtener la lista de archivos en la ruta de origen
$archivos = Get-ChildItem -Path $origen

# Copiar cada archivo a la ruta de destino
foreach ($archivo in $archivos) {
    Copy-Item -Path "$origen\$ingame_name" -Destination "$destino" -Recurse
}

Write-Host "¡Archivos copiados exitosamente de $origen\$ingame_name a $destino!"
