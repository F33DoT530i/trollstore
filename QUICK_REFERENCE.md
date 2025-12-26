# iOS 17.6 & iPhone 15 Pro Max - Quick Reference

## TL;DR

❌ **TrollStore does NOT work on iOS 17.6 or iOS 17.6.1**  
✅ **iPhone 15 Pro Max hardware IS supported**  
✅ **iOS 17.0 is the LAST supported iOS version**

## Quick Facts

| Question | Answer |
|----------|--------|
| Does TrollStore work on iOS 17.6? | ❌ No |
| Does TrollStore work on iOS 17.6.1? | ❌ No |
| Does TrollStore work on iOS 17.0? | ✅ Yes |
| Can I use iPhone 15 Pro Max? | ✅ Yes, but only on iOS 17.0 |
| Why doesn't iOS 17.6 work? | 🔒 Apple patched CoreTrust bugs |
| Will iOS 17.6 ever be supported? | ❌ Extremely unlikely |
| Can I downgrade to iOS 17.0? | ❌ Likely not (Apple stops signing) |

## For iPhone 15 Pro Max Users

### ✅ If You Have iOS 17.0
```
Status: TrollStore WORKS!
Action: DO NOT update to iOS 17.0.1 or later
Keep: Stay on iOS 17.0 if TrollStore is important
```

### ❌ If You Have iOS 17.6
```
Status: TrollStore DOES NOT WORK
Reason: Apple security patches (CVE-2022-26766, CVE-2023-41991)
Options:
  1. Use AltStore/SideStore (7-day signing)
  2. Buy Developer Account ($99/year)
  3. Wait for potential jailbreak
  4. Accept limitation and use App Store only
```

### 🆕 If You're Buying New
```
Warning: New iPhone 15 Pro Max ships with iOS 17.0.1+
Result: TrollStore will NOT work
Consider: Alternatives before purchasing for TrollStore
```

## Supported iOS Versions

### ✅ SUPPORTED
- iOS 14.0 beta 2 → iOS 16.6.1
- iOS 16.7 RC (20H18) only
- iOS 17.0 (final and betas)

### ❌ NOT SUPPORTED
- iOS 16.7.x (except RC)
- iOS 17.0.1+
- iOS 17.1, 17.2, 17.3, 17.4, 17.5
- **iOS 17.6, iOS 17.6.1**

## Why iOS 17.6 Doesn't Work

```
Simple Explanation:
iOS 17.6 has security patches that close the bugs TrollStore uses.

Technical Explanation:
- CVE-2022-26766: Multi-signer certificate validation bug (PATCHED)
- CVE-2023-41991: Alternate signature validation bypass (PATCHED)
- Enhanced AMFI validation (NEW in iOS 17.0.1+)
- Improved certificate chain verification (NEW in iOS 17.0.1+)
```

## iPhone Models Compatibility

| Model | Hardware | iOS 17.0 | iOS 17.6 |
|-------|----------|----------|----------|
| iPhone 15 Pro Max | ✅ | ✅ | ❌ |
| iPhone 15 Pro | ✅ | ✅ | ❌ |
| iPhone 15 Plus | ✅ | ✅ | ❌ |
| iPhone 15 | ✅ | ✅ | ❌ |
| iPhone 14 series | ✅ | ✅ | ❌ |
| iPhone 13 series | ✅ | ✅ | ❌ |
| iPhone 12 series | ✅ | ✅ | ❌ |
| iPhone 11 series | ✅ | ✅ | ❌ |
| iPhone XS/XR+ | ✅ | ✅ | ❌ |
| iPhone 6S-X | ✅ | ✅ | ❌ |

**Note**: All models work on iOS 17.0, none work on iOS 17.6

## Alternatives for iOS 17.6

### Option 1: AltStore / SideStore
```
Cost: FREE
Pros: No cost, works on any iOS version
Cons: 7-day signing limit, requires computer refresh
Best For: Occasional app sideloading
```

### Option 2: Paid Developer Account
```
Cost: $99 USD/year
Pros: 1-year signing, official Apple method
Cons: Annual cost, still has limitations
Best For: Regular app development/sideloading
```

### Option 3: Enterprise Certificates
```
Cost: Varies ($300-$500+)
Pros: Longer validity periods
Cons: Risk of revocation, unofficial
Best For: Advanced users only
```

### Option 4: Wait for Jailbreak
```
Cost: FREE (when available)
Pros: Full system access, TrollStore-like features
Cons: Not available yet, may never come
Best For: Patients users who can wait
```

## Architecture Support

### arm64 (All iPhones)
- iPhone 6S and later
- All iOS 14+ devices
- Standard 64-bit ARM

