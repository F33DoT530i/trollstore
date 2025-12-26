# TrollStore Testing Guide for iOS 17.0

## Overview

This guide provides comprehensive testing procedures for TrollStore on iOS 17.0 (the last supported iOS version). This is specifically important for iPhone 15 Pro Max users who are on iOS 17.0.

## Prerequisites

### Supported Test Devices

- ✅ Any iOS device running iOS 17.0 (final or beta 1-8)
- ✅ iPhone 15 Pro Max on iOS 17.0
- ✅ Any iPhone XS or newer (arm64e architecture)
- ✅ Any iPhone 6S or newer on iOS 14.0 - 16.6.1

### Unsupported Devices (Do Not Test)

- ❌ Any device on iOS 17.0.1 or later (17.1, 17.2, 17.3, 17.4, 17.5, 17.6, 17.6.1)
- ❌ Any device on iOS 16.7.x (except 16.7 RC)

### Build Requirements

1. macOS 12.0 or later
2. Xcode 15.0 or later (for iOS 17.5 SDK)
3. Theos installed and configured
4. Homebrew with libarchive and openssl@3

## Build Testing

### Step 1: Clean Build

```bash
# Navigate to project root
cd /path/to/trollstore

# Clean all previous builds
make clean

# Build all components
make

# Expected output:
# - _build/TrollStore.tar
# - _build/TrollHelper_iOS15.ipa
# - _build/TrollHelper_arm64e.ipa
# - Various persistence helpers
```

### Step 2: Verify Build Artifacts

```bash
# Check TrollStore.tar exists
ls -lh _build/TrollStore.tar

# Verify IPA structure
unzip -l _build/TrollHelper_iOS15.ipa

# Check binary architectures
lipo -info _build/PersistenceHelper_Embedded

# Expected: arm64 or "Non-fat file ... is architecture: arm64"
```

### Step 3: Validate Code Signing

```bash
# Extract TrollHelper
unzip _build/TrollHelper_iOS15.ipa -d /tmp/trollhelper

# Check code signature
codesign -dvv /tmp/trollhelper/Payload/TrollStorePersistenceHelper.app

# Expected: Valid signature with custom entitlements
```

## Installation Testing (iOS 17.0)

### Method 1: TrollHelper Installation (First Time)

**Prerequisites**: Device must be on iOS 17.0

1. **Install TrollHelper IPA**
   ```
   - Use TrollHelperOTA or alternative installation method
   - Choose appropriate IPA:
     * TrollHelper_iOS15.ipa for arm64
     * TrollHelper_arm64e.ipa for iPhone XS+
   ```

2. **Verify Installation**
   ```
   - TrollHelper app appears on home screen
   - App launches without crashing
   - UI loads correctly
   ```

3. **Install TrollStore**
   ```
   - Tap "Install TrollStore" in TrollHelper
   - Wait for installation to complete
   - Device will respring
   ```

4. **Verify TrollStore Installation**
   ```
   - TrollStore app appears on home screen
   - TrollStore launches successfully
   - Settings are accessible
   ```

### Method 2: Update Existing TrollStore

**Prerequisites**: TrollStore already installed on iOS 17.0

1. **Open TrollStore.tar in TrollStore**
   ```
   - Copy TrollStore.tar to device
   - Open in Files app
   - Share to TrollStore
   ```

2. **Install Update**
   ```
   - TrollStore prompts for installation
   - Tap "Install"
   - Device resprings
   ```

3. **Verify Update**
   ```
   - TrollStore version updated
   - All existing apps still installed
   - Persistence helper still works
   ```

## Feature Testing

### Test 1: IPA Installation

**Test installing various types of IPAs:**

#### Basic IPA (No Special Entitlements)
```
1. Obtain a standard IPA file
2. Open in TrollStore
3. Tap "Install"
4. Expected: Successful installation
5. Verify: App appears on home screen
6. Verify: App launches correctly
```

#### IPA with Entitlements
```
1. Create/obtain IPA with custom entitlements
2. Sign with ldid if needed:
   ldid -S<entitlements.plist> <binary>
3. Install via TrollStore
4. Expected: Entitlements preserved
5. Verify: App has requested capabilities
```

#### Unsandboxed App
```
1. Create IPA with no-sandbox entitlement
2. Install via TrollStore
3. Launch app
4. Verify: App can access root filesystem
5. Test: Read/write to /var or /tmp
```

### Test 2: Persistence Helper

**Test the persistence helper functionality:**

```
1. Open TrollStore Settings
2. Tap "Install Persistence Helper"
3. Select a system app (Tips, News, etc.)
4. Verify: Installation successful message
5. Respring device (Settings > Accessibility > Touch > Reachability)
6. Open TrollStore
7. Verify: TrollStore still launches
8. Open installed apps
9. Verify: Installed apps still launch
```

### Test 3: URL Scheme

**Test URL scheme functionality:**

