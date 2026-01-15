# TrollStore SpawnRoot

TrollStore SpawnRoot is an iOS application that provides an interface for spawning root processes and managing system operations using TrollStore's utilities.

## Features

### Core Functionality
- **Root Process Spawning**: Execute commands with root privileges using the `spawnRoot()` function from TSUtil
- **Process Enumeration**: View all running processes on the system using `enumerateProcessesUsingBlock()`
- **Command Execution Interface**: Interactive UI for running arbitrary commands as root
- **Real-time Logging**: Capture and display stdout/stderr from executed commands

### Utilities
- **WiFi/Cellular Fix**: Implements `chineseWifiFixup()` to ensure proper network connectivity
- **Process Management**: View process details including PID and executable path
- **Entitlement Management**: Properly configured entitlements for elevated privileges

## Architecture

### File Structure
```
TrollStoreSpawnRoot/
├── main.m                                 # Application entry point
├── TSSpawnRootViewController.h/.m         # Main view controller
├── TSSpawnRootAppDelegate.h/.m            # Legacy app delegate (non-scene)
├── TSSpawnRootAppDelegateWithScene.h/.m   # Scene-based app delegate (iOS 13+)
├── TSSpawnRootSceneDelegate.h/.m          # Scene delegate
├── entitlements.plist                     # Required entitlements for root operations
├── Makefile                               # Build configuration
├── control                                # Package metadata
└── Resources/
    └── Info.plist                         # App configuration
```

### Key Components

#### 1. main.m
- Entry point for the application
- Implements `sceneDelegateFix()` for dynamic scene delegate configuration
- Applies WiFi/cellular fixes on startup
- Handles both scene-based (iOS 13+) and legacy app delegate modes

#### 2. TSSpawnRootViewController
- Main interface with two modes:
  - **Process List Mode**: Displays all running processes
  - **Command Execution Mode**: Interactive command execution interface
- Utilizes TSUtil functions:
  - `spawnRoot()` for executing commands as root
  - `enumerateProcessesUsingBlock()` for process enumeration
  - `getExecutablePath()` for getting current binary path

#### 3. App Delegates
- **TSSpawnRootAppDelegate**: Legacy mode for iOS < 13 or apps without scene support
- **TSSpawnRootAppDelegateWithScene**: Scene-based mode for iOS 13+
- **TSSpawnRootSceneDelegate**: Manages scene lifecycle

## Entitlements

The application requires the following entitlements for proper operation:

### Core Root Operations
- `com.apple.private.persona-mgmt`: Required for spawning processes with root privileges
- `platform-application`: Elevated privileges for platform-level operations
- `com.apple.private.security.no-sandbox`: Disable sandbox for root process spawning

### Network Operations
- `com.apple.CommCenter.fine-grained`: Required for WiFi/cellular policy management

### Container and Storage Access
- `com.apple.private.security.container-manager`: Container management
- `com.apple.private.MobileContainerManager.allowed`: Mobile container access
- `com.apple.private.security.storage.AppBundles`: App bundle storage access
- `com.apple.private.security.storage.MobileDocuments`: Document storage access

### Launch Services
- `com.apple.private.coreservices.canmaplsdatabase`: Core Services database access
- `com.apple.lsapplicationworkspace.rebuildappdatabases`: LaunchServices database rebuild
- `com.apple.springboard.launchapplications`: Application launching via SpringBoard
- `com.apple.backboardd.launchapplications`: Application launching via BackBoard
- `com.apple.frontboard.launchapplications`: Application launching via FrontBoard

### Process Management
- `com.apple.multitasking.termination`: Process termination capability

## Building

### Prerequisites
- Theos installed and configured
- iOS SDK 17.5 or later
- libroot library for root operations
- fastPathSign tool (included in TrollStore project)

### Build Commands

Build standalone:
```bash
cd TrollStoreSpawnRoot
make clean
make package
```

Build as part of TrollStore project:
```bash
cd /path/to/trollstore
make
```

## Usage

### Process List Mode
1. Launch the application
2. Default view shows all running processes
3. Tap on any process to view details (PID and path)
4. Pull to refresh the process list

### Command Execution Mode
1. Switch to "Command Execution" using the segment control
2. Enter a command in the text field (e.g., `/bin/ls`, `/usr/bin/whoami`)
3. Tap "Execute as Root" to run the command
4. View output in the log area below
5. Use "Clear Log" to reset the log output

### Example Commands
- `/usr/bin/whoami` - Display current user (should show "root")
- `/bin/ls -la /var` - List contents of /var directory
- `/usr/bin/id` - Display user and group information
- `/bin/ps aux` - Display all running processes

## Integration with TrollStore

TrollStore SpawnRoot integrates seamlessly with the existing TrollStore ecosystem:

1. **Shared Utilities**: Uses TSUtil.m functions for all root operations
2. **Build System**: Integrates with the main Makefile
3. **Entitlements**: Uses same privilege model as TrollHelper and RootHelper
4. **Compatibility**: Supports same iOS versions (14.0+) as TrollStore

## iOS Version Compatibility

- **iOS 14.0 - 14.8**: Full support (legacy app delegate)
- **iOS 15.0 - 15.8**: Full support (scene-based app delegate)
- **iOS 16.0 - 16.7**: Full support
- **iOS 17.0+**: Full support

## Security Considerations

### Privileges
- Runs with elevated privileges via persona management
- No sandbox restrictions for maximum flexibility
- Access to system containers and storage

### Code Signing
- Signed using fastPathSign (TrollStore's code signing tool)
- Proper entitlements embedded in binary
- Compatible with TrollStore's exploit framework

### Best Practices
- Always validate command input before execution
- Log all root operations for audit purposes
- Handle errors gracefully to prevent crashes
- Respect process boundaries and system stability

## Troubleshooting

### Command Execution Fails
- Verify the command path is correct and absolute
- Check that the binary has execute permissions
- Ensure required arguments are properly formatted
- Review stderr output for error messages

### Process List Empty
- Ensure proper entitlements are applied
- Check that sysctl permissions are available
- Verify no security policies are blocking enumeration

### WiFi/Cellular Issues
- The `chineseWifiFixup()` is applied at launch
- Restart the app if connectivity issues persist
- Check CoreTelephony framework is properly linked

## Technical Details

### Root Spawning Mechanism
Uses POSIX spawn with persona attributes:
```c
posix_spawnattr_set_persona_np(&attr, 99, POSIX_SPAWN_PERSONA_FLAGS_OVERRIDE);
posix_spawnattr_set_persona_uid_np(&attr, 0);  // UID 0 (root)
posix_spawnattr_set_persona_gid_np(&attr, 0);  // GID 0 (wheel)
```

### Process Enumeration
Uses sysctl with KERN_PROC_ALL:
```c
int mib[3] = { CTL_KERN, KERN_PROC, KERN_PROC_ALL };
sysctl(mib, 3, info, &length, NULL, 0);
```

## License

Same license as TrollStore project.

## Credits

- Based on TrollStore by opa334
- Utilizes TSUtil.m utilities
- Inspired by TrollHelper and RootHelper implementations
