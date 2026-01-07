#!/bin/bash

#===============================================================================
# Pomodoro Timer - Flutter Build Script
#===============================================================================
# A comprehensive build script for the Pomodoro Timer Flutter application.
# Supports Release/Debug builds, Android/iOS/Both platforms, and device installation.
#
# Usage: ./build.sh [options]
#   Options:
#     -h, --help          Show this help message
#     -m, --mode          Build mode: debug|release (default: interactive)
#     -p, --platform      Platform: android|ios|both (default: interactive)
#     -i, --install       Install on connected device (default: false)
#     -f, --format        Format code before building (default: true)
#     -a, --analyze       Run analysis before building (default: true)
#     --skip-format       Skip code formatting
#     --skip-analyze      Skip code analysis
#     --non-interactive   Run with provided options only (no prompts)
#===============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLUTTER_PROJECT_DIR="$SCRIPT_DIR/flutter/pomodoro_timer"

# Default values
BUILD_MODE=""
PLATFORM=""
INSTALL_ON_DEVICE=false
FORMAT_CODE=true
ANALYZE_CODE=true
NON_INTERACTIVE=false

#===============================================================================
# Helper Functions
#===============================================================================

print_banner() {
    echo -e "${PURPLE}"
    echo "╔═══════════════════════════════════════════════════════════════════╗"
    echo "║                                                                   ║"
    echo "║              🍅 Pomodoro Timer Build Script 🍅                    ║"
    echo "║                                                                   ║"
    echo "╚═══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}${BOLD}▶ $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ $1${NC}"
}

show_help() {
    echo -e "${BOLD}Pomodoro Timer - Flutter Build Script${NC}"
    echo ""
    echo -e "${BOLD}Usage:${NC} ./build.sh [options]"
    echo ""
    echo -e "${BOLD}Options:${NC}"
    echo "  -h, --help          Show this help message"
    echo "  -m, --mode          Build mode: debug|release"
    echo "  -p, --platform      Platform: android|ios|both"
    echo "  -i, --install       Install on connected device"
    echo "  -f, --format        Format code before building (default: true)"
    echo "  -a, --analyze       Run analysis before building (default: true)"
    echo "  --skip-format       Skip code formatting"
    echo "  --skip-analyze      Skip code analysis"
    echo "  --non-interactive   Run with provided options only (no prompts)"
    echo ""
    echo -e "${BOLD}Examples:${NC}"
    echo "  ./build.sh                                    # Interactive mode"
    echo "  ./build.sh -m release -p android              # Release build for Android"
    echo "  ./build.sh -m debug -p ios -i                 # Debug build for iOS with install"
    echo "  ./build.sh -m release -p both --skip-format   # Release for both, skip formatting"
    echo ""
}

check_prerequisites() {
    print_step "Checking Prerequisites"
    
    local has_error=false
    
    # Check if Flutter is installed
    if command -v flutter &> /dev/null; then
        local flutter_version=$(flutter --version | head -n 1)
        print_success "Flutter found: $flutter_version"
    else
        print_error "Flutter is not installed or not in PATH"
        has_error=true
    fi
    
    # Check if Dart is installed
    if command -v dart &> /dev/null; then
        local dart_version=$(dart --version 2>&1)
        print_success "Dart found: $dart_version"
    else
        print_error "Dart is not installed or not in PATH"
        has_error=true
    fi
    
    # Check Flutter project directory
    if [ -d "$FLUTTER_PROJECT_DIR" ]; then
        print_success "Flutter project directory found: $FLUTTER_PROJECT_DIR"
    else
        print_error "Flutter project directory not found: $FLUTTER_PROJECT_DIR"
        has_error=true
    fi
    
    # Check pubspec.yaml
    if [ -f "$FLUTTER_PROJECT_DIR/pubspec.yaml" ]; then
        print_success "pubspec.yaml found"
    else
        print_error "pubspec.yaml not found in Flutter project"
        has_error=true
    fi
    
    # Platform-specific checks
    if [[ "$PLATFORM" == "ios" || "$PLATFORM" == "both" ]]; then
        if [[ "$(uname)" == "Darwin" ]]; then
            if command -v xcodebuild &> /dev/null; then
                print_success "Xcode found for iOS builds"
            else
                print_error "Xcode not found - required for iOS builds"
                has_error=true
            fi
        else
            print_error "iOS builds require macOS"
            has_error=true
        fi
    fi
    
    if [[ "$PLATFORM" == "android" || "$PLATFORM" == "both" ]]; then
        if [ -n "$ANDROID_HOME" ] || [ -n "$ANDROID_SDK_ROOT" ]; then
            print_success "Android SDK found"
        else
            print_warning "ANDROID_HOME or ANDROID_SDK_ROOT not set - Android build may fail"
        fi
    fi
    
    if [ "$has_error" = true ]; then
        print_error "Prerequisites check failed. Please fix the issues above."
        exit 1
    fi
    
    echo ""
    print_success "All prerequisites satisfied!"
}

