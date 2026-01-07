#!/bin/bash

#===============================================================================
# Pomodoro Timer - Flutter Build Script
#===============================================================================
# A comprehensive build script for the Pomodoro Timer Flutter application.
# Supports Release/Debug builds for Android, iOS, iPadOS, macOS, and Windows.
#
# Usage: ./build.sh [options]
#   Options:
#     -h, --help          Show this help message
#     -m, --mode          Build mode: debug|release (default: debug)
#     -p, --platform      Platform: android|ios|ipados|macos|windows (default: ios)
#     -i, --install       Install on connected device (default: false)
#     -f, --format        Format code before building (default: true)
#     -a, --analyze       Run analysis before building (default: true)
#     --skip-format       Skip code formatting
#     --skip-analyze      Skip code analysis
#     --interactive       Run in interactive mode (prompts for options)
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
BUILD_MODE="debug"
PLATFORM="ios"
INSTALL_ON_DEVICE=false
FORMAT_CODE=true
ANALYZE_CODE=true
INTERACTIVE=false

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
    echo "  -m, --mode          Build mode: debug|release (default: debug)"
    echo "  -p, --platform      Platform: android|ios|ipados|macos|windows (default: ios)"
    echo "  -i, --install       Install on connected device"
    echo "  -f, --format        Format code before building (default: true)"
    echo "  -a, --analyze       Run analysis before building (default: true)"
    echo "  --skip-format       Skip code formatting"
    echo "  --skip-analyze      Skip code analysis"
    echo "  --interactive       Run in interactive mode (prompts for options)"
    echo ""
    echo -e "${BOLD}Examples:${NC}"
    echo "  ./build.sh                                    # Default: iOS debug build"
    echo "  ./build.sh -m release -p android              # Release build for Android"
    echo "  ./build.sh -m debug -p ios -i                 # Debug build for iOS with install"
    echo "  ./build.sh -m release -p macos                # Release build for macOS"
    echo "  ./build.sh -m debug -p ipados -i              # Debug build for iPadOS with install"
    echo "  ./build.sh -m release -p windows              # Release build for Windows"
    echo "  ./build.sh --interactive                      # Interactive mode with prompts"
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
    if [[ "$PLATFORM" == "ios" || "$PLATFORM" == "ipados" || "$PLATFORM" == "macos" ]]; then
        if [[ "$(uname)" == "Darwin" ]]; then
            if command -v xcodebuild &> /dev/null; then
                print_success "Xcode found for $PLATFORM builds"
            else
                print_error "Xcode not found - required for $PLATFORM builds"
                has_error=true
            fi
        else
            print_error "$PLATFORM builds require macOS"
            has_error=true
        fi
    fi
    
    if [[ "$PLATFORM" == "android" ]]; then
        if [ -n "$ANDROID_HOME" ] || [ -n "$ANDROID_SDK_ROOT" ]; then
            print_success "Android SDK found"
        else
            print_warning "ANDROID_HOME or ANDROID_SDK_ROOT not set - Android build may fail"
        fi
    fi
    
    if [[ "$PLATFORM" == "windows" ]]; then
        if [[ "$(uname)" == "MINGW"* || "$(uname)" == "MSYS"* || "$(uname)" == "CYGWIN"* ]]; then
            print_success "Windows build environment detected"
        else
            print_warning "Windows builds are best run on Windows - cross-compilation not supported"
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
    echo -e "\n${BOLD}Select Target Platform:${NC}"
    echo ""
    echo -e "  ${CYAN}1)${NC} Android - Build for Android devices"
    echo -e "  ${CYAN}2)${NC} iOS     - Build for iPhone (macOS only)"
    echo -e "  ${CYAN}3)${NC} iPadOS  - Build for iPad (macOS only)"
    echo -e "  ${CYAN}4)${NC} macOS   - Build for Mac desktop (macOS only)"
    echo -e "  ${CYAN}5)${NC} Windows - Build for Windows desktop"
    echo ""
    
    while true; do
        read -p "$(echo -e ${YELLOW}Enter choice [1-5]: ${NC})" choice
        case $choice in
            1) PLATFORM="android"; break;;
            2) PLATFORM="ios"; break;;
            3) PLATFORM="ipados"; break;;
            4) PLATFORM="macos"; break;;
            5) PLATFORM="windows"; break;;
            *) print_error "Invalid choice. Please enter 1, 2, 3, 4, or 5.";;
        esac
    done
    
    print_success "Selected: $PLATFORM platform"
}