### arm64e (iPhone XS+)
- iPhone XS/XS Max/XR (A12)
- iPhone 11 series (A13)
- iPhone 12 series (A14)
- iPhone 13 series (A15)
- iPhone 14 series (A15/A16)
- iPhone 15 series (A16/A17 Pro)
- Enhanced with PAC (Pointer Authentication)

## A17 Pro Chip (iPhone 15 Pro Max)

### Hardware Features
```
Process: 3nm
Architecture: arm64e
Cores: 6 (2 performance, 4 efficiency)
GPU: 6-core
Neural Engine: 16-core
Security: Enhanced Secure Enclave, Advanced PAC
```

### TrollStore Compatibility
```
Build Support: ✅ Yes (can build with iOS 17.5 SDK)
iOS 17.0 Runtime: ✅ Yes (works perfectly)
iOS 17.6 Runtime: ❌ No (security patches block it)
```

## Security Patches in iOS 17.6

| Security Feature | iOS 17.0 | iOS 17.6 |
|-----------------|----------|----------|
| CVE-2022-26766 | Vulnerable | ✅ Patched |
| CVE-2023-41991 | Vulnerable | ✅ Patched |
| AMFI Validation | Standard | ✅ Enhanced |
| Cert Chain Check | Basic | ✅ Improved |
| Runtime Integrity | Standard | ✅ Enhanced |
| Memory Protection | Standard | ✅ Improved (A17) |

## Common Questions

### Q: I just got iPhone 15 Pro Max on iOS 17.6. Can I use TrollStore?
**A**: No. You need iOS 17.0, which you cannot downgrade to.

### Q: Can I downgrade from iOS 17.6 to iOS 17.0?
**A**: No. Apple only signs the latest iOS version (likely 17.6+).

### Q: Will there be an update to make TrollStore work on iOS 17.6?
**A**: No. The security patches are permanent and cannot be bypassed with software updates.

### Q: Is there any workaround for iOS 17.6?
**A**: No. Use alternatives like AltStore or Developer Account.

### Q: Does the iPhone 15 Pro Max work well with TrollStore on iOS 17.0?
**A**: Yes! All hardware features work perfectly.

### Q: What if Apple releases iOS 17.7?
**A**: It will also NOT be supported (security patches remain).

## What to Do Now

### ✅ If You're on iOS 17.0
1. **DO NOT UPDATE** to any newer iOS version
2. Install TrollStore while you can
3. Use it to install apps you need
4. Set up persistence helper
5. Enjoy permanent sideloading

### ❌ If You're on iOS 17.6
1. **ACCEPT** TrollStore won't work
2. **CHOOSE** an alternative (see above)
3. **DON'T WAIT** for iOS 17.6 support (won't happen)
4. **CONSIDER** staying on this version if jailbreak matters

### 🆕 If You're Buying New
1. **CHECK** iOS version before purchase
2. **EXPECT** iOS 17.0.1+ on new devices
3. **PLAN** for alternatives, not TrollStore
4. **ACCEPT** no downgrade possible

## Documentation Reference

For more details, see:

- **IOS_17_6_SECURITY.md** - Deep technical analysis of iOS 17.6 security
- **TESTING.md** - Comprehensive testing guide for iOS 17.0
- **COMPATIBILITY.md** - Full compatibility information
- **BUILD.md** - How to build TrollStore
- **README.md** - General information about TrollStore

## Support & Updates

### Official Resources
- GitHub: [opa334/TrollStore](https://github.com/opa334/TrollStore)
- Installation Guide: [ios.cfw.guide/installing-trollstore](https://ios.cfw.guide/installing-trollstore)

### Community
- Reddit: r/jailbreak (for general iOS jailbreak/TrollStore discussion)
- Discord: Various iOS modification communities

### Checking iOS Signing Status
- [ipsw.me](https://ipsw.me) - Check which iOS versions Apple is still signing
- Generally: Only latest iOS version is signed

## Version Info

- **TrollStore Version**: 2.1
- **Last Supported iOS**: 17.0
- **Build SDK**: iOS 17.5
- **Minimum iOS**: 14.0
- **Document Date**: December 2024

---

## Final Summary

```
┌─────────────────────────────────────────────────┐
│                                                 │
│  ❌ iOS 17.6 does NOT support TrollStore       │
│  ✅ iOS 17.0 DOES support TrollStore           │
│  ✅ iPhone 15 Pro Max hardware is supported    │
│  🔒 Security patches prevent iOS 17.6 support  │
│  💡 Use alternatives if on iOS 17.6+           │
│                                                 │
└─────────────────────────────────────────────────┘
```

**Bottom Line**: If you want TrollStore, you need iOS 17.0 or earlier. iOS 17.6 will never work due to Apple's security patches.
