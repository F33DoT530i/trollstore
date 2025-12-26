# Victim IPA and Cert

This directory contains resources needed to build TrollHelper installer IPAs.

## Required Files

### 1. InstallerVictim.ipa (Required, Not Included)

The `InstallerVictim.ipa` file is **required** to build TrollStore but is **not included** in this repository due to licensing restrictions.

#### What is it?
The victim IPA is typically the **Tips.app** from iOS, which is used as a container for the TrollHelper installer. During the build process, this app is modified to inject the TrollStore persistence helper.

#### How to Obtain

**Option A: Extract from iOS Device (Recommended)**
If you have an iOS device with Tips.app:
1. Use a tool like [iMazing](https://imazing.com/) or [3uTools](http://www.3u.com/) to extract the Tips.app
2. The app is typically located at `/Applications/Tips.app`
3. Package it as an IPA (essentially a zip file with the Payload folder containing the app)

**Option B: Extract from IPSW**
1. Download an IPSW file for a supported iOS version from [ipsw.me](https://ipsw.me)
   - Choose iOS 14.0 - 16.6.1, 16.7 RC, or 17.0
2. Extract the IPSW file (it's a zip archive)
3. Locate the largest DMG file inside (usually `[device].dmg`)
4. Mount or extract the DMG
5. Find `/Applications/Tips.app` inside
6. Create IPA structure:
   ```
   InstallerVictim.ipa
   └── Payload/
       └── Tips.app/
           ├── Tips (binary)
           ├── Info.plist
           └── [other app files]
   ```
7. Zip the structure and rename to `InstallerVictim.ipa`

**Option C: Alternative Victim Apps**
While Tips.app is standard, other system apps can technically be used. The app should be:
- A system application
- Relatively small in size
- Not critical for iOS functionality

#### File Placement
Once obtained, place the file at:
```
Victim/InstallerVictim.ipa
```

### 2. victim.p12 (Auto-generated)

The signing certificate is automatically generated when you run:

```bash
./make_cert.sh <TEAM_ID>
```

The TEAM_ID should match the Team ID from your victim app's provisioning profile. For testing purposes, you can use any 10-character alphanumeric string (e.g., `MRLQS75089`).

This generates `victim.p12` which is used during the IPA signing process.

## Build Process Usage

These files are used during the build process as follows:

1. **InstallerVictim.ipa** is extracted
2. **victim.p12** is used to sign the modified binary
3. The TrollStore persistence helper is injected into the victim app
4. The modified app is repackaged as `TrollHelper_iOS15.ipa` or `TrollHelper_arm64e.ipa`

## Security Notes

- ⚠️ Never commit `InstallerVictim.ipa` to the repository (it's in `.gitignore`)
- ⚠️ Never commit actual Apple developer certificates
- ✓ The auto-generated `victim.p12` is safe to keep locally but not commit
- ✓ These files are only used for packaging, not for app store submission

## Troubleshooting

### "InstallerVictim.ipa not found"
**Solution**: You need to provide this file manually (see "How to Obtain" above)

### "unzip: cannot find InstallerVictim.ipa"
**Solution**: Ensure the file is named exactly `InstallerVictim.ipa` and is in the `Victim/` directory

### "victim.p12 not found"
**Solution**: Run `./make_cert.sh MRLQS75089` in this directory

### IPA is corrupted
**Solution**: Verify your IPA is a valid zip file:
```bash
unzip -t InstallerVictim.ipa
```

## Legal Considerations

- The Tips.app is copyrighted by Apple Inc.
- Extracting apps from IPSW files should only be done for personal use and development
- This is not for redistribution of Apple's software
- TrollStore itself relies on security bugs that have been publicly disclosed and patched

## Alternative Approach

If you cannot obtain `InstallerVictim.ipa`, you can:
1. Build only the non-installer components:
   ```bash
   make make_trollstore
   make make_roothelper
   ```
2. This will create `TrollStore.tar` which can update existing TrollStore installations
3. However, you won't be able to create the initial installer IPAs

## Additional Resources

- [TrollStore Documentation](https://github.com/opa334/TrollStore)
- [iOS CFW Guide - Installing TrollStore](https://ios.cfw.guide/installing-trollstore)
- [BUILD_IPA_GUIDE.md](../BUILD_IPA_GUIDE.md) - Complete build instructions
- [ipsw.me](https://ipsw.me) - Download IPSW files

---

**For automated builds in CI/CD**: You'll need to provide the `InstallerVictim.ipa` through secure means (encrypted secrets, private storage, etc.) or pre-cache it as a build artifact.
