# Building TrollStore IPA - Setup Guide

## Overview

This guide explains how to build TrollStore IPA files for iPhone 15 Pro Max and other iOS 17 compatible devices.

## Important Compatibility Notes

### iOS Version Support
- ✅ **Supported**: iOS 14.0 beta 2 - 16.6.1, iOS 16.7 RC (20H18), iOS 17.0
- ❌ **NOT Supported**: iOS 16.7.x (non-RC), iOS 17.0.1 and later (including iOS 17.6.1)

### iPhone 15 Pro Max
- ✅ **Hardware**: Fully supported
- ⚠️ **iOS Requirement**: Only works on iOS 17.0, NOT on iOS 17.0.1 or later
- The CoreTrust bugs that TrollStore relies on were patched by Apple in iOS 17.0.1

## Prerequisites

### Required Files

The build process requires a victim IPA file (`InstallerVictim.ipa`) that is NOT included in this repository for licensing reasons. You need to:

1. **Extract Tips.app from an iOS device or IPSW**
   - Download an IPSW file for a supported iOS version from [ipsw.me](https://ipsw.me)
   - Extract the Tips.app from the IPSW
   - Package it as an IPA file
   
2. **Or use an existing Tips app IPA**
   - The Tips app is commonly used as the victim for TrollHelper installation
   
3. **Place the file**
   - Save as `Victim/InstallerVictim.ipa` in the repository root

### Generate Certificate

Before building, you need to generate a signing certificate:

```bash
cd Victim
./make_cert.sh <TEAM_ID>
```

Replace `<TEAM_ID>` with the Team ID from the victim app (you can use any 10-character alphanumeric string for testing, e.g., `MRLQS75089`).

This will create `victim.p12` which is used during the build process.

## Building Locally

### Option 1: Using GitHub Actions (Recommended)

The easiest way to build TrollStore is using GitHub Actions:

1. **Push to GitHub**: Ensure your code is pushed to GitHub
2. **Trigger Workflow**: Go to Actions → "Build TrollStore IPA" → "Run workflow"
3. **Download Artifacts**: Once complete, download the artifacts from the workflow run

### Option 2: Building on macOS

#### Prerequisites
- macOS 12.0 or later
- Xcode 15.0 or later
- Homebrew

#### Steps

1. **Install Dependencies**
   ```bash
   brew install libarchive openssl@3 pkg-config ldid
   ```

2. **Install Theos**
   ```bash
   git clone --recursive https://github.com/theos/theos.git $HOME/theos
   export THEOS=$HOME/theos
   ```

3. **Setup Environment**
   ```bash
   export PATH=$HOME/theos/bin:$PATH
   export PKG_CONFIG_PATH="$(brew --prefix openssl@3)/lib/pkgconfig:$PKG_CONFIG_PATH"
   ```

4. **Clone Repository**
   ```bash
   git clone --recursive https://github.com/F33DoT530i/trollstore.git
   cd trollstore
   ```

5. **Setup Victim IPA** (See "Required Files" section above)

6. **Generate Certificate**
   ```bash
   cd Victim
   ./make_cert.sh MRLQS75089
   cd ..
   ```

7. **Build**
   ```bash
   make clean
   make -j$(sysctl -n hw.ncpu)
   ```

8. **Find Build Artifacts**
   ```bash
   ls -lh _build/
   ```

The build process will create:
- `_build/TrollStore.tar` - Main TrollStore application
- `_build/TrollHelper_iOS15.ipa` - Installer for iOS 15+ (arm64)
- `_build/TrollHelper_arm64e.ipa` - Installer for arm64e devices
- Additional helper binaries and packages

## Creating a GitHub Release

### Using the Release Workflow

1. Go to Actions → "Create Release" → "Run workflow"
2. Fill in:
   - **Tag name**: e.g., `v2.1.0`
   - **Release name**: e.g., `TrollStore v2.1.0 - iPhone 15 Pro Max Support`
   - **Pre-release**: Check if this is a beta/test release
3. Click "Run workflow"

The workflow will:
- Build TrollStore from scratch
- Run verification tests
- Create a GitHub Release with the tag
- Upload all build artifacts as release assets
- Generate release notes

### Manual Release Creation

If you've already built the IPA files locally:

1. Go to Releases → "Draft a new release"
2. Create a new tag (e.g., `v2.1.0`)
3. Add a release title
4. Upload the following files from `_build/`:
   - `TrollStore.tar`
   - `TrollHelper_iOS15.ipa`
   - `TrollHelper_arm64e.ipa`
   - Any `.deb` packages
5. Add release notes (see template below)
6. Publish release

## Release Notes Template

```markdown
## TrollStore vX.X.X - iPhone 15 Pro Max Compatible

### 📦 Installation Files
- **TrollStore.tar** - Main application for updating existing installations
- **TrollHelper_iOS15.ipa** - Installer for iOS 15+ devices (arm64)
- **TrollHelper_arm64e.ipa** - Installer for arm64e devices (iPhone XS+)

### ✅ Supported iOS Versions
- iOS 14.0 beta 2 - 16.6.1
- iOS 16.7 RC (20H18)
- iOS 17.0

### ❌ Unsupported iOS Versions
- iOS 16.7.x (excluding RC)
- iOS 17.0.1 and later

### 📱 iPhone 15 Pro Max
- ✅ Hardware fully supported
- ⚠️ Only works on iOS 17.0, NOT 17.0.1+

### 📚 Installation
See [ios.cfw.guide](https://ios.cfw.guide/installing-trollstore)
```

## Troubleshooting

### Missing InstallerVictim.ipa
**Error**: `unzip: ./Victim/InstallerVictim.ipa: No such file or directory`

**Solution**: You need to provide the victim IPA file. See "Required Files" section above.

### Theos Not Found
**Error**: `make: *** THEOS not found`

**Solution**: Install Theos and set the environment variable:
```bash
export THEOS=$HOME/theos
```

### Build Fails on Linux
**Issue**: iOS builds require macOS and Xcode

**Solution**: Use GitHub Actions workflow which runs on macOS runners, or use a macOS machine.

### Certificate Issues
**Error**: Certificate-related build failures

**Solution**: Regenerate the certificate:
```bash
cd Victim
rm -f victim.p12
./make_cert.sh MRLQS75089
```

## File Size Limits

Apple's IPA packaging has the following limits:
- Maximum uncompressed size: 4 GB
- Recommended size: < 2 GB for easier distribution

The build verification step in the GitHub Actions workflow automatically checks these limits.

## Testing the Build

### On Device (Supported iOS Versions Only)

1. **Install TrollStore** first using one of the official methods
2. **Download** `TrollStore.tar` from the release
3. **Open** the tar file in TrollStore to update
4. **Verify** the installation completes successfully

### Verification Steps

- Check that the IPA is a valid zip: `unzip -t TrollHelper_iOS15.ipa`
- Check binary architecture: `lipo -info PersistenceHelper_Embedded`
- Check file size: `du -h TrollHelper_iOS15.ipa`

## Distribution

Once built, the IPA files can be:
1. Uploaded to GitHub Releases (recommended)
2. Distributed via direct download links
3. Hosted on a CDN for faster downloads

**Note**: These files are for personal use. Redistribution should comply with licensing terms.

## Additional Resources

- [BUILD.md](BUILD.md) - Detailed build instructions
- [COMPATIBILITY.md](COMPATIBILITY.md) - Device and iOS compatibility
- [README.md](README.md) - General TrollStore information
- [TrollStore GitHub](https://github.com/opa334/TrollStore) - Original project

## Security Notes

- Build artifacts contain the TrollStore application and installers
- Certificate files (`victim.p12`) are used only for packaging
- No personal certificates or sensitive data should be committed to the repository
- Always verify checksums of downloaded files

## Support

For build issues:
1. Check this guide's troubleshooting section
2. Review GitHub Actions logs for automated build failures
3. Ensure all prerequisites are correctly installed
4. Verify iOS SDK version compatibility

---

**Last Updated**: December 2024  
**Build System**: Theos + Xcode 15  
**Target SDK**: iOS 17.5  
**Deployment Target**: iOS 14.0
