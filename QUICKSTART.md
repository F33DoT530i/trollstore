# Quick Start: Building and Releasing TrollStore IPA

This is a quick reference for building TrollStore IPA files. For detailed instructions, see [BUILD_IPA_GUIDE.md](BUILD_IPA_GUIDE.md).

## Prerequisites Checklist

- [ ] macOS 12.0+ (for local builds) or GitHub Actions (for automated builds)
- [ ] Xcode 15.0+ installed
- [ ] Homebrew installed
- [ ] Theos installed at `$HOME/theos`
- [ ] `InstallerVictim.ipa` placed in `Victim/` directory

## Quick Build (Local)

```bash
# 1. Clone repository
git clone --recursive https://github.com/<username>/trollstore.git
cd trollstore

# 2. Run setup script
./setup_build.sh

# 3. Build
make clean
make

# 4. Find outputs
ls -lh _build/
```

## Quick Build (GitHub Actions)

### Option 1: Automatic Build
1. Place `InstallerVictim.ipa` in `Victim/` directory
2. Commit and push to GitHub
3. GitHub Actions automatically builds on push
4. Download artifacts from the Actions tab

### Option 2: Manual Release
1. Ensure `InstallerVictim.ipa` is in place
2. Go to Actions → "Create Release"
3. Enter tag (e.g., `v2.1.0`) and release name
4. Click "Run workflow"
5. Release is created with all IPA files attached

## What Gets Built

| File | Description | Size (Approx) |
|------|-------------|---------------|
| `TrollStore.tar` | Main app for updating TrollStore | ~15 MB |
| `TrollHelper_iOS15.ipa` | Installer for iOS 15+ (arm64) | ~20 MB |
| `TrollHelper_arm64e.ipa` | Installer for arm64e devices | ~20 MB |
| `*.deb` | Debian packages for jailbroken devices | ~10 MB each |

## iOS Compatibility Quick Reference

| iOS Version | iPhone 15 Pro Max | Other Devices | Status |
|-------------|-------------------|---------------|---------|
| 14.0 - 16.6.1 | N/A (device didn't exist) | ✅ Supported | Fully functional |
| 16.7 RC | N/A | ✅ Supported | Fully functional |
| 17.0 | ✅ Supported | ✅ Supported | Fully functional |
| 17.0.1+ | ❌ Not supported | ❌ Not supported | CoreTrust patched |

**Important**: iOS 17.0.1 and later (including 17.6.1) are NOT and will NEVER be supported due to Apple's security patches.

## Obtaining InstallerVictim.ipa

**Required but NOT included** in the repository.

### Quick Method
1. Download iOS 17.0 IPSW from [ipsw.me](https://ipsw.me)
2. Extract IPSW (it's a zip file)
3. Mount the largest `.dmg` file
4. Copy `/Applications/Tips.app` from the DMG
5. Create IPA structure:
   ```
   Victim/InstallerVictim.ipa
   └── Payload/
       └── Tips.app/
   ```
6. Zip and rename to `InstallerVictim.ipa`

See [Victim/README.md](Victim/README.md) for detailed instructions.

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "InstallerVictim.ipa not found" | Obtain victim IPA (see above) |
| "THEOS not found" | `export THEOS=$HOME/theos` |
| "Xcode not found" | Install Xcode 15.0+ from App Store |
| "libarchive not found" | `brew install libarchive` |
| Build fails on Linux | Use GitHub Actions (requires macOS) |

## File Size Verification

Before distribution, verify IPA files don't exceed limits:

```bash
# Check all IPA files
for ipa in _build/*.ipa; do
    SIZE=$(stat -f%z "$ipa" 2>/dev/null || stat -c%s "$ipa")
    SIZE_MB=$((SIZE / 1024 / 1024))
    echo "$(basename $ipa): ${SIZE_MB}MB"
done
```

Apple's limit: **4GB per IPA** (but keep under 2GB for practicality)

## Testing the Build

### Quick Verification
```bash
# Test IPA is valid zip
unzip -t _build/TrollHelper_iOS15.ipa

# Check binary architecture
lipo -info _build/PersistenceHelper_Embedded

# Verify file sizes
du -h _build/*
```

### On-Device Testing
1. **Requires**: Device on iOS 14.0-16.6.1, 16.7 RC, or 17.0
2. Install TrollStore using an official method first
3. Open `TrollStore.tar` in TrollStore to update
4. Verify app launches and functions correctly

**Note**: Cannot test on iOS 17.0.1+ as TrollStore doesn't work on those versions.

## Distribution

### GitHub Release (Recommended)
- Use "Create Release" workflow in Actions
- Automatically uploads all artifacts
- Generates release notes
- Provides download links

### Manual Distribution
- Upload to CDN or file hosting
- Provide SHA256 checksums
- Include compatibility warnings in README

## Security Checklist

Before committing:
- [ ] No `InstallerVictim.ipa` in commits (check `.gitignore`)
- [ ] No real developer certificates committed
- [ ] No personal credentials in workflows
- [ ] Victim files are in `.gitignore`

## Next Steps

After building successfully:
1. **Test** on a supported device
2. **Create release** via GitHub Actions workflow
3. **Document** any changes or updates
4. **Notify users** about iOS compatibility limitations

## Support & Resources

- **Full Build Guide**: [BUILD_IPA_GUIDE.md](BUILD_IPA_GUIDE.md)
- **Compatibility Info**: [COMPATIBILITY.md](COMPATIBILITY.md)
- **Build Details**: [BUILD.md](BUILD.md)
- **Original Project**: [TrollStore GitHub](https://github.com/opa334/TrollStore)

---

**⚠️ Important Disclaimer**

This build process is for personal use and development purposes. Always ensure you:
- Understand iOS compatibility limitations
- Have legal rights to any files you use
- Follow Apple's terms of service
- Don't redistribute copyrighted material
- Use TrollStore responsibly

**iOS 17.0.1+ is NOT supported** - Don't expect builds to work on these versions regardless of build configuration.