#### Install from URL
```
1. Host an IPA file on a web server
2. Create URL: apple-magnifier://install?url=<IPA_URL>
3. Open URL in Safari
4. Expected: TrollStore opens and prompts for installation
5. Verify: IPA installs correctly
```

#### Enable JIT (TrollStore 2.0.12+)
```
1. Install an app that uses JIT (e.g., emulator)
2. Create URL: apple-magnifier://enable-jit?bundle-id=<Bundle_ID>
3. Open URL
4. Expected: JIT enabled for the app
5. Verify: App runs with JIT compilation
```

### Test 4: App Uninstallation

```
1. Swipe left on an installed app in TrollStore
2. Tap "Delete"
3. Verify: App removed from home screen
4. Verify: App data container removed
5. Verify: No leftover files in /var/containers
```

### Test 5: Root Helper

**Test root privilege functionality:**

#### Spawn as Root
```
1. Install app with persona-mgmt entitlement
2. Use spawnRoot function from TSUtil.m
3. Execute a root-level command (e.g., touch /var/test)
4. Verify: Command executes successfully
5. Verify: File created with root ownership
6. Clean up: rm /var/test
```

### Test 6: Rebuild Icon Cache

```
1. Install several apps via TrollStore
2. Trigger icon cache rebuild:
   - Option A: Install/uninstall an App Store app
   - Option B: Reboot device
3. After icon cache rebuilds:
   - Open persistence helper app
   - Tap "Refresh App Registrations"
4. Verify: All TrollStore apps still launch
```

## iPhone 15 Pro Max Specific Tests

### Test 1: A17 Pro Compatibility

```
1. Verify device model: iPhone 15 Pro Max
2. Check CPU: A17 Pro (via System Info app or Settings)
3. Install TrollStore using arm64e build
4. Verify: Installation successful
5. Test all features above
6. Expected: No performance issues
```

### Test 2: Hardware Features

Verify hardware features work with TrollStore installed:

```
✅ Action Button: Should work normally
✅ ProMotion Display: 120Hz should function
✅ Camera System: All cameras accessible
✅ USB-C: File transfer and debugging work
✅ Face ID: Biometric authentication works
✅ Wireless charging: Functions normally
```

### Test 3: High-Performance Apps

```
1. Install demanding apps via TrollStore
2. Test apps that use:
   - Metal API (games, 3D apps)
   - Neural Engine (AI/ML apps)
   - Camera APIs
   - GPU-intensive tasks
3. Verify: No crashes or performance degradation
4. Monitor: Battery life and thermal performance
```

## iOS 17.0 Specific Tests

### Test 1: System Compatibility

```
1. Verify iOS version: Settings > General > About
2. Expected: 17.0 (21A329) or beta version
3. Test with iOS 17.0 specific features:
   - NameDrop (contact sharing)
   - StandBy mode
   - Interactive widgets
4. Verify: No conflicts with TrollStore
```

### Test 2: Security Features

```
1. Test with iOS 17.0 security features:
   - Communication Safety
   - Sensitive Content Warning
   - Lockdown Mode (if enabled)
2. Verify: TrollStore functions normally
3. Verify: No security warnings about TrollStore
```

### Test 3: App Store Compatibility

```
1. Install apps from App Store
2. Update App Store apps
3. Verify: App Store functionality unaffected
4. Verify: No conflicts with TrollStore apps
```

## Negative Tests (iOS 17.6)

### Test 1: Installation Attempt on iOS 17.6

**Purpose**: Verify that installation correctly fails on iOS 17.6

```
1. Get a device on iOS 17.6 or 17.6.1
2. Attempt to install TrollHelper
3. Expected: Installation fails with appropriate error
4. Expected: No system instability
5. Expected: Device remains functional
```

### Test 2: Update Attempt on iOS 17.6

**Purpose**: Verify existing installation doesn't work after update

```
1. Have TrollStore installed on iOS 17.0
2. Update device to iOS 17.6 (if testing scenario)
3. Expected: TrollStore apps no longer launch
4. Expected: TrollStore itself may not launch
5. Expected: No system corruption
```

## Performance Testing

### Test 1: Installation Speed

```
1. Install multiple IPAs in sequence
2. Measure installation time for each
3. Expected: Reasonable installation times (<1 min for typical app)
4. Monitor: CPU and memory usage
5. Verify: No memory leaks
```

### Test 2: Memory Usage

```
1. Launch TrollStore
2. Monitor memory usage (Xcode Instruments or similar)
3. Install several apps
4. Check memory after installations
5. Expected: Memory returned after operations
```

### Test 3: Storage Management

```
1. Check storage before: Settings > General > Storage
2. Install multiple large apps
3. Uninstall apps via TrollStore
4. Check storage after uninstall
5. Verify: Storage properly reclaimed
```

## Security Testing

### Test 1: Entitlement Validation

```
1. Create IPA with banned entitlements (iOS 15+ A12+):
   - com.apple.private.cs.debugger
   - dynamic-codesigning
   - com.apple.private.skip-library-validation
2. Install via TrollStore
3. Expected: App installs but crashes on launch
4. Verify: System remains stable
```

