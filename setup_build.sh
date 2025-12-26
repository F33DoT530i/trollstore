#!/bin/bash
# Setup script for building TrollStore IPA
# This script prepares the victim IPA if needed

set -e

VICTIM_DIR="Victim"
VICTIM_IPA="$VICTIM_DIR/InstallerVictim.ipa"
CERT_FILE="$VICTIM_DIR/victim.p12"

echo "=========================================="
echo "TrollStore Build Setup Script"
echo "=========================================="
echo ""

# Check if we're in the right directory
if [ ! -f "Makefile" ] || [ ! -d "$VICTIM_DIR" ]; then
    echo "❌ Error: Please run this script from the TrollStore repository root"
    exit 1
fi

# Check for InstallerVictim.ipa
echo "Checking for InstallerVictim.ipa..."
if [ -f "$VICTIM_IPA" ]; then
    echo "✓ InstallerVictim.ipa found"
    SIZE=$(du -h "$VICTIM_IPA" | cut -f1)
    echo "  Size: $SIZE"
else
    echo "❌ InstallerVictim.ipa not found"
    echo ""
    echo "You need to provide a victim IPA file (typically Tips.app) to build TrollStore."
    echo ""
    echo "Options to obtain InstallerVictim.ipa:"
    echo "1. Extract Tips.app from an iOS IPSW file"
    echo "2. Use an existing Tips.app IPA if you have one"
    echo "3. Download from a trusted source (ensure it's legitimate)"
    echo ""
    echo "Once obtained, place it at: $VICTIM_IPA"
    echo ""
    echo "For detailed instructions, see BUILD_IPA_GUIDE.md"
    exit 1
fi

# Verify IPA structure
echo ""
echo "Verifying IPA structure..."
if unzip -t "$VICTIM_IPA" > /dev/null 2>&1; then
    echo "✓ IPA file is valid"
else
    echo "❌ IPA file appears to be corrupted"
    exit 1
fi

# Check for certificate
echo ""
echo "Checking for signing certificate..."
if [ -f "$CERT_FILE" ]; then
    echo "✓ victim.p12 certificate found"
    AGE=$(find "$CERT_FILE" -mtime +365 2>/dev/null && echo "old" || echo "new")
    if [ "$AGE" = "old" ]; then
        echo "⚠️  Certificate is over 1 year old, consider regenerating"
    fi
else
    echo "❌ victim.p12 not found"
    echo ""
    echo "Generating certificate with default Team ID (MRLQS75089)..."
    cd "$VICTIM_DIR"
    if [ -f "make_cert.sh" ]; then
        chmod +x make_cert.sh
        ./make_cert.sh MRLQS75089
        cd ..
        echo "✓ Certificate generated"
    else
        echo "❌ make_cert.sh script not found"
        cd ..
        exit 1
    fi
fi

# Check for required tools
echo ""
echo "Checking build dependencies..."

# Check for make
if command -v make &> /dev/null; then
    echo "✓ make found"
else
    echo "❌ make not found - please install Xcode Command Line Tools"
    exit 1
fi

# Check for Theos
if [ -n "$THEOS" ] && [ -d "$THEOS" ]; then
    echo "✓ THEOS found at: $THEOS"
elif [ -d "$HOME/theos" ]; then
    echo "⚠️  Theos found at $HOME/theos but THEOS variable not set"
    echo "   Run: export THEOS=$HOME/theos"
    export THEOS=$HOME/theos
else
    echo "❌ THEOS not found"
    echo "   Install with: git clone --recursive https://github.com/theos/theos.git $HOME/theos"
    exit 1
fi

# Check for Homebrew tools on macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo ""
    echo "Checking macOS dependencies..."
    
    MISSING_DEPS=()
    
    if ! command -v brew &> /dev/null; then
        echo "❌ Homebrew not found - install from https://brew.sh"
        exit 1
    fi
    
    # Check for required brew packages
    if ! brew list libarchive &> /dev/null; then
        MISSING_DEPS+=("libarchive")
    fi
    
    if ! brew list openssl@3 &> /dev/null; then
        MISSING_DEPS+=("openssl@3")
    fi
    
    if ! brew list pkg-config &> /dev/null; then
        MISSING_DEPS+=("pkg-config")
    fi
    
    if ! brew list ldid &> /dev/null && ! command -v ldid &> /dev/null; then
        MISSING_DEPS+=("ldid")
    fi
    
    if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
        echo "❌ Missing dependencies: ${MISSING_DEPS[*]}"
        echo "   Install with: brew install ${MISSING_DEPS[*]}"
        exit 1
    else
        echo "✓ All Homebrew dependencies installed"
    fi
    
    # Check Xcode
    if command -v xcodebuild &> /dev/null; then
        XCODE_VERSION=$(xcodebuild -version | head -n1)
        echo "✓ $XCODE_VERSION"
    else
        echo "⚠️  Xcode not found - install from App Store or developer.apple.com"
    fi
fi

echo ""
echo "=========================================="
echo "✓ Setup complete! Ready to build."
echo "=========================================="
echo ""
echo "To build TrollStore, run:"
echo "  make clean"
echo "  make"
echo ""
echo "Build artifacts will be in the _build/ directory"
echo ""
