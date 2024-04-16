<#
.SYNOPSIS
Este script se encarga de mover las últimas traducciones al workspace de GitHub.
.DESCRIPTION
Este script mueve las últimas traducciones del juego al directorio donde subimos las cosas a GitHub usando VSCode. Evita tener que hacerlo manualmente.

Script creado por Anth (16-4-2024)
.FUNCTIONALITY
Para usar este script, asegúrate de ponerlo dentro del directorio del juego, junto al ejecutable del juego, la carpeta "Mods" y la carpeta "Data".
#>

# Agregamos una codificación predeterminada para evitar problemas con caracteres no ingleses (como 'ñ' o 'ç')
$PSDefaultParameterValues.Add("*:Encoding", "utf8")
$OutputEncoding = [System.Text.Encoding]::UTF8

# Variables
$origen = ".\Data"
$ingame_name = "Spanish (Español(Castellano))"
$destino = "D:\Mega\Traducciones\RimWorld\RimWorld-Spanish"

# Verificar si las rutas ingresadas son válidas
if (-not (Test-Path -Path $origen -PathType Container)) {
    Write-Host "La ruta de origen no es válida o la carpeta no existe."
    exit
}
if (-not (Test-Path -Path $destino -PathType Container)) {
    Write-Host "La ruta de destino no es válida o la carpeta no existe."
    exit
}

# Obtener la lista de carpetas en la ruta de origen
$carpetas = Get-ChildItem -Path $origen -Directory

# Copiar cada carpeta a la ruta de destino
foreach ($carpeta in $carpetas) {
    $origenCarpeta = Join-Path -Path $origen -ChildPath "$($carpeta.Name)\Languages\$ingame_name"
    $destinoCarpeta = Join-Path -Path $destino -ChildPath $carpeta.Name
    Copy-Item -Path $origenCarpeta\* -Destination $destinoCarpeta -Recurse
}

Write-Host "¡Archivos copiados de $origen a $destino!"
Write-Host "Presiona la tecla Escape para salir..."
do {
    $tecla = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
} while ($tecla.VirtualKeyCode -ne 27)
