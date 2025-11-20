#!/bin/bash

# Clash Mi iOS 构建脚本
set -e

echo "开始构建 Clash Mi iOS 版本..."

# 检查环境
if ! command -v flutter &> /dev/null; then
    echo "错误: Flutter 未安装或未在 PATH 中"
    exit 1
fi

if ! command -v xcodebuild &> /dev/null; then
    echo "错误: Xcode 未安装"
    exit 1
fi

# 清理之前的构建
echo "清理项目..."
flutter clean
rm -rf ios/Pods ios/Podfile.lock

# 获取依赖
echo "获取 Flutter 依赖..."
flutter pub get

echo "安装 iOS 依赖..."
cd ios
pod install --repo-update
cd ..

# 构建选项
BUILD_TYPE=${1:-debug}

case $BUILD_TYPE in
    "debug")
        echo "构建 Debug 版本..."
        flutter build ios --debug
        ;;
    "release")
        echo "构建 Release 版本..."
        flutter build ios --release
        ;;
    "ipa")
        echo "构建 IPA 文件..."
        flutter build ipa --release
        echo "IPA 文件位置: build/ios/archive/"
        ;;
    *)
        echo "使用方法: ./build_ios.sh [debug|release|ipa]"
        exit 1
        ;;
esac

echo "构建完成!"

# 如果是 Release 构建，显示下一步操作
if [ "$BUILD_TYPE" = "release" ]; then
    echo "请在 Xcode 中打开 ios/Runner.xcworkspace 进行签名和 Archive"
fi