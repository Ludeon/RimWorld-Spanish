# Script para ordenar alfabéticamente todos los archivos .txt dentro de subcarpetas,
# excepto los indicados en la lista de excepciones
$PSDefaultParameterValues.Add("*:Encoding", "utf8")
$base = $PSScriptRoot

# Lista de excepciones (nombres de archivo exactos, sin ruta). Por ahora no hay, pero por si más adelante usamos otros txt.
$excepciones = @(
    "",
    ""
)

# Encuentra archivos .txt dentro de las carpetas
$archivosTXT = Get-ChildItem -Recurse -Filter *.txt -File

if ($archivosTXT.Count -eq 0) {
    Write-Host "No se han encontrado archivos .txt en subcarpetas." -ForegroundColor Yellow
    exit
}

foreach ($archivo in $archivosTXT) {
    if ($excepciones -contains $archivo.Name) {
        Write-Host "⏭ Excluido por nombre: $($archivo.Name)" -ForegroundColor DarkYellow
        continue
    }

    $ruta = $archivo.FullName
    $lineas = Get-Content -Path $ruta -Encoding UTF8

    if ($lineas.Count -eq 0) {
        Write-Host "Archivo vacío (omitido): $([System.IO.Path]::GetRelativePath($base, $ruta))" -ForegroundColor DarkGray
        continue
    }

    # Separar líneas ignoradas y las que deben ordenarse
    $resultado = @()
    $bloqueOrdenable = @()

    foreach ($linea in $lineas) {
        if ($linea -match '^\s*/') {
            # Si hay un bloque pendiente de ordenar, lo ordenamos antes de añadir esta línea
            if ($bloqueOrdenable.Count -gt 0) {
                $resultado += ($bloqueOrdenable | Sort-Object)
                $bloqueOrdenable = @()
            }
            $resultado += $linea
        } else {
            $bloqueOrdenable += $linea
        }
    }

    # Si al final queda algo sin ordenar, lo ordenamos y lo añadimos
    if ($bloqueOrdenable.Count -gt 0) {
        $resultado += ($bloqueOrdenable | Sort-Object)
    }

    # Guardar archivo
    [System.IO.File]::WriteAllLines($ruta, $resultado, [System.Text.Encoding]::UTF8)
    Write-Host "✔ Ordenado: $([System.IO.Path]::GetRelativePath($base, $ruta))" -ForegroundColor Green
}

Write-Host "`nProceso completado." -ForegroundColor Cyan
