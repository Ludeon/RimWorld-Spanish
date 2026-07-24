# Update WordInfo

$PSDefaultParameterValues["*:Encoding"] = "UTF8"

Write-Host "Selecciona el modo de actualización:" -ForegroundColor Cyan
Write-Host "  1. Conservar, ordenar y añadir" -ForegroundColor Green
Write-Host "  2. Auditar palabras aparentemente obsoletas sin borrarlas" -ForegroundColor Yellow
Write-Host "  3. Limpiar, ordenar y añadir" -ForegroundColor Red

do {
    $selection = Read-Host "Elige 1, 2 o 3"
} until ($selection -in "1", "2", "3")

$mode = switch ($selection) {
    "1" { "Add" }
    "2" { "Audit" }
    "3" { "Prune" }
}

# Palabras que deben conservarse aunque no aparezcan en las fuentes examinadas.
# Formato por línea: Expansion|Gender|word|optional reason
$keepFile = Join-Path $PSScriptRoot "wordinfo-keep.txt"
$keepEntries = @()
if (Test-Path $keepFile) {
    $keepEntries = Get-Content $keepFile |
        Where-Object { $_.Trim() -and -not $_.TrimStart().StartsWith("//") } |
        ForEach-Object {
            $parts = $_ -split "\|", 4
            if ($parts.Count -lt 3) {
                Write-Warning "Entrada no válida en wordinfo-keep.txt: $_"
                return
            }
            [PSCustomObject]@{
                Root   = $parts[0].Trim()
                Gender = $parts[1].Trim()
                Word   = $parts[2].Trim()
            }
        }
}

function Test-WordInfoKeepEntry {
    param(
        [string]$Root,
        [string]$Gender,
        [string]$Word
    )

    return [bool]($keepEntries | Where-Object {
        $_.Root -eq $Root -and $_.Gender -eq $Gender -and $_.Word -eq $Word
    } | Select-Object -First 1)
}

# Create a temporary folder
$temp = New-Item "$env:temp\$([GUID]::NewGuid())" -ItemType "Directory"
$auditCandidates = @()
$auditNewWords = @()

# Define all roots: Core + DLCs
$roots = Get-ChildItem -Directory |
         Where-Object { Test-Path "$($_.FullName)\DefInjected" } |
         ForEach-Object { $_.Name }


