#!/bin/bash

# Termux初始化配置脚本（修改自https://blog.csdn.net/qq_44684238/article/details/145510430）

# 申请存储权限
echo "正在申请存储权限..."
termux-setup-storage

# 询问是否更换镜像源
read -p "是否要更换Termux镜像源为阿里云？[Y/n] " change_repo
if [[ $change_repo =~ [Yy] ]]; then
    echo -e "请按以下步骤手动操作：\n1. 选择 Single mirror\n2. 选择 mirrors.aliyun.com\n3. 按回车确认"
    termux-change-repo
fi

# 更新软件列表和升级软件包
echo "正在更新软件源..."
pkg update -y && pkg upgrade -y

# 安装基础工具
echo "正在安装nodejs软件包..."
pkg install node

echo "环境配置完成！"