#===============================================================================
# Interactive Menu Functions
#===============================================================================

select_build_mode() {
    if [ -n "$BUILD_MODE" ]; then
        return
    fi
    
    echo -e "\n${BOLD}Select Build Mode:${NC}"
    echo ""
    echo -e "  ${CYAN}1)${NC} Debug   - Development build with debugging enabled"
    echo -e "  ${CYAN}2)${NC} Release - Optimized production build"
    echo ""
    
    while true; do
        read -p "$(echo -e ${YELLOW}Enter choice [1-2]: ${NC})" choice
        case $choice in
            1) BUILD_MODE="debug"; break;;
            2) BUILD_MODE="release"; break;;
            *) print_error "Invalid choice. Please enter 1 or 2.";;
        esac
    done
    
    print_success "Selected: $BUILD_MODE mode"
}

select_platform() {
    if [ -n "$PLATFORM" ]; then
        return
    fi
    
    echo -e "\n${BOLD}Select Target Platform:${NC}"
    echo ""
    echo -e "  ${CYAN}1)${NC} Android - Build for Android devices"
    echo -e "  ${CYAN}2)${NC} iOS     - Build for iOS devices (macOS only)"
    echo -e "  ${CYAN}3)${NC} Both    - Build for Android and iOS"
    echo ""
    
    while true; do
        read -p "$(echo -e ${YELLOW}Enter choice [1-3]: ${NC})" choice
        case $choice in
            1) PLATFORM="android"; break;;
            2) PLATFORM="ios"; break;;
            3) PLATFORM="both"; break;;
            *) print_error "Invalid choice. Please enter 1, 2, or 3.";;
        esac
    done
    
    print_success "Selected: $PLATFORM platform(s)"
}

select_install() {
    echo -e "\n${BOLD}Install on Connected Device?${NC}"
    echo ""
    echo -e "  ${CYAN}1)${NC} Yes - Install the built app on a connected device"
    echo -e "  ${CYAN}2)${NC} No  - Only build the app (don't install)"
    echo ""
    
    while true; do
        read -p "$(echo -e ${YELLOW}Enter choice [1-2]: ${NC})" choice
        case $choice in
            1) INSTALL_ON_DEVICE=true; break;;
            2) INSTALL_ON_DEVICE=false; break;;
            *) print_error "Invalid choice. Please enter 1 or 2.";;
        esac
    done
    
    if [ "$INSTALL_ON_DEVICE" = true ]; then
        print_success "Will install on connected device"
    else
        print_info "Will only build (no installation)"
    fi
}

#===============================================================================
# Build Functions
#===============================================================================

get_dependencies() {
    print_step "Getting Dependencies"
    
    cd "$FLUTTER_PROJECT_DIR"
    flutter pub get
    
    print_success "Dependencies fetched successfully!"
}

format_code() {
    if [ "$FORMAT_CODE" = false ]; then
        print_info "Skipping code formatting (--skip-format)"
        return
    fi
    
    print_step "Formatting Code (Pipeline Verification)"
    
    cd "$FLUTTER_PROJECT_DIR"
    
    # Format code
    print_info "Running dart format..."
    dart format .
    
    # Verify formatting would pass pipeline
    print_info "Verifying formatting matches pipeline requirements..."
    if dart format --output=none --set-exit-if-changed .; then
        print_success "Code formatting verified - pipeline check will pass!"
    else
        print_error "Code formatting verification failed!"
        exit 1
    fi
}

