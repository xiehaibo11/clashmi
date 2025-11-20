# Clash Mi 构建指南

## 自动化构建 (推荐)

### GitHub Actions 自动构建

本项目已配置完整的 CI/CD 流水线，支持自动化构建多平台版本：

#### 触发方式

1. **推送触发**：
   - 推送到 `main` 分支：自动构建 iOS Debug 版本
   - 推送到 `develop` 分支：自动构建开发版本
   - 推送 `v*` 标签：自动构建 Release 版本

2. **手动触发**：
   - 访问 GitHub 仓库的 Actions 页面
   - 选择对应的工作流
   - 点击 "Run workflow"

#### 工作流说明

- `build-ios.yml`: 主要的 iOS 构建流程（无签名，用于测试）
- `build-ios-signed.yml`: 带签名的 iOS 构建（需要配置证书）
- `build-dev.yml`: 开发版本构建

## 手动构建

### 环境要求

- Flutter SDK 3.24.0+
- Xcode 15.0+ (macOS)
- Android Studio (可选，用于 Android 构建)
- CocoaPods (iOS/macOS)

### iOS 构建

```bash
# 1. 克隆仓库
git clone https://github.com/xiehaibo11/clashmi.git
cd clashmi

# 2. 安装依赖
flutter pub get
cd ios && pod install && cd ..

# 3. 构建选项
# Debug 版本（开发测试）
flutter build ios --debug --no-codesign

# Release 版本（需要签名配置）
flutter build ios --release

# 生成 IPA 文件
flutter build ipa --release
```

### Android 构建

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Release AAB (用于 Google Play)
flutter build appbundle --release
```

### 多平台构建

```bash
# macOS
flutter build macos --release

# Windows (需要 Windows 环境)
flutter build windows --release

# Linux (需要 Linux 环境)
flutter build linux --release

# Web
flutter build web --release
```

## 发布构建配置

### iOS 代码签名配置

要生成带签名的 iOS 应用，需要在 GitHub 仓库设置中添加以下 Secrets：

1. **证书配置**：
   - `BUILD_CERTIFICATE_BASE64`: Base64 编码的 .p12 证书
   - `P12_PASSWORD`: .p12 证书的密码
   - `BUILD_PROVISION_PROFILE_BASE64`: Base64 编码的配置文件
   - `KEYCHAIN_PASSWORD`: 钥匙串密码

2. **获取证书**：
   ```bash
   # 导出证书为 .p12 格式
   openssl base64 -in YourCertificate.p12 -out certificate_base64.txt

   # 导出配置文件
   openssl base64 -in YourProfile.mobileprovision -out profile_base64.txt
   ```

### App Store 发布

1. 使用 `build-ios-signed.yml` 工作流
2. 推送带有版本标签的提交：`git tag v1.0.0 && git push origin v1.0.0`
3. 等待构建完成
4. 从 GitHub Releases 下载 IPA 文件
5. 使用 Xcode 或 Transporter 上传到 App Store Connect

## 构建产物说明

### 文件位置

- **iOS Debug**: `build/ios/iphoneos/`
- **iOS Release**: `build/ios/archive/`
- **IPA 文件**: `build/ios/ipa/`
- **Android APK**: `build/app/outputs/flutter-apk/`
- **Android AAB**: `build/app/outputs/bundle/release/`

### 下载构建产物

每次构建完成后，可以在 GitHub Actions 页面下载构建产物：
1. 访问 [Actions 页面](https://github.com/xiehaibo11/clashmi/actions)
2. 选择对应的 workflow run
3. 点击 "Artifacts" 部分的下载按钮

## 故障排除

### 常见问题

1. **Flutter 版本不匹配**：
   ```bash
   flutter upgrade
   flutter clean
   ```

2. **iOS 依赖问题**：
   ```bash
   cd ios
   rm -rf Pods Podfile.lock
   pod install --repo-update
   ```

3. **Android 构建问题**：
   ```bash
   flutter clean
   flutter pub cache repair
   ```

4. **签名失败**：
   - 检查证书和配置文件是否匹配
   - 确认 Bundle ID 配置正确
   - 验证开发者账号权限

### 日志查看

构建失败时，可以查看详细的构建日志：
1. 在 GitHub Actions 中点击失败的 job
2. 展开具体的步骤查看详细错误信息
3. 搜索错误关键词定位问题

## 开发调试

### 本地开发

```bash
# 启动开发服务器
flutter run

# 指定设备运行
flutter run -d ios
flutter run -d android
flutter run -d chrome
```

### 热重载

开发过程中支持热重载：
- 保存文件后自动重载
- 按 'r' 手动重载
- 按 'R' 热重启

### 调试模式

```bash
# 启用详细日志
flutter run --verbose

# 调试模式构建
flutter build ios --debug --verbose
```

## 更多信息

- [Flutter 官方文档](https://flutter.dev/docs)
- [iOS 部署指南](https://flutter.dev/docs/deployment/ios)
- [Android 部署指南](https://flutter.dev/docs/deployment/android)

如有问题，请在 GitHub 仓库中提交 Issue。