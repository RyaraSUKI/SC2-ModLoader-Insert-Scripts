Write-Host -ForegroundColor White "-----------------------------------------------"
Write-Host -ForegroundColor Yellow "欢迎使用 SugarCube2 ModLoader 注入脚本！"
Write-Host -ForegroundColor Blue "By：RyaraSUKI，由GPT协助改写为power shell脚本"
Write-Host -ForegroundColor Cyan "本工具用于自动向你的Twine项目中注入ModLoader"
Write-Host -ForegroundColor Red "请确保你已经阅读并理解了使用说明中的所有内容！"
Write-Host -ForegroundColor Red "警告：这个脚本只是帮助Twine发布的文件进行注入的，如果你使用了tweego，请按照语雀教程来手动注入（我相信会用tweego了那肯定会那个教程的"
Write-Host -ForegroundColor White "-----------------------------------------------`n"

do {
    $userInput = Read-Host "是否开始运行？(y/n)"
    if ($userInput -ieq "n") {
        Write-Host "已取消操作，关闭窗口……"
        Start-Sleep -Seconds 2
        exit
    }
    elseif ($userInput -ieq "y") {
        break
    }
    else {
        Write-Host "请输入 y 或 n ！[y为确认，n为取消并退出]"
    }
} while ($true)

# 上传文件
do {
    $filePath = Read-Host "请将 .twee 或 .html 文件拖到此窗口后按回车"
    if (-not (Test-Path $filePath)) {
        Write-Host "文件不存在，请重新上传！"
        continue
    }

    $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
    if ($ext -ne ".twee" -and $ext -ne ".html") {
        Write-Host "请选择正确的格式！[.twee 或 .html]"
        continue
    }

    break
} while ($true)

# 获取文件名
$sourceName = [System.IO.Path]::GetFileName($filePath)
$sourceBase = [System.IO.Path]::GetFileNameWithoutExtension($filePath)
$sourceExt = [System.IO.Path]::GetExtension($filePath)

# 复制并重命名文件
Copy-Item -Path $filePath -Destination . -Force | Out-Null
if ($sourceExt -ieq ".twee") {
    Rename-Item -Path $sourceName -NewName "index.twee"
} else {
    Rename-Item -Path $sourceName -NewName "index.html"
}
Write-Host "载入文件成功"

# 进入 tweego 文件夹
$tweegoPath = Join-Path $PSScriptRoot "tweego"
Set-Location -Path $tweegoPath

# 反编译（如果上传的是 HTML）
if (Test-Path "..\index.html") {
    Write-Host "检测到载入了.html文件，执行反编译中……"
    & .\tweego.exe -d -o index.twee ..\index.html
    if ($LASTEXITCODE -ne 0) {
        Write-Host "反编译失败！"
        pause
        exit
    }
    Remove-Item "..\index.html"
    Write-Host "反编译完成。"
}

# === 插入与替换逻辑：处理 index.twee ===
$tweeFile = "index.twee"
if (Test-Path $tweeFile) {
    Write-Host "正在处理 index.twee 插入与替换内容..."
    $content = Get-Content $tweeFile -Encoding UTF8
    $updatedContent = @()
    $foundStylesheet = $false
    $foundScript = $false
    $foundStartLine = $false
    $startValue = ""

    foreach ($line in $content) {
        $updatedContent += $line

        if (-not $foundStylesheet -and $line -match "\[stylesheet\]") {
            Write-Host "检测到 [stylesheet]，插入引用语句..."
            $updatedContent += '/* twine-user-stylesheet #1: "css.css" */'
            $foundStylesheet = $true
        }
        elseif (-not $foundScript -and $line -match "\[script\]") {
            Write-Host "检测到 [script]，插入引用语句..."
            $updatedContent += '/* twine-user-script #1: "javascript.js" */'
            $foundScript = $true
        }

        if (-not $foundStartLine -and $line -match '"start"\s*:\s*"([^"]+)"') {
            $startValue = $Matches[1]
            Write-Host "检测到 start 字段，提取值：$startValue"
            $foundStartLine = $true
        }
    }

    if ($foundStartLine -and $startValue -ne "") {
        Write-Host "正在替换所有的 $startValue 为 Start..."
        $text = ($updatedContent -join "`n") -replace "(?<![""'`])\b$startValue\b(?![""'`])", "Start"
        $updatedContent = $text -split "`n"
    } else {
        Write-Host "未找到 '\"start\": \"xxx\"' 格式的行，跳过替换。"
    }

    Set-Content -Path $tweeFile -Value $updatedContent -Encoding UTF8
    Write-Host "index.twee 修改完成。"
}

# 编译为 HTML
Write-Host "编译 index.twee 中……"
& .\tweego.exe -s Start -o index.html index.twee
if ($LASTEXITCODE -ne 0) {
    Write-Host "编译失败！"
    pause
    exit
}
Write-Host "编译完成！"

# 移动到 modloader 文件夹
Move-Item -Path "index.html" -Destination "..\modloader\index.html" -Force

# 注入ModLoader
Write-Host "注入ModLoader中……"
Set-Location -Path $PSScriptRoot
& .\node\node.exe modloader\dist-insertTools\insert2html.js modloader\index.html modloader\modList.json modloader\dist-BeforeSC2\BeforeSC2.js

# 检查是否注入成功
$modHtmlPath = "modloader\index.html.mod.html"
if (Test-Path $modHtmlPath) {
    Remove-Item "modloader\index.html"
    Move-Item -Path $modHtmlPath -Destination "index.html"
    Write-Host "注入成功！"
} else {
    Write-Host "注入失败！"
    pause
    exit
}

# 重命名为原文件名.mod.html
$finalName = "$sourceBase.mod.html"
Rename-Item -Path "index.html" -NewName $finalName

Write-Host "恭喜你，全部步骤都已完成，请根据使用说明进行mod加载测试"
pause