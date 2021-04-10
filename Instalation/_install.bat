:: Download the Repository
curl -LJO https://github.com/Ludeon/RimWorld-Spanish/archive/refs/heads/master.zip

:: Extract the zip file
powershell Expand-Archive Rimworld-Spanish-master.zip -DestinationPath .\

:: Delete the old zip file
del .\RimWorld-Spanish-master.zip

:: Make folders for the languages
mkdir .\Data\Core\Languages\"(GitHub) Spanish"
mkdir .\Data\Royalty\Languages\"(GitHub) Spanish"

:: Copy the files to the corresponding directories
xcopy .\RimWorld-Spanish-master\Core\* .\Data\Core\Languages\"(GitHub) Spanish"\ /E /Y
xcopy .\RimWorld-Spanish-master\Royalty\* .\Data\Royalty\Languages\"(GitHub) Spanish"\ /E /Y

:: Delete the uncompressed files
rmdir .\RimWorld-Spanish-master /S /Q

:: End of Batch File