analyze_code() {
    if [ "$ANALYZE_CODE" = false ]; then
        print_info "Skipping code analysis (--skip-analyze)"
        return
    fi
    
    print_step "Analyzing Code"
    
    cd "$FLUTTER_PROJECT_DIR"
    
    print_info "Running flutter analyze..."
    if flutter analyze --no-fatal-infos; then
        print_success "Code analysis passed!"
    else
        print_warning "Code analysis found issues (non-fatal)"
    fi
}

build_android() {
    print_step "Building for Android ($BUILD_MODE)"
    
    cd "$FLUTTER_PROJECT_DIR"
    
    local build_command="flutter build apk"
    
    if [ "$BUILD_MODE" = "release" ]; then
        build_command="$build_command --release"
    else
        build_command="$build_command --debug"
    fi
    
    print_info "Running: $build_command"
    eval $build_command
    
    # Show output location
    if [ "$BUILD_MODE" = "release" ]; then
        local apk_path="$FLUTTER_PROJECT_DIR/build/app/outputs/flutter-apk/app-release.apk"
    else
        local apk_path="$FLUTTER_PROJECT_DIR/build/app/outputs/flutter-apk/app-debug.apk"
    fi
    
    if [ -f "$apk_path" ]; then
        print_success "Android APK built successfully!"
        print_info "Output: $apk_path"
    fi
}

build_ios() {
    print_step "Building for iOS ($BUILD_MODE)"
    
    if [[ "$(uname)" != "Darwin" ]]; then
        print_error "iOS builds are only supported on macOS"
        return 1
    fi
    
    cd "$FLUTTER_PROJECT_DIR"
    
    # Install CocoaPods dependencies
    print_info "Installing CocoaPods dependencies..."
    cd ios
    pod install --repo-update || print_warning "Pod install had warnings"
    cd ..
    
    local build_command="flutter build ios"
    
    if [ "$BUILD_MODE" = "release" ]; then
        build_command="$build_command --release --no-codesign"
    else
        build_command="$build_command --debug --no-codesign"
    fi
    
    print_info "Running: $build_command"
    eval $build_command
    
    print_success "iOS build completed!"
    print_info "Note: For App Store distribution, open Xcode and archive the project."
}

install_android() {
    print_step "Installing on Android Device"
    
    cd "$FLUTTER_PROJECT_DIR"
    
    # Check for connected devices
    local devices=$(flutter devices | grep -i android)
    
    if [ -z "$devices" ]; then
        print_warning "No Android device connected. Skipping installation."
        return
    fi
    
    print_info "Found Android device(s):"
    echo "$devices"
    
    local install_command="flutter install"
    
    print_info "Running: $install_command"
    eval $install_command
    
    print_success "App installed on Android device!"
}

install_ios() {
    print_step "Installing on iOS Device"
    
    if [[ "$(uname)" != "Darwin" ]]; then
        print_error "iOS installation is only supported on macOS"
        return
    fi
    
    cd "$FLUTTER_PROJECT_DIR"
    
    # Check for connected devices
    local devices=$(flutter devices | grep -i iphone)
    
    if [ -z "$devices" ]; then
        print_warning "No iOS device connected. Skipping installation."
        return
    fi
    
    print_info "Found iOS device(s):"
    echo "$devices"
    
    local install_command="flutter install"
    
    print_info "Running: $install_command"
    eval $install_command
    
    print_success "App installed on iOS device!"
}

#===============================================================================
# Summary Functions
#===============================================================================

print_build_summary() {
    echo -e "\n${PURPLE}╔═══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║                         BUILD SUMMARY                             ║${NC}"
    echo -e "${PURPLE}╚═══════════════════════════════════════════════════════════════════╝${NC}\n"
    
    echo -e "  ${BOLD}Build Mode:${NC}     $BUILD_MODE"
    echo -e "  ${BOLD}Platform:${NC}       $PLATFORM"
    echo -e "  ${BOLD}Install:${NC}        $INSTALL_ON_DEVICE"
    echo -e "  ${BOLD}Format Code:${NC}    $FORMAT_CODE"
    echo -e "  ${BOLD}Analyze Code:${NC}   $ANALYZE_CODE"
    echo ""
}

