# GitHub Actions Workflows

This directory contains automated workflows for building and releasing TrollStore IPA files.

## Workflows

### 1. Build TrollStore IPA (`build-trollstore.yml`)

**Purpose**: Automatically build TrollStore on every code change

**Triggers**:
- Push to `main` branch
- Pull requests to `main` branch
- Manual dispatch via Actions tab

**What it does**:
1. Sets up macOS environment with Xcode 15.0
2. Checks for required `InstallerVictim.ipa` file
3. Installs dependencies (Theos, Homebrew packages, ldid)
4. Generates signing certificate
5. Builds all TrollStore components
6. Verifies build outputs (size, structure, integrity)
7. Uploads artifacts with 30-day retention

**Artifacts Created**:
- TrollStore-tar (TrollStore.tar)
- TrollHelper-iOS15-IPA (TrollHelper_iOS15.ipa)
- TrollHelper-arm64e-IPA (TrollHelper_arm64e.ipa)
- TrollStore-Complete-Build (all files in _build/)

**Requirements**:
- `Victim/InstallerVictim.ipa` must be present
- macOS runner (provided by GitHub)
- No additional secrets needed

**How to use**:
1. Ensure `InstallerVictim.ipa` is in the `Victim/` directory
2. Push code or open a PR
3. Check Actions tab for build progress
4. Download artifacts when build completes

---

### 2. Create Release (`release.yml`)

**Purpose**: Create a GitHub Release with all build artifacts

**Triggers**:
- Manual dispatch only (Actions tab → Create Release)

**Inputs**:
- **tag_name** (required): Release tag (e.g., `v2.1.0`)
- **release_name** (required): Release name (e.g., `TrollStore v2.1.0 - iPhone 15 Pro Max Support`)
- **prerelease** (optional): Mark as pre-release (default: false)

**What it does**:
1. Builds TrollStore from scratch
2. Verifies all build artifacts
3. Creates a GitHub Release with specified tag
4. Auto-generates release notes with compatibility warnings
5. Uploads all artifacts (tar, IPAs, deb packages) to the release

**Release Assets**:
- TrollStore.tar
- TrollHelper_iOS15.ipa
- TrollHelper_arm64e.ipa
- All .deb packages

**Requirements**:
- `Victim/InstallerVictim.ipa` must be present
- Workflow must have write permissions (automatically granted)
- Must be triggered manually

**How to use**:
1. Go to Actions → Create Release
2. Click "Run workflow"
3. Fill in:
   - Tag: `v2.1.0` (or your version number)
   - Name: `TrollStore v2.1.0 - iPhone 15 Pro Max Support`
   - Pre-release: Check if this is a beta/test release
4. Click "Run workflow" button
5. Wait for completion
6. Check Releases page for new release

---

## Common Issues

### "InstallerVictim.ipa not found"

The build requires a victim IPA file that is not included in the repository.

**Solution**: 
1. See `Victim/README.md` for detailed instructions
2. Extract Tips.app from an iOS IPSW
3. Place at `Victim/InstallerVictim.ipa`
4. Retry the workflow

### Workflow fails on Linux

iOS builds require macOS and Xcode.

**Solution**: The workflows are configured to use `macos-13` runners which GitHub provides. No action needed - this is automatic.

### Permission denied errors

The workflows need proper permissions to upload artifacts or create releases.

**Solution**: These are configured in the workflow files. If you fork this repository, ensure Actions are enabled.

### Build succeeds but no artifacts

Check that the build actually completed successfully and didn't skip due to missing InstallerVictim.ipa.

**Solution**: Review the workflow logs in the Actions tab for detailed information about what happened.

---

## Workflow Security

### Permissions

Both workflows use explicit permissions (principle of least privilege):

**build-trollstore.yml**:
- `contents: read` - Read repository contents
- `actions: read` - Read action artifacts

**release.yml**:
- `contents: write` - Create releases and upload assets

### Secrets

No secrets are required for these workflows. They use:
- Auto-generated certificates (created during build)
- Public Homebrew packages
- Open source tools (Theos, ldid)

### Dependencies

All dependencies are installed from trusted sources:
- Homebrew official repository
- Theos official GitHub repository
- Xcode from macOS runner

---

## Customization

### Changing Xcode Version

Edit the "Select Xcode version" step:
```yaml
- name: Select Xcode version
  run: sudo xcode-select -s /Applications/Xcode_15.0.app/Contents/Developer
```

Available versions on GitHub runners: Check [GitHub Actions documentation](https://github.com/actions/runner-images/blob/main/images/macos/macos-13-Readme.md)

### Changing macOS Version

Edit the `runs-on` directive:
```yaml
jobs:
  build:
    runs-on: macos-13  # or macos-12, macos-14, etc.
```

### Adding Additional Checks

Add new steps before or after the build:
```yaml
- name: Custom verification
  run: |
    # Your custom verification commands
```

---

## Testing Workflows

### Test Locally

You can test the build commands locally on macOS:
```bash
./setup_build.sh
make clean && make
```

### Test in Fork

1. Fork this repository
2. Add `InstallerVictim.ipa` to your fork
3. Push changes to trigger workflows
4. Check Actions tab in your fork

### Manual Trigger

Both workflows support manual triggering:
1. Go to Actions tab
2. Select the workflow
3. Click "Run workflow"
4. Choose branch and fill parameters (for release workflow)

---

## Monitoring Builds

### Build Status

Check build status in multiple places:
- Actions tab: Detailed logs and status
- Commit status: Green checkmark or red X
- PR checks: Automated checks on pull requests

### Notifications

Configure notifications:
1. Go to repository Settings → Notifications
2. Choose when to receive emails about workflows
3. Options: all workflows, only failures, etc.

### Build Logs

Access detailed logs:
1. Go to Actions tab
2. Click on a workflow run
3. Click on job name
4. Expand steps to see detailed output

---

## Resources

- **Main Documentation**: See root directory README.md
- **Build Guide**: BUILD_IPA_GUIDE.md
- **Quick Start**: QUICKSTART.md
- **Visual Guide**: WORKFLOW_GUIDE.md
- **Victim IPA Guide**: Victim/README.md

---

## Support

For workflow issues:
1. Check workflow logs in Actions tab
2. Review this README
3. Consult main documentation files
4. Ensure all prerequisites are met

---

**Last Updated**: December 2024
**Workflow Version**: 1.0
**macOS Runner**: macos-13
**Xcode Version**: 15.0
