# Fix all Hugo compatibility issues

Write-Host "Starting Hugo compatibility fixes..."

# 1. Fix date formats in all content files
Write-Host "Fixing date formats..."
$contentFiles = Get-ChildItem -Path "content" -Filter "*.md" -Recurse
$dateFixed = 0

foreach ($file in $contentFiles) {
    $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
    if ($content) {
        $updated = $false
        
        # Fix Hugo template date format
        if ($content -match 'date: \{\{\.PublishDate\.Format') {
            $content = $content -replace 'date: \{\{\.PublishDate\.Format "July 3, 2025"\}\}', 'date: "2025-07-03"'
            $updated = $true
        }
        
        # Fix R date format if still exists
        if ($content -match '`r Sys\.Date\(\)`') {
            $content = $content -replace 'date\s*:\s*"`r Sys\.Date\(\)`"', 'date: "2025-07-03"'
            $updated = $true
        }
        
        if ($updated) {
            Set-Content -Path $file.FullName -Value $content -NoNewline
            $dateFixed++
            Write-Host "  Fixed: $($file.Name)"
        }
    }
}

# 2. Fix deprecated .Site.IsMultiLingual in theme
Write-Host "Fixing deprecated theme functions..."
$themeFiles = Get-ChildItem -Path "themes\hugo-theme-learn\layouts" -Filter "*.html" -Recurse -ErrorAction SilentlyContinue
$themeFixed = 0

foreach ($file in $themeFiles) {
    $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
    if ($content -and $content -match '\.Site\.IsMultiLingual') {
        $content = $content -replace '\.Site\.IsMultiLingual', 'hugo.IsMultilingual'
        Set-Content -Path $file.FullName -Value $content -NoNewline
        $themeFixed++
        Write-Host "  Fixed: $($file.Name)"
    }
}

# 3. Update config.toml for newer Hugo
Write-Host "Updating config.toml..."
$configPath = "config.toml"
if (Test-Path $configPath) {
    $config = Get-Content $configPath -Raw
    
    # Add markup configuration for newer Hugo
    if ($config -notmatch '\[markup\]') {
        $markupConfig = @"

[markup]
  [markup.goldmark]
    [markup.goldmark.renderer]
      unsafe = true
  [markup.highlight]
    style = "github"
    lineNos = true
"@
        $config += $markupConfig
        Set-Content -Path $configPath -Value $config -NoNewline
        Write-Host "  Updated config.toml with markup settings"
    }
}

Write-Host ""
Write-Host "Summary:"
Write-Host "  Date formats fixed: $dateFixed files"
Write-Host "  Theme functions fixed: $themeFixed files"
Write-Host "  Config updated: Yes"
Write-Host ""
Write-Host "Hugo compatibility fixes completed!"
Write-Host "Try running: hugo server"