# TrollStore Build Guide

This document provides detailed instructions for building TrollStore from source with the updated iOS 17.5 SDK configuration.

## Prerequisites

### Required Tools

1. **Theos** - iOS/macOS development toolkit
   - Installation: Follow the [official guide](https://theos.dev/docs/installation)
   - Ensure `$THEOS` environment variable is set

2. **Homebrew** (macOS) - Package manager
   - Installation: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
   - Website: [brew.sh](https://brew.sh/)

3. **libarchive** - Archive manipulation library
   ```bash
   brew install libarchive
   ```

4. **OpenSSL/libcrypto** - Cryptography library
   ```bash
   brew install openssl@3
   brew install pkg-config
   ```

5. **Xcode Command Line Tools**
   ```bash
   xcode-select --install
   ```

### Recommended Setup

- **macOS**: 12.0 (Monterey) or later
- **Xcode**: 15.0 or later (for iOS 17.5 SDK support)
- **Disk Space**: At least 2GB free for build artifacts

## Build Configuration

### SDK and Deployment Targets

The project has been configured with the following settings:

- **SDK Version**: iOS 17.5
  - Specified in Makefiles as: `TARGET := iphone:clang:17.5:14.0`
  
- **Minimum Deployment Target**: iOS 14.0
  - Ensures backward compatibility with older devices
  
- **Architectures**:
  - `arm64`: Default for all builds
  - `arm64e`: Available for legacy builds via `CUSTOM_ARCHS` parameter

### Module Structure

The project consists of several modules:

1. **TrollStore** - Main application
2. **TrollHelper** - Persistence helper application
3. **RootHelper** - Root privilege helper tool
4. **TrollStoreLite** - Lite version for jailbroken devices
5. **Exploits/fastPathSign** - Code signing exploit tool
6. **Pwnify** - IPA modification utility

## Building the Project

### Clean Build

To perform a clean build from scratch:

```bash
# Navigate to project root
cd /path/to/trollstore

# Clean previous build artifacts
make clean

# Build all modules
make
```

### Build Output

Successful builds will create a `_build` directory containing:

- `TrollStore.tar` - Main TrollStore application bundle
- `TrollHelper_iOS15.ipa` - Installer for iOS 15+ (arm64)
- `TrollHelper_arm64e.ipa` - Installer for arm64e devices (iPhone XS+)
- `PersistenceHelper_Embedded*` - Various persistence helper binaries
- Package files (.deb) for TrollStore and TrollHelper

### Building Individual Modules

You can build specific modules:

```bash
# Build only TrollStore
make make_trollstore

# Build only TrollHelper
make make_trollhelper_package

# Build only RootHelper
make make_roothelper

# Build only TrollStoreLite
make make_trollstore_lite

# Build fastPathSign tool
make make_fastPathSign
```

## Troubleshooting

### Common Issues

#### 1. Theos Not Found
```
make: *** THEOS not found. Stop.
```

**Solution**: Install Theos and set the `THEOS` environment variable:
```bash
export THEOS=/opt/theos
# Add to ~/.zshrc or ~/.bashrc to make permanent
```

#### 2. libarchive Not Found
```
fatal error: 'archive.h' file not found
```

**Solution**: Install libarchive via Homebrew:
```bash
brew install libarchive
```

#### 3. libcrypto Not Found
```
ld: library not found for -lcrypto
```

**Solution**: Install OpenSSL and ensure pkg-config can find it:
```bash
brew install openssl@3 pkg-config
export PKG_CONFIG_PATH="$(brew --prefix openssl@3)/lib/pkgconfig"
```

#### 4. iOS SDK 17.5 Not Found
```
Error: Could not find iOS SDK 17.5
```

**Solution**: 
- Update Xcode to version 15.0 or later
- Or modify Makefiles to use an available SDK version (e.g., 17.0, 16.5)
- Check available SDKs: `xcodebuild -showsdks`

#### 5. Code Signing Errors
```
Error: Code signing failed
```

**Solution**: Ensure the fastPathSign exploit tool is built:
```bash
cd Exploits/fastPathSign
make
cd ../..
```

### Architecture-Specific Builds

#### Building for arm64e Only

To build specifically for arm64e (iPhone XS and newer):

```bash
make CUSTOM_ARCHS=arm64e
```

#### Building with Legacy CoreTrust Bug

For iOS 14-15.5 compatibility (legacy CoreTrust bug):

```bash
make LEGACY_CT_BUG=1
```

## Development Notes

### Testing Builds

After building, you can:

1. **Install TrollStore.tar**
   - Open in existing TrollStore installation to update

2. **Install TrollHelper IPAs**
   - Use for initial installation via TrollHelperOTA or other methods
   - Choose appropriate IPA based on device architecture

3. **Test on Device**
   - Ensure device is running a supported iOS version (14.0 - 16.6.1, 16.7 RC, or 17.0)
   - Installation will fail on unsupported iOS versions

### Code Modifications

When modifying the code:

1. **Clean before building**: Always run `make clean` after significant changes
2. **Test incrementally**: Build and test individual modules when possible
3. **Check logs**: Review build output for warnings or errors

## Advanced Configuration

### Custom SDK Path

If you have a custom iOS SDK location:

```bash
export THEOS_PLATFORM=ios
export THEOS_PLATFORM_SDK_ROOT=/path/to/sdk
```

### Debug Builds

To build with debugging symbols:

```bash
make DEBUG=1
```

### Parallel Builds

To speed up compilation:

```bash
make -j$(sysctl -n hw.ncpu)
```

## Continuous Integration

For automated builds (CI/CD):

1. Ensure all dependencies are installed
2. Set up Theos in the CI environment
3. Run `make clean && make` in the build script
4. Collect artifacts from `_build` directory

Example GitHub Actions workflow:
```yaml
- name: Install dependencies
  run: |
    brew install libarchive openssl@3 pkg-config
    
- name: Build TrollStore
  run: |
    make clean
    make
    
- name: Upload artifacts
  uses: actions/upload-artifact@v3
  with:
    name: trollstore-build
    path: _build/
```

## Build Verification

After a successful build, verify:

1. ✅ `_build/TrollStore.tar` exists and is > 0 bytes
2. ✅ IPA files are valid zip archives
3. ✅ Binaries contain correct architectures (use `lipo -info`)
4. ✅ Code signing is properly applied (use `codesign -dvv`)

```bash
# Verify architecture
lipo -info _build/PersistenceHelper_Embedded

# Verify signing
codesign -dvv _build/TrollStore.app/TrollStore

# Test IPA structure
unzip -l _build/TrollHelper_iOS15.ipa
```

## Version Information

- **Project Version**: 2.1
- **Build System**: Theos
- **Target SDK**: iOS 17.5
- **Minimum iOS**: 14.0
- **Supported Architectures**: arm64, arm64e

## Additional Resources

- [TrollStore GitHub Repository](https://github.com/opa334/TrollStore)
- [Theos Documentation](https://theos.dev/docs)
- [iOS Development Guide](https://developer.apple.com/ios/)
- [Homebrew Documentation](https://docs.brew.sh/)

## Support

For build issues:
1. Check this guide's troubleshooting section
2. Review GitHub Issues
3. Ensure all prerequisites are correctly installed
4. Verify iOS SDK version is available in your Xcode installation

---

**Last Updated**: December 2024
**Maintainer**: TrollStore Project
