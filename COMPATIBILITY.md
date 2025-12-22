# TrollStore Compatibility Guide

## iOS Version Support

### Supported iOS Versions
TrollStore is compatible with the following iOS versions due to the CoreTrust bug (CVE-2022-26766 and CVE-2023-41991):

- **iOS 14.0 beta 2 through iOS 16.6.1**
- **iOS 16.7 RC (20H18)** 
- **iOS 17.0 (final and betas 1-8)**

### Unsupported iOS Versions
The following iOS versions are **NOT** supported and will **NEVER** be supported:

- **iOS 16.7.x** (excluding 16.7 RC)
- **iOS 17.0.1 and later** (including iOS 17.6.1, 17.5.x, etc.)

**Reason**: Apple patched the CoreTrust bugs that TrollStore relies on in iOS 16.7 (non-RC) and iOS 17.0.1+. Unless a new CoreTrust bug is discovered (which is unlikely), these versions cannot be supported.

## Device Compatibility

### iPhone Models

#### Fully Compatible
All iPhone models running supported iOS versions (see above) are compatible:

- iPhone 6S and later (iOS 14.0 - 16.6.1 support)
- iPhone XS and later (arm64e support for enhanced security)
- **iPhone 15 series** including iPhone 15 Pro Max (A17 Pro chip)
  - ✅ **Hardware**: Fully compatible
  - ⚠️ **iOS**: Only if running iOS 17.0 (NOT 17.0.1+)

### Architecture Support

- **arm64**: All iPhone models from iPhone 5S onward
- **arm64e**: iPhone XS and newer (A12+ chips)
  - iPhone XS / XS Max / XR (A12)
  - iPhone 11 / 11 Pro / 11 Pro Max (A13)
  - iPhone 12 / 12 mini / 12 Pro / 12 Pro Max (A14)
  - iPhone 13 / 13 mini / 13 Pro / 13 Pro Max (A15)
  - iPhone 14 / 14 Plus / 14 Pro / 14 Pro Max (A15/A16)
  - iPhone 15 / 15 Plus / 15 Pro / 15 Pro Max (A16/A17 Pro)

### iPad Compatibility
TrollStore is compatible with iPad models running supported iOS/iPadOS versions:

- iPad (5th generation and later)
- iPad Air (2nd generation and later)
- iPad mini (4th generation and later)
- iPad Pro (all models)

## Hardware Features

### iPhone 15 Pro Max Specific Features
The iPhone 15 Pro Max includes the following hardware features:

- **Chip**: A17 Pro (3nm process, arm64e architecture)
- **Display**: 6.7" Super Retina XDR with ProMotion (120Hz)
- **Cameras**: 48MP main, 12MP ultra-wide, 12MP telephoto (5x optical zoom)
- **Action Button**: Replaces traditional mute switch
- **USB-C**: USB 3 speeds (up to 10Gb/s)
- **Titanium Frame**: Lighter and more durable

All hardware features work normally when TrollStore is installed on a supported iOS version. TrollStore does not interfere with any hardware functionality.

## Build Configuration

### SDK Updates (v2.1+)
The project has been updated to use newer build tools:

- **SDK Version**: iOS 17.5 (updated from iOS 16.5)
- **Minimum Deployment Target**: iOS 14.0 (unchanged)
- **Build Architectures**: arm64, arm64e
- **Xcode Compatibility**: Xcode 15.0 or later recommended

### Why Update to iOS 17.5 SDK?
1. **Better compatibility** with newer Xcode versions
2. **Support for newer hardware** like iPhone 15 Pro Max during development
3. **Access to latest frameworks** and APIs for development
4. **Future-proofing** the build system

**Important**: Building with iOS 17.5 SDK does NOT enable TrollStore to run on iOS 17.0.1+. The SDK version only affects the build process and development experience, not the runtime compatibility which is determined by the CoreTrust bug.

## Frequently Asked Questions

### Can I use TrollStore on iPhone 15 Pro Max with iOS 17.6.1?
**No**. While the iPhone 15 Pro Max hardware is supported, iOS 17.6.1 is NOT compatible with TrollStore. You would need to downgrade to iOS 17.0 (if still being signed by Apple) to use TrollStore.

### Can I use TrollStore on iPhone 15 Pro Max with iOS 17.0?
**Yes**. If your iPhone 15 Pro Max is running iOS 17.0 (final or beta), TrollStore is fully compatible.

### Will TrollStore ever support iOS 17.0.1+?
**Unlikely**. This would require discovery of a new CoreTrust bug, which is a rare security vulnerability. Apple has significantly hardened CoreTrust after the previous bugs were disclosed.

### Does the updated SDK (17.5) mean iOS 17.5 is supported?
**No**. The SDK version used for building is separate from iOS runtime compatibility. The updated SDK only improves the development and build process.

### What's the difference between arm64 and arm64e?
- **arm64**: Standard 64-bit ARM architecture, used in iPhone 5S through iPhone X
- **arm64e**: Enhanced 64-bit ARM with Pointer Authentication Codes (PAC), used in iPhone XS and newer (A12+)
- Both architectures are supported by TrollStore

## Update History

### Version 2.1 (Latest)
- Updated build SDK to iOS 17.5
- Updated Info.plist to require arm64 (removed armv7)
- Enhanced documentation for iPhone 15 series compatibility
- Clarified iOS version limitations in README

### Previous Versions
- Supported iOS 14.0 - 17.0 with SDK 16.5
- Original CoreTrust bug implementation
