# Update WordInfo

$PSDefaultParameterValues["*:Encoding"] = "UTF8"

# Create a temporary folder
$temp = New-Item "$env:temp\$([GUID]::NewGuid())" -ItemType "Directory"

# Define all roots: Core + DLCs
$roots = Get-ChildItem -Directory |
         Where-Object { Test-Path "$($_.FullName)\DefInjected" } |
         ForEach-Object { $_.Name }


foreach ($root in $roots) {
    Write-Host "Procesando '$root'..." -ForegroundColor Green

    # Create WordInfo/Gender folder
    $main = New-Item "$root/WordInfo/Gender" -ItemType "Directory" -Force

    # Paths of the XML files in which the words should be searched
    $paths = @(
        "$root\DefInjected\BodyDef"
        "$root\DefInjected\BodyPartDef"
        "$root\DefInjected\BodyPartGroupDef"
        "$root\DefInjected\ChemicalDef"
        "$root\DefInjected\FactionDef"
        "$root\DefInjected\GameConditionDef"
        "$root\DefInjected\HediffDef"
        "$root\DefInjected\LandmarkDef"
        "$root\DefInjected\MapGeneratorDef"
        "$root\DefInjected\PawnKindDef"
        "$root\DefInjected\PreceptDef"
        "$root\DefInjected\RoyalTitleDef"
        "$root\DefInjected\SitePartDef"
        "$root\DefInjected\TerrainDef"
        "$root\DefInjected\ThingDef"
        "$root\DefInjected\WorldObjectDef"
        "$root\DefInjected\RoomRoleDef"
        "$root\DefInjected\SkillDef"
    )

    # Search words in the XML files and save them in different lists of words depending on their gender
    foreach ($path in $paths) {
        if (-Not (Test-Path $path)) {
            Write-Host "    Saltando '$path' (no existe)" -ForegroundColor Yellow
            continue
        }
        Write-Host "    Procesando '$path'..." -ForegroundColor Blue

        # unknown gender in $paths
        Get-Content -Path "$path/*" -Filter "*.xml" |
            Select-String -Pattern "<(.*(\.label|\.pawnSingular|title|titleShort|\.chargeNoun|\.customLabel))>(.*?)</\1>" -All |
            ForEach-Object { $_.Matches.Groups[3].Value.ToLower() } >> "$temp/all_unknown1.txt"

        # male gender
        Get-Content -Path "$path/*" -Filter "*.xml" |
            Select-String -Pattern "<(.*(labelMale))>(.*?)</\1>" -All |
            ForEach-Object { $_.Matches.Groups[3].Value.ToLower() } >> "$temp/all_males.txt"

        # female gender
        Get-Content -Path "$path/*" -Filter "*.xml" |
            Select-String -Pattern "<(.*(\.labelFemale|titleFemale|titleShortFemale))>(.*?)</\1>" -All |
            ForEach-Object { $_.Matches.Groups[3].Value.ToLower() } >> "$temp/all_females.txt"
    }

    # add season names (if not, they are auto-deleted)
    if (Test-Path "$root\Keyed\Time.xml") {
        Get-Content -Path "$root\Keyed\Time.xml" |
            Select-String -Pattern "<(Season.*)>(.*?)</\1>" -All |
            ForEach-Object { $_.Matches.Groups[2].Value.ToLower() } >> "$temp/all_unknown1.txt"
    }

    # unknown gender in ResearchProjectDef
    $researchPath = "$root\DefInjected\ResearchProjectDef\"
    if (Test-Path $researchPath) {
        Get-ChildItem -Path "$researchPath*" -Filter "*.xml" | ForEach-Object {
            $fileContent = Get-Content -Raw -Path $_.FullName
            [regex]::Matches($fileContent, 'generalRules\.rulesStrings.*?(?:\s*<li>subject->(.*?)<\/li>)+') | ForEach-Object {
                $_.Groups[1].Captures.Value.ToLower() | Out-File -FilePath "$temp/all_unknown2.txt" -Append
            }
        }
    }

    # Save a list of all found words
    Get-Content "$temp/all*.txt" | Sort-Object -Unique | Set-Content "$temp/all.txt"

    # Create files
    foreach ($fileName in "Male", "Female", "Neuter", "New_Words") {
        if (!(Test-Path "$main/$fileName.txt")) {
            New-Item -Path $main -Name "$fileName.txt"
        }
    }

    # Merge found male words into the list of male words
    Get-Content "$temp/all_males.txt", "$main/Male.txt" | Sort-Object -Unique | Set-Content "$main/Male.txt"

    # Merge found female words into the list of female words
    Get-Content "$temp/all_females.txt", "$main/Female.txt" | Sort-Object -Unique | Set-Content "$main/Female.txt"

    # Sort neuter
    foreach ($fileName in "Neuter") {
        if (Test-Path "$main/$fileName.txt") {
            Get-Content "$main/$fileName.txt" | Sort-Object -Unique | Set-Content "$main/$fileName.txt"
        }
    }

    # Save a list of words already classified
    Get-Content (Get-ChildItem -Path "$main/*" -Include "Male.txt", "Female.txt", "Neuter.txt") |
        Sort-Object -Unique | Set-Content "$temp/wordinfo.txt"

    # Save a list of words not classified
    $objects = @{
        ReferenceObject  = (Get-Content -Path "$temp/wordinfo.txt")
        DifferenceObject = (Get-Content -Path "$temp/all.txt")
    }
    if ($objects.ReferenceObject -and $objects.DifferenceObject) {
        Compare-Object @objects -PassThru | Where-Object { $_.SideIndicator -eq "=>" } > "$main/New_words.txt"
    }

    # ==== Eliminar de New_Words.txt las ya clasificadas automáticamente ====
    # Leemos New_Words y los listados de género
    $newList     = Get-Content "$main/New_Words.txt"
    $classified  = Get-Content "$main/Male.txt", "$main/Female.txt", "$main/Neuter.txt"
    # Filtramos para quitar de New_Words cualquier elemento que esté ya en male/female/neuter
    $cleanNew = $newList | Where-Object { $classified -notcontains $_ }
    # Sobrescribimos New_Words.txt
    $cleanNew | Sort-Object -Unique | Set-Content "$main/New_Words.txt"

    # ==== Borrar New_Words.txt si no contiene texto útil ====
    if (-Not (Get-Content "$main/New_Words.txt" | Where-Object { $_.Trim() -ne "" })) {
        Remove-Item "$main/New_Words.txt" -Force
        Write-Host "    New_Words.txt eliminado (vacío)" -ForegroundColor DarkGray
    }

    # ==== Eliminar palabras obsoletas respetando sufijos ====
    $allBases = Get-Content "$temp/all.txt"
    foreach ($gender in "Male", "Female", "Neuter") {
        $file = "$main/$gender.txt"
        if (Test-Path $file) {
            $current = Get-Content $file
            $filtered = $current | Where-Object {
                $w = $_
                if ($allBases -contains $w) { return $true }
                foreach ($base in $allBases) {
                    if ($w.StartsWith($base + ' ')) { return $true }
                }
                return $false
            }
            $filtered | Sort-Object -Unique | Set-Content $file
        }
    }

    # Limpiar temporales parciales para evitar duplicados entre bucles
    Remove-Item "$temp/all*.txt" -Force -ErrorAction SilentlyContinue
}