select_install() {
    # Install option not available for desktop platforms
    if [[ "$PLATFORM" == "macos" || "$PLATFORM" == "windows" ]]; then
        print_info "Install option not applicable for $PLATFORM - app will be built and can be run directly"
        INSTALL_ON_DEVICE=false
        return
    fi
    
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
    print_step "Building for iOS/iPhone ($BUILD_MODE)"
    
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

build_ipados() {
    print_step "Building for iPadOS ($BUILD_MODE)"
    
    if [[ "$(uname)" != "Darwin" ]]; then
        print_error "iPadOS builds are only supported on macOS"
        return 1
    fi
    
    cd "$FLUTTER_PROJECT_DIR"
    
    # Install CocoaPods dependencies
    print_info "Installing CocoaPods dependencies..."
    cd ios
    pod install --repo-update || print_warning "Pod install had warnings"
    cd ..
    
    # iPadOS uses the same iOS build but targets iPad
    local build_command="flutter build ios"
    
    if [ "$BUILD_MODE" = "release" ]; then
        build_command="$build_command --release --no-codesign"
    else
        build_command="$build_command --debug --no-codesign"
    fi
    
    print_info "Running: $build_command"
    print_info "Note: iPadOS uses the iOS build - app supports both iPhone and iPad"
    eval $build_command
    
    print_success "iPadOS build completed!"
    print_info "Note: For App Store distribution, open Xcode and archive the project."
}

build_macos() {
    print_step "Building for macOS ($BUILD_MODE)"
    
    if [[ "$(uname)" != "Darwin" ]]; then
        print_error "macOS builds are only supported on macOS"
        return 1
    fi
    
    cd "$FLUTTER_PROJECT_DIR"
    
    # Install CocoaPods dependencies for macOS
    print_info "Installing CocoaPods dependencies..."
    cd macos
    pod install --repo-update || print_warning "Pod install had warnings"
    cd ..
    
    local build_command="flutter build macos"
    
    if [ "$BUILD_MODE" = "release" ]; then
        build_command="$build_command --release"
    else
        build_command="$build_command --debug"
    fi
    
    print_info "Running: $build_command"
    eval $build_command
    
    print_success "macOS build completed!"
    
    # Show output location
    local app_path="$FLUTTER_PROJECT_DIR/build/macos/Build/Products"
    if [ "$BUILD_MODE" = "release" ]; then
        app_path="$app_path/Release"
    else
        app_path="$app_path/Debug"
    fi
    
    print_info "Output: $app_path/"
    print_info "You can run the app directly from the build folder."
}

build_windows() {
    print_step "Building for Windows ($BUILD_MODE)"
    
    cd "$FLUTTER_PROJECT_DIR"
    
    local build_command="flutter build windows"
    
    if [ "$BUILD_MODE" = "release" ]; then
        build_command="$build_command --release"
    else
        build_command="$build_command --debug"
    fi
    
    print_info "Running: $build_command"
    eval $build_command
    
    print_success "Windows build completed!"
    
    # Show output location
    local exe_path="$FLUTTER_PROJECT_DIR/build/windows/x64/runner"
    if [ "$BUILD_MODE" = "release" ]; then
        exe_path="$exe_path/Release"
    else
        exe_path="$exe_path/Debug"
    fi
    
    print_info "Output: $exe_path/"
    print_info "You can run the .exe file directly from the build folder."
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
    local devices=$(flutter devices | grep -i -E "iphone|ipad")
    
    if [ -z "$devices" ]; then
        print_warning "No iOS/iPadOS device connected. Skipping installation."
        return
    fi
    
    print_info "Found iOS/iPadOS device(s):"
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
    
    case "$PLATFORM" in
        android)
            if [ "$BUILD_MODE" = "release" ]; then
                print_info "Android APK: $FLUTTER_PROJECT_DIR/build/app/outputs/flutter-apk/app-release.apk"
            else
                print_info "Android APK: $FLUTTER_PROJECT_DIR/build/app/outputs/flutter-apk/app-debug.apk"
            fi
            ;;
        ios|ipados)
            print_info "iOS/iPadOS Build: $FLUTTER_PROJECT_DIR/build/ios/iphoneos/"
            ;;
        macos)
            if [ "$BUILD_MODE" = "release" ]; then
                print_info "macOS App: $FLUTTER_PROJECT_DIR/build/macos/Build/Products/Release/"
            else
                print_info "macOS App: $FLUTTER_PROJECT_DIR/build/macos/Build/Products/Debug/"
            fi
            ;;
        windows)
            if [ "$BUILD_MODE" = "release" ]; then
                print_info "Windows Exe: $FLUTTER_PROJECT_DIR/build/windows/x64/runner/Release/"
            else
                print_info "Windows Exe: $FLUTTER_PROJECT_DIR/build/windows/x64/runner/Debug/"
            fi
            ;;
    esac
    
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
                if [[ "$PLATFORM" != "android" && "$PLATFORM" != "ios" && "$PLATFORM" != "ipados" && "$PLATFORM" != "macos" && "$PLATFORM" != "windows" ]]; then
                    print_error "Invalid platform: $PLATFORM (must be 'android', 'ios', 'ipados', 'macos', or 'windows')"
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
            --interactive)
                INTERACTIVE=true
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
    
    # Interactive mode if explicitly requested
    if [ "$INTERACTIVE" = true ]; then
        select_build_mode
        select_platform
        select_install
        
        # Print build summary
        print_build_summary
        
        # Confirm before proceeding
        echo ""
        read -p "$(echo -e ${YELLOW}Proceed with build? [Y/n]: ${NC})" confirm
        case $confirm in
            [Nn]*)
                print_info "Build cancelled."
                exit 0
                ;;
        esac
    else
        # Print build summary (using defaults or provided options)
        print_build_summary
    fi
    
    # Run build steps
    check_prerequisites
    get_dependencies
    format_code
    analyze_code
    
    # Build for selected platform
    case "$PLATFORM" in
        android)
            build_android
            if [ "$INSTALL_ON_DEVICE" = true ]; then
                install_android
            fi
            ;;
        ios)
            build_ios
            if [ "$INSTALL_ON_DEVICE" = true ]; then
                install_ios
            fi
            ;;
        ipados)
            build_ipados
            if [ "$INSTALL_ON_DEVICE" = true ]; then
                install_ios
            fi
            ;;
        macos)
            build_macos
            ;;
        windows)
            build_windows
            ;;
    esac
    
    # Print completion message
    print_completion
}

# Run main function
main "$@"
