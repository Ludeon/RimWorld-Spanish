# Este script recorre todas las carpetas dentro de "Data" y elimina el archivo
# "Languages\Spanish (Español(Castellano)).tar" si existe dentro de cada una.

# Debe situarse en la carpeta raíz del juego.

$base = Join-Path $PSScriptRoot "Data"

foreach ($carpeta in Get-ChildItem -Path $base -Directory) {
    $rutaTar = Join-Path $carpeta.FullName "Languages\Spanish (Español(Castellano)).tar"

    if (Test-Path $rutaTar) {
        Write-Host "¿Quieres eliminar el archivo?: $rutaTar"
        Remove-Item -Path $rutaTar
    } else {
        Write-Host "Archivo no encontrado: $rutaTar"
    }
}

Write-Host "`nProceso completado." -ForegroundColor Cyan
Write-Host "Presiona Enter para salir..." -ForegroundColor Gray
Read-Host