# Delete the temporary folder
Write-Host ""
Write-Host "Eliminando archivos temporales..." -ForegroundColor Yellow
Write-Host ""
Remove-Item -Recurse $temp -Force

Write-Host "====================================================" -ForegroundColor Green
Write-Host "✓ Todos los archivos se han procesado correctamente." -ForegroundColor Green
Write-Host "====================================================" -ForegroundColor Green

Write-Host "Revisa el archivo 'New_Words.txt' y mueve cada palabra a:" -ForegroundColor Cyan
Write-Host "  - Female.txt   → Palabras con artículo femenino (ej. 'la mesa')" -ForegroundColor Yellow
Write-Host "  - Male.txt     → Palabras con artículo masculino (ej. 'el coche')" -ForegroundColor Yellow
Write-Host "  - Neuter.txt   → Verbos en infinitivo o sustantivos en plural (ej. 'cantar', 'libros')" -ForegroundColor Yellow
Write-Host ""
Write-Host "Importante: Debes mover palabras a cada archivo dependiendo del GÉNERO DEL ARTÍCULO que precede a la palabra." -ForegroundColor Magenta
Write-Host "   Ejemplo: Aunque la palabra 'agua' es femenina, se dice 'el agua' en singular, así que va a Female.txt." -ForegroundColor Magenta
Write-Host ""
Write-Host "Proceso finalizado." -ForegroundColor Gray
