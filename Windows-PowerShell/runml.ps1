Write-Host -ForegroundColor White "-----------------------------------------------"
Write-Host -ForegroundColor Yellow "��ӭʹ�� SugarCube2 ModLoader ע��ű���"
Write-Host -ForegroundColor Blue "By��RyaraSUKI����GPTЭ����дΪpower shell�ű�"
Write-Host -ForegroundColor Cyan "�����������Զ������Twine��Ŀ��ע��ModLoader"
Write-Host -ForegroundColor Red "��ȷ�����Ѿ��Ķ��������ʹ��˵���е��������ݣ�"
Write-Host -ForegroundColor Red "���棺����ű�ֻ�ǰ���Twine�������ļ�����ע��ģ������ʹ����tweego���밴����ȸ�̳����ֶ�ע�루�����Ż���tweego���ǿ϶����Ǹ��̵̳�"
Write-Host -ForegroundColor White "-----------------------------------------------`n"

do {
    $userInput = Read-Host "�Ƿ�ʼ���У�(y/n)"
    if ($userInput -ieq "n") {
        Write-Host "��ȡ���������رմ��ڡ���"
        Start-Sleep -Seconds 2
        exit
    }
    elseif ($userInput -ieq "y") {
        break
    }
    else {
        Write-Host "������ y �� n ��[yΪȷ�ϣ�nΪȡ�����˳�]"
    }
} while ($true)

# �ϴ��ļ�
do {
    $filePath = Read-Host "�뽫 .twee �� .html �ļ��ϵ��˴��ں󰴻س�"
    if (-not (Test-Path $filePath)) {
        Write-Host "�ļ������ڣ��������ϴ���"
        continue
    }

    $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
    if ($ext -ne ".twee" -and $ext -ne ".html") {
        Write-Host "��ѡ����ȷ�ĸ�ʽ��[.twee �� .html]"
        continue
    }

    break
} while ($true)

# ��ȡ�ļ���
$sourceName = [System.IO.Path]::GetFileName($filePath)
$sourceBase = [System.IO.Path]::GetFileNameWithoutExtension($filePath)
$sourceExt = [System.IO.Path]::GetExtension($filePath)

# ���Ʋ��������ļ�
Copy-Item -Path $filePath -Destination . -Force | Out-Null
if ($sourceExt -ieq ".twee") {
    Rename-Item -Path $sourceName -NewName "index.twee"
} else {
    Rename-Item -Path $sourceName -NewName "index.html"
}
Write-Host "�����ļ��ɹ�"

# ���� tweego �ļ���
$tweegoPath = Join-Path $PSScriptRoot "tweego"
Set-Location -Path $tweegoPath

# �����루����ϴ����� HTML��
if (Test-Path "..\index.html") {
    Write-Host "��⵽������.html�ļ���ִ�з������С���"
    & .\tweego.exe -d -o index.twee ..\index.html
    if ($LASTEXITCODE -ne 0) {
        Write-Host "������ʧ�ܣ�"
        pause
        exit
    }
    Remove-Item "..\index.html"
    Write-Host "��������ɡ�"
}

# === �������滻�߼������� index.twee ===
$tweeFile = "index.twee"
if (Test-Path $tweeFile) {
    Write-Host "���ڴ��� index.twee �������滻����..."
    $content = Get-Content $tweeFile -Encoding UTF8
    $updatedContent = @()
    $foundStylesheet = $false
    $foundScript = $false
    $foundStartLine = $false
    $startValue = ""

    foreach ($line in $content) {
        $updatedContent += $line

        if (-not $foundStylesheet -and $line -match "\[stylesheet\]") {
            Write-Host "��⵽ [stylesheet]�������������..."
            $updatedContent += '/* twine-user-stylesheet #1: "css.css" */'
            $foundStylesheet = $true
        }
        elseif (-not $foundScript -and $line -match "\[script\]") {
            Write-Host "��⵽ [script]�������������..."
            $updatedContent += '/* twine-user-script #1: "javascript.js" */'
            $foundScript = $true
        }

        if (-not $foundStartLine -and $line -match '"start"\s*:\s*"([^"]+)"') {
            $startValue = $Matches[1]
            Write-Host "��⵽ start �ֶΣ���ȡֵ��$startValue"
            $foundStartLine = $true
        }
    }

    if ($foundStartLine -and $startValue -ne "") {
        Write-Host "�����滻���е� $startValue Ϊ Start..."
        $text = ($updatedContent -join "`n") -replace "(?<![""'`])\b$startValue\b(?![""'`])", "Start"
        $updatedContent = $text -split "`n"
    } else {
        Write-Host "δ�ҵ� '\"start\": \"xxx\"' ��ʽ���У������滻��"
    }

    Set-Content -Path $tweeFile -Value $updatedContent -Encoding UTF8
    Write-Host "index.twee �޸���ɡ�"
}

# ����Ϊ HTML
Write-Host "���� index.twee �С���"
& .\tweego.exe -s Start -o index.html index.twee
if ($LASTEXITCODE -ne 0) {
    Write-Host "����ʧ�ܣ�"
    pause
    exit
}
Write-Host "������ɣ�"

# �ƶ��� modloader �ļ���
Move-Item -Path "index.html" -Destination "..\modloader\index.html" -Force

# ע��ModLoader
Write-Host "ע��ModLoader�С���"
Set-Location -Path $PSScriptRoot
& .\node\node.exe modloader\dist-insertTools\insert2html.js modloader\index.html modloader\modList.json modloader\dist-BeforeSC2\BeforeSC2.js

# ����Ƿ�ע��ɹ�
$modHtmlPath = "modloader\index.html.mod.html"
if (Test-Path $modHtmlPath) {
    Remove-Item "modloader\index.html"
    Move-Item -Path $modHtmlPath -Destination "index.html"
    Write-Host "ע��ɹ���"
} else {
    Write-Host "ע��ʧ�ܣ�"
    pause
    exit
}

# ������Ϊԭ�ļ���.mod.html
$finalName = "$sourceBase.mod.html"
Rename-Item -Path "index.html" -NewName $finalName

Write-Host "��ϲ�㣬ȫ�����趼����ɣ������ʹ��˵������mod���ز���"
pause