print_completion() {
    echo -e "\n${GREEN}╔═══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                       BUILD COMPLETED! 🎉                         ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════════╝${NC}\n"
    
    if [[ "$PLATFORM" == "android" || "$PLATFORM" == "both" ]]; then
        if [ "$BUILD_MODE" = "release" ]; then
            print_info "Android APK: $FLUTTER_PROJECT_DIR/build/app/outputs/flutter-apk/app-release.apk"
        else
            print_info "Android APK: $FLUTTER_PROJECT_DIR/build/app/outputs/flutter-apk/app-debug.apk"
        fi
    fi
    
    if [[ "$PLATFORM" == "ios" || "$PLATFORM" == "both" ]]; then
        print_info "iOS Build: $FLUTTER_PROJECT_DIR/build/ios/iphoneos/"
    fi
    
    echo ""
}

#===============================================================================
# Main Execution
#===============================================================================

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -m|--mode)
                BUILD_MODE="$2"
                if [[ "$BUILD_MODE" != "debug" && "$BUILD_MODE" != "release" ]]; then
                    print_error "Invalid build mode: $BUILD_MODE (must be 'debug' or 'release')"
                    exit 1
                fi
                shift 2
                ;;
            -p|--platform)
                PLATFORM="$2"
                if [[ "$PLATFORM" != "android" && "$PLATFORM" != "ios" && "$PLATFORM" != "both" ]]; then
                    print_error "Invalid platform: $PLATFORM (must be 'android', 'ios', or 'both')"
                    exit 1
                fi
                shift 2
                ;;
            -i|--install)
                INSTALL_ON_DEVICE=true
                shift
                ;;
            -f|--format)
                FORMAT_CODE=true
                shift
                ;;
            -a|--analyze)
                ANALYZE_CODE=true
                shift
                ;;
            --skip-format)
                FORMAT_CODE=false
                shift
                ;;
            --skip-analyze)
                ANALYZE_CODE=false
                shift
                ;;
            --non-interactive)
                NON_INTERACTIVE=true
                shift
                ;;
            *)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

main() {
    # Parse command line arguments
    parse_arguments "$@"
    
    # Print banner
    print_banner
    
    # Interactive mode if options not provided
    if [ "$NON_INTERACTIVE" = false ]; then
        select_build_mode
        select_platform
        
        if [ "$INSTALL_ON_DEVICE" = false ]; then
            select_install
        fi
    else
        # Validate required options in non-interactive mode
        if [ -z "$BUILD_MODE" ]; then
            print_error "Build mode is required in non-interactive mode (-m debug|release)"
            exit 1
        fi
        if [ -z "$PLATFORM" ]; then
            print_error "Platform is required in non-interactive mode (-p android|ios|both)"
            exit 1
        fi
    fi
    
    # Print build summary
    print_build_summary
    
    # Confirm before proceeding (in interactive mode)
    if [ "$NON_INTERACTIVE" = false ]; then
        echo ""
        read -p "$(echo -e ${YELLOW}Proceed with build? [Y/n]: ${NC})" confirm
        case $confirm in
            [Nn]*)
                print_info "Build cancelled."
                exit 0
                ;;
        esac
    fi
    
    # Run build steps
    check_prerequisites
    get_dependencies
    format_code
    analyze_code
    
    # Build for selected platform(s)
    if [[ "$PLATFORM" == "android" || "$PLATFORM" == "both" ]]; then
        build_android
        if [ "$INSTALL_ON_DEVICE" = true ]; then
            install_android
        fi
    fi
    
    if [[ "$PLATFORM" == "ios" || "$PLATFORM" == "both" ]]; then
        build_ios
        if [ "$INSTALL_ON_DEVICE" = true ]; then
            install_ios
        fi
    fi
    
    # Print completion message
    print_completion
}

# Run main function
main "$@"