### Test 2: Sandbox Escape

```
1. Install unsandboxed app
2. Attempt to access restricted areas:
   - /System
   - /Applications
   - Other app containers
3. Verify: Access granted (as expected for no-sandbox)
4. Test: Cannot modify system files (no root)
```

### Test 3: Persistence After Reboot

```
1. Install TrollStore and apps
2. Perform hard reboot (volume up, down, hold power)
3. After reboot:
   - Open persistence helper
   - Refresh app registrations
4. Verify: All apps accessible again
```

## Regression Testing

### Test 1: Existing Functionality

For each TrollStore update, verify:

```
✅ IPA installation still works
✅ App uninstallation still works
✅ Persistence helper still functions
✅ URL schemes still work
✅ Root helper spawning still works
✅ Entitlements preservation still works
✅ Settings UI still accessible
```

### Test 2: Upgrade Path

```
1. Install older TrollStore version (e.g., 2.0)
2. Upgrade to new version
3. Verify: All features work
4. Verify: Existing apps still installed
5. Verify: Settings preserved
```

## Troubleshooting Common Issues

### Issue 1: TrollStore Won't Launch After Icon Cache Rebuild

**Solution**:
```
1. Open persistence helper app
2. Tap to re-register TrollStore
3. TrollStore should now launch
```

### Issue 2: Apps Not Installing

**Check**:
```
- IPA is not corrupt (try unzip)
- Device has enough storage
- IPA is compatible with device architecture
- IPA doesn't use banned entitlements on A12+ iOS 15+
```

### Issue 3: Persistence Helper Installation Fails

**Try**:
```
- Choose different system app
- Respring device and retry
- Verify TrollStore is properly installed
- Check console logs for errors
```

## Test Result Documentation

### Template for Test Report

```markdown
## Test Environment
- Device: [iPhone model]
- iOS Version: [Exact version]
- TrollStore Version: [Version]
- Build: [arm64/arm64e]
- Date: [Test date]

## Test Results

### Installation Tests
- [ ] Clean install: PASS/FAIL
- [ ] Update install: PASS/FAIL
- [ ] Notes: [Any observations]

### Feature Tests
- [ ] IPA installation: PASS/FAIL
- [ ] Persistence helper: PASS/FAIL
- [ ] URL schemes: PASS/FAIL
- [ ] App uninstallation: PASS/FAIL
- [ ] Root helper: PASS/FAIL

### Performance Tests
- [ ] Installation speed: PASS/FAIL
- [ ] Memory usage: PASS/FAIL
- [ ] Storage management: PASS/FAIL

### Issues Found
1. [Issue description]
2. [Issue description]

### Recommendations
- [Recommendation 1]
- [Recommendation 2]
```

## Automated Testing

### Script for Basic Tests

```bash
#!/bin/bash
# Basic TrollStore test script
# Run on macOS with device connected

echo "TrollStore Build and Basic Tests"
echo "================================"

# Build
echo "Building TrollStore..."
make clean
make
if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
fi
echo "✅ Build successful"

# Verify artifacts
echo "Verifying build artifacts..."
if [ -f "_build/TrollStore.tar" ]; then
    echo "✅ TrollStore.tar exists"
else
    echo "❌ TrollStore.tar not found"
    exit 1
fi

if [ -f "_build/TrollHelper_iOS15.ipa" ]; then
    echo "✅ TrollHelper_iOS15.ipa exists"
else
    echo "❌ TrollHelper_iOS15.ipa not found"
    exit 1
fi

# Verify architectures
echo "Checking architectures..."
lipo -info _build/PersistenceHelper_Embedded
if [ $? -ne 0 ]; then
    echo "❌ Architecture check failed"
    exit 1
fi
echo "✅ Architecture check passed"

echo ""
echo "All automated tests passed!"
echo "Proceed with manual device testing"
```

## Continuous Testing

### Recommended Testing Schedule

**Before Each Release**:
- Full regression test suite
- Test on multiple iOS 17.0 devices
- Test on iPhone 15 Pro Max if available
- Performance benchmarking

**Weekly** (during active development):
- Basic functionality tests
- Build verification
- Installation testing

**After iOS Updates**:
- Verify compatibility with new iOS 17.0.x versions (if released)
- Test on updated devices
- Check for any breaking changes

## Conclusion

This testing guide ensures comprehensive validation of TrollStore functionality on iOS 17.0, the last supported iOS version. Follow these procedures to verify:

1. ✅ Build system works correctly
2. ✅ Installation succeeds on iOS 17.0
3. ✅ All features function as expected
4. ✅ iPhone 15 Pro Max compatibility
5. ✅ Performance is acceptable
6. ✅ No regressions from previous versions

**Remember**: iOS 17.6 and later are NOT supported. Focus testing efforts on iOS 17.0 and earlier supported versions.

---

**Document Version**: 1.0  
**Last Updated**: December 2024  
**For TrollStore Version**: 2.1