foreach ($root in $roots) {
    Write-Host "Procesando '$root'..." -ForegroundColor Green

    $main = "$root/WordInfo/Gender"
    if ($mode -ne "Audit") {
        # Create WordInfo/Gender folder only in modes that write changes
        New-Item $main -ItemType "Directory" -Force | Out-Null
    }

    # Paths of the XML files in which the words should be searched
    $paths = @(
        "$root\DefInjected\BackstoryDef"
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
        "$root\DefInjected\PsychicRitualRoleDef"
        "$root\DefInjected\RoyalTitleDef"
        "$root\DefInjected\SitePartDef"
        "$root\DefInjected\TerrainDef"
        "$root\DefInjected\ThingDef"
        "$root\DefInjected\TraderKindDef"
        "$root\DefInjected\WorldObjectDef"
        "$root\DefInjected\RitualBehaviorDef"
        "$root\DefInjected\PlanetLayerDef"
        "$root\DefInjected\RoomRoleDef"
        "$root\DefInjected\SkillDef"
    )

    $generalPattern = "<(.*(labelMale|labelFemale|\.label|\.labelNoLocation|\.pawnSingular|title|titleShort|titleFemale|titleShortFemale|\.chargeNoun|\.customLabel))>(?<value>.*?)</\1>"
    $malePattern = "<(.*(labelMale))>(?<value>.*?)</\1>"
    $femalePattern = "<(.*(\.labelFemale|titleFemale|titleShortFemale))>(?<value>.*?)</\1>"

    # Search words in the XML files and save them in different lists of words depending on their gender
    foreach ($path in $paths) {
        if (-Not (Test-Path $path)) {
            Write-Host "    Saltando '$path' (no existe)" -ForegroundColor Yellow
            continue
        }
        Write-Host "    Procesando '$path'..." -ForegroundColor Blue

        # unknown gender words in $paths
        Get-Content -Path "$path/*" -Filter "*.xml" |
            Select-String -Pattern $generalPattern -All |
            ForEach-Object {
                foreach ($match in $_.Matches) {
                    $match.Groups["value"].Value.ToLower()
                }
            } >> "$temp/all_general1.txt"

        # male gender
        Get-Content -Path "$path/*" -Filter "*.xml" |
            Select-String -Pattern $malePattern -All |
            ForEach-Object {
                foreach ($match in $_.Matches) {
                    $match.Groups["value"].Value.ToLower()
                }
            } >> "$temp/all_males.txt"

        # female gender
        Get-Content -Path "$path/*" -Filter "*.xml" |
            Select-String -Pattern $femalePattern -All |
            ForEach-Object {
                foreach ($match in $_.Matches) {
                    $match.Groups["value"].Value.ToLower()
                }
            } >> "$temp/all_females.txt"
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

    # Audit mode simulates the update without writing anything under WordInfo.
    if ($mode -eq "Audit") {
        $allBases = Get-Content "$temp/all.txt"
        $detectedMales = if (Test-Path "$temp/all_males.txt") { Get-Content "$temp/all_males.txt" } else { @() }
        $detectedFemales = if (Test-Path "$temp/all_females.txt") { Get-Content "$temp/all_females.txt" } else { @() }
        $existingMales = if (Test-Path "$main/Male.txt") { Get-Content "$main/Male.txt" } else { @() }
        $existingFemales = if (Test-Path "$main/Female.txt") { Get-Content "$main/Female.txt" } else { @() }
        $existingNeuters = if (Test-Path "$main/Neuter.txt") { Get-Content "$main/Neuter.txt" } else { @() }

        # Include automatic gender detections in the simulation, as modes 1 and 3 would do.
        $simulatedClassified = @(
            $existingMales
            $existingFemales
            $existingNeuters
            $detectedMales
            $detectedFemales
        ) | Sort-Object -Unique

        foreach ($word in ($allBases | Where-Object { $simulatedClassified -notcontains $_ })) {
            $auditNewWords += [PSCustomObject]@{
                Root = $root
                Word = $word
            }
        }

        foreach ($gender in "Male", "Female", "Neuter") {
            $file = "$main/$gender.txt"
            if (!(Test-Path $file)) { continue }

            foreach ($word in (Get-Content $file)) {
                $isActive = $allBases -contains $word
                if (!$isActive) {
                    foreach ($base in $allBases) {
                        if ($word.StartsWith($base + ' ')) {
                            $isActive = $true
                            break
                        }
                    }
                }
                if (!$isActive) {
                    $auditCandidates += [PSCustomObject]@{
                        Root      = $root
                        Gender    = $gender
                        Word      = $word
                        Protected = Test-WordInfoKeepEntry $root $gender $word
                    }
                }
            }
        }

        Remove-Item "$temp/all*.txt" -Force -ErrorAction SilentlyContinue
        continue
    }

    # Create files
    foreach ($fileName in "Male", "Female", "Neuter", "New_Words") {
        if (!(Test-Path "$main/$fileName.txt")) {
            New-Item -Path $main -Name "$fileName.txt" | Out-Null
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
        Compare-Object @objects -PassThru | Where-Object { $_.SideIndicator -eq "=>" } > "$main/New_Words.txt"
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

    # ==== Conservar, auditar o eliminar palabras obsoletas respetando sufijos ====
    $allBases = Get-Content "$temp/all.txt"
    foreach ($gender in "Male", "Female", "Neuter") {
        $file = "$main/$gender.txt"
        if (Test-Path $file) {
            $current = Get-Content $file
            $obsolete = $current | Where-Object {
                $w = $_
                if ($allBases -contains $w) { return $false }
                foreach ($base in $allBases) {
                    if ($w.StartsWith($base + ' ')) { return $false }
                }
                return $true
            }

            if ($mode -eq "Prune") {
                $filtered = $current | Where-Object {
                    $word = $_
                    ($obsolete -notcontains $word) -or (Test-WordInfoKeepEntry $root $gender $word)
                }
                $filtered | Sort-Object -Unique | Set-Content $file
                Write-Host "    Limpieza aplicada a $root/WordInfo/Gender/$gender.txt" -ForegroundColor DarkRed
            }
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

if ($mode -eq "Audit") {
    Write-Host "====================================================" -ForegroundColor Cyan
    Write-Host "RESUMEN DE AUDITORÍA (no se ha modificado WordInfo)" -ForegroundColor Cyan
    Write-Host "====================================================" -ForegroundColor Cyan

    Write-Host ""
    Write-Host "Palabras candidatas que se agregarán con los modos 1 o 3:" -ForegroundColor Yellow
    if ($auditNewWords.Count -eq 0) {
        Write-Host "  Ninguna." -ForegroundColor DarkGray
    } else {
        foreach ($entry in $auditNewWords) {
            Write-Host "  [candidata] $($entry.Root)|$($entry.Word)"
        }
    }

    Write-Host ""
    Write-Host "Palabras candidatas que se borrarán con el modo 3 (salvo las protegidas):" -ForegroundColor Yellow
    if ($auditCandidates.Count -eq 0) {
        Write-Host "  Ninguna." -ForegroundColor DarkGray
    } else {
        foreach ($entry in $auditCandidates) {
            $status = if ($entry.Protected) { "protegida" } else { "candidata" }
            Write-Host "  [$status] $($entry.Root)|$($entry.Gender)|$($entry.Word)"
        }
    }

    Write-Host ""
    Write-Host "Auditoría finalizada sin cambios en los archivos WordInfo." -ForegroundColor Green
    return
}

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
