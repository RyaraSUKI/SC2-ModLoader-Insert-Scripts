#!/bin/sh

echo "欢迎使用SugarCube2 ModLoader注入脚本！<~ Linux专用版 ~>"
echo "在使用前，请确保你已经阅读并理解了使用说明中的所有内容！By: RyaraSUKI"

ASK() {
    echo -n "是否开始运行？(y/n) "
    read userInput

    case "$userInput" in
        n|N)
            echo "已取消操作，关闭窗口……"
            sleep 2
            exit 0
            ;;
        y|Y)
            ;;
        *)
            echo "请输入 y 或 n ！[y为确认，n为取消并退出]"
            ASK
            ;;
    esac
}

ASK

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -f "$SCRIPT_DIR/index.html" ]; then
    echo "index.html 已找到，继续执行下一步……"
    tweego -d -o index.twee index.html
    rm index.html

    file="index.twee"

    awk '
    BEGIN {
      ss_done = 0
      js_done = 0
    }
    {
      print $0
      if (!ss_done && $0 ~ /\[stylesheet\]/) {
        print "/* twine-user-stylesheet #1: \"css.css\" */"
        ss_done = 1
      } else if (!js_done && $0 ~ /\[script\]/) {
        print "/* twine-user-script #1: \"javascript.js\" */"
        js_done = 1
      }
    }' "$file" > "${file}.tmp"
    
    echo "[stylesheet]与[script]插入引用语句完成。"
    
    start_line=$(grep '"start":' "${file}.tmp" | head -n 1)

    if [ -n "$start_line" ]; then
        value=$(echo "$start_line" | sed -E 's/.*"start":[[:space:]]*"([^"]+)".*/\1/')
        echo "提取值: $value"
        sed "s/\b${value}\b/Start/g" "${file}.tmp" > "${file}.tmp2"
        mv "${file}.tmp2" "$file"
    else
        echo "未找到包含 '\"start\":' 的行，跳过替换步骤。"
        mv "${file}.tmp" "$file"
    fi

    echo "index.twee 修改完成。"

    tweego -o index.html index.twee
    rm index.twee
    mv index.html ml/
    rm "${file}.tmp"
    
    cd ml
    node dist-insertTools/insert2html.js index.html modList.json dist-BeforeSC2/BeforeSC2.js

    echo "完成！"
else
    echo "请放入 index.html 文件到当前目录：$SCRIPT_DIR"
    ASK
fi