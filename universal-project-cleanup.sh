#!/bin/bash

###############################################################################
# Universal Project Cleanup Script
# 
# This script automatically detects and cleans development projects:
# - Flutter/Dart projects
# - Node.js/npm projects
# - Kotlin/Java (Android/Gradle) projects
# - Swift/iOS projects
#
# Usage: ./universal-project-cleanup.sh [directory]
#        If no directory is provided, uses current directory
#
# Author: Auto-generated cleanup script
# Version: 1.0.0
###############################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Statistics
TOTAL_PROJECTS=0
FLUTTER_PROJECTS=0
NODE_PROJECTS=0
KOTLIN_JAVA_PROJECTS=0
SWIFT_PROJECTS=0
TOTAL_SIZE_FREED=0

###############################################################################
# Helper Functions
###############################################################################

print_header() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Get directory size in bytes
get_dir_size() {
    if [ -d "$1" ]; then
        du -sb "$1" 2>/dev/null | cut -f1 || echo "0"
    else
        echo "0"
    fi
}

# Format bytes to human readable
format_size() {
    local bytes=$1
    if [ "$bytes" -gt 1073741824 ]; then
        echo "$(awk "BEGIN {printf \"%.2f\", $bytes/1073741824}")GB"
    elif [ "$bytes" -gt 1048576 ]; then
        echo "$(awk "BEGIN {printf \"%.2f\", $bytes/1048576}")MB"
    elif [ "$bytes" -gt 1024 ]; then
        echo "$(awk "BEGIN {printf \"%.2f\", $bytes/1024}")KB"
    else
        echo "${bytes}B"
    fi
}

###############################################################################
# Project Type Detection
###############################################################################

is_flutter_project() {
    [ -f "$1/pubspec.yaml" ] && [ -d "$1/lib" ]
}

is_node_project() {
    [ -f "$1/package.json" ]
}

is_kotlin_java_project() {
    [ -f "$1/build.gradle" ] || [ -f "$1/build.gradle.kts" ] || [ -f "$1/pom.xml" ] || [ -f "$1/settings.gradle" ] || [ -f "$1/settings.gradle.kts" ]
}

is_swift_project() {
    [ -f "$1/Package.swift" ] || [ -d "$1"/*.xcodeproj ] || [ -d "$1"/*.xcworkspace ] || find "$1" -maxdepth 2 -name "*.xcodeproj" -o -name "*.xcworkspace" | grep -q .
}

detect_project_type() {
    local dir=$1
    
    if is_flutter_project "$dir"; then
        echo "flutter"
    elif is_node_project "$dir"; then
        echo "node"
    elif is_kotlin_java_project "$dir"; then
        echo "kotlin_java"
    elif is_swift_project "$dir"; then
        echo "swift"
    else
        echo "unknown"
    fi
}

###############################################################################
# Cleanup Functions
###############################################################################

clean_flutter_project() {
    local project_dir=$1
    local project_name=$(basename "$project_dir")
    
    print_info "Cleaning Flutter project: $project_name"
    
    cd "$project_dir" || return 1
    
    # Calculate size before cleanup
    local size_before=0
    if [ -d "build" ]; then
        size_before=$(get_dir_size "build")
    fi
    if [ -d ".dart_tool" ]; then
        size_before=$((size_before + $(get_dir_size ".dart_tool")))
    fi
    if [ -d "ios/Pods" ]; then
        size_before=$((size_before + $(get_dir_size "ios/Pods")))
    fi
    if [ -d "ios/build" ]; then
        size_before=$((size_before + $(get_dir_size "ios/build")))
    fi
    if [ -d "android/build" ]; then
        size_before=$((size_before + $(get_dir_size "android/build")))
    fi
    
    # Run flutter clean if flutter is available
    if command -v flutter &> /dev/null; then
        flutter clean > /dev/null 2>&1 || print_warning "flutter clean failed (continuing anyway)"
    fi
    
    # Remove Flutter-specific directories
    rm -rf build .dart_tool .flutter-plugins .flutter-plugins-dependencies 2>/dev/null || true
    rm -rf ios/Pods ios/Podfile.lock ios/.symlinks ios/.flutter-plugins 2>/dev/null || true
    rm -rf ios/build ios/DerivedData 2>/dev/null || true
    rm -rf android/build android/.gradle android/app/build 2>/dev/null || true
    rm -rf macos/Pods macos/.symlinks macos/.flutter-plugins 2>/dev/null || true
    rm -rf macos/build macos/DerivedData 2>/dev/null || true
    rm -rf linux/build 2>/dev/null || true
    rm -rf windows/build 2>/dev/null || true
    rm -rf web/build 2>/dev/null || true
    
    local size_freed=$(format_size $size_before)
    if [ "$size_before" -gt 0 ]; then
        print_success "Freed $size_freed from $project_name"
        TOTAL_SIZE_FREED=$((TOTAL_SIZE_FREED + size_before))
    fi
    
    FLUTTER_PROJECTS=$((FLUTTER_PROJECTS + 1))
    return 0
}

clean_node_project() {
    local project_dir=$1
    local project_name=$(basename "$project_dir")
    
    print_info "Cleaning Node.js project: $project_name"
    
    cd "$project_dir" || return 1
    
    # Calculate size before cleanup
    local size_before=0
    if [ -d "node_modules" ]; then
        size_before=$(get_dir_size "node_modules")
    fi
    if [ -d ".next" ]; then
        size_before=$((size_before + $(get_dir_size ".next")))
    fi
    if [ -d ".nuxt" ]; then
        size_before=$((size_before + $(get_dir_size ".nuxt")))
    fi
    if [ -d "dist" ]; then
        size_before=$((size_before + $(get_dir_size "dist")))
    fi
    if [ -d "build" ]; then
        size_before=$((size_before + $(get_dir_size "build")))
    fi
    if [ -d ".cache" ]; then
        size_before=$((size_before + $(get_dir_size ".cache")))
    fi
    if [ -d ".turbo" ]; then
        size_before=$((size_before + $(get_dir_size ".turbo")))
    fi
    if [ -d ".yarn/cache" ]; then
        size_before=$((size_before + $(get_dir_size ".yarn/cache")))
    fi
    
    # Remove Node.js-specific directories
    rm -rf node_modules 2>/dev/null || true
    rm -rf .next .nuxt dist build .cache .turbo 2>/dev/null || true
    rm -rf .yarn/cache .yarn/unplugged .yarn/build-state.yml 2>/dev/null || true
    rm -rf coverage .nyc_output 2>/dev/null || true
    rm -rf .parcel-cache 2>/dev/null || true
    
    local size_freed=$(format_size $size_before)
    if [ "$size_before" -gt 0 ]; then
        print_success "Freed $size_freed from $project_name"
        TOTAL_SIZE_FREED=$((TOTAL_SIZE_FREED + size_before))
    fi
    
    NODE_PROJECTS=$((NODE_PROJECTS + 1))
    return 0
}

clean_kotlin_java_project() {
    local project_dir=$1
    local project_name=$(basename "$project_dir")
    
    print_info "Cleaning Kotlin/Java project: $project_name"
    
    cd "$project_dir" || return 1
    
    # Calculate size before cleanup
    local size_before=0
    if [ -d "build" ]; then
        size_before=$(get_dir_size "build")
    fi
    if [ -d ".gradle" ]; then
        size_before=$((size_before + $(get_dir_size ".gradle")))
    fi
    if [ -d "app/build" ]; then
        size_before=$((size_before + $(get_dir_size "app/build")))
    fi
    if [ -d ".idea" ]; then
        # Only clean .idea/caches, not the whole .idea directory
        if [ -d ".idea/caches" ]; then
            size_before=$((size_before + $(get_dir_size ".idea/caches")))
        fi
    fi
    
    # Remove Kotlin/Java-specific directories
    rm -rf build .gradle 2>/dev/null || true
    find . -type d -name "build" -exec rm -rf {} + 2>/dev/null || true
    rm -rf .idea/caches .idea/libraries 2>/dev/null || true
    rm -rf out 2>/dev/null || true
    rm -rf target 2>/dev/null || true  # Maven
    
    # Clean Gradle wrapper cache if exists
    if [ -d ".gradle" ]; then
        rm -rf .gradle 2>/dev/null || true
    fi
    
    local size_freed=$(format_size $size_before)
    if [ "$size_before" -gt 0 ]; then
        print_success "Freed $size_freed from $project_name"
        TOTAL_SIZE_FREED=$((TOTAL_SIZE_FREED + size_before))
    fi
    
    KOTLIN_JAVA_PROJECTS=$((KOTLIN_JAVA_PROJECTS + 1))
    return 0
}

clean_swift_project() {
    local project_dir=$1
    local project_name=$(basename "$project_dir")
    
    print_info "Cleaning Swift/iOS project: $project_name"
    
    cd "$project_dir" || return 1
    
    # Calculate size before cleanup
    local size_before=0
    if [ -d ".build" ]; then
        size_before=$(get_dir_size ".build")
    fi
    if [ -d "DerivedData" ]; then
        size_before=$((size_before + $(get_dir_size "DerivedData")))
    fi
    if [ -d "Pods" ]; then
        size_before=$((size_before + $(get_dir_size "Pods")))
    fi
    if [ -d "build" ]; then
        size_before=$((size_before + $(get_dir_size "build")))
    fi
    
    # Remove Swift/iOS-specific directories
    rm -rf .build DerivedData build 2>/dev/null || true
    rm -rf Pods Podfile.lock .symlinks 2>/dev/null || true
    rm -rf .swiftpm 2>/dev/null || true
    
    # Clean Xcode build products
    find . -type d -name "DerivedData" -exec rm -rf {} + 2>/dev/null || true
    find . -type d -name "*.xcworkspace/xcuserdata" -exec rm -rf {} + 2>/dev/null || true
    find . -type d -name "*.xcodeproj/xcuserdata" -exec rm -rf {} + 2>/dev/null || true
    
    local size_freed=$(format_size $size_before)
    if [ "$size_before" -gt 0 ]; then
        print_success "Freed $size_freed from $project_name"
        TOTAL_SIZE_FREED=$((TOTAL_SIZE_FREED + size_before))
    fi
    
    SWIFT_PROJECTS=$((SWIFT_PROJECTS + 1))
    return 0
}

###############################################################################
# Main Cleanup Function
###############################################################################

clean_project() {
    local project_dir=$1
    
    if [ ! -d "$project_dir" ]; then
        print_error "Directory does not exist: $project_dir"
        return 1
    fi
    
    local project_type=$(detect_project_type "$project_dir")
    
    case "$project_type" in
        flutter)
            clean_flutter_project "$project_dir"
            ;;
        node)
            clean_node_project "$project_dir"
            ;;
        kotlin_java)
            clean_kotlin_java_project "$project_dir"
            ;;
        swift)
            clean_swift_project "$project_dir"
            ;;
        unknown)
            print_warning "Unknown project type in: $(basename "$project_dir")"
            return 0
            ;;
    esac
    
    TOTAL_PROJECTS=$((TOTAL_PROJECTS + 1))
}

###############################################################################
# Recursive Directory Traversal
###############################################################################

traverse_and_clean() {
    local root_dir=$1
    local depth=${2:-0}
    local max_depth=${3:-5}  # Prevent infinite recursion
    
    if [ "$depth" -gt "$max_depth" ]; then
        return 0
    fi
    
    # Check if current directory is a project
    local project_type=$(detect_project_type "$root_dir")
    
    if [ "$project_type" != "unknown" ]; then
        # This is a project, clean it and don't go deeper
        clean_project "$root_dir"
        return 0
    fi
    
    # Not a project, traverse subdirectories
    for subdir in "$root_dir"/*; do
        if [ -d "$subdir" ]; then
            local dirname=$(basename "$subdir")
            
            # Skip common non-project directories
            if [[ "$dirname" =~ ^(node_modules|build|.git|.idea|.vscode|.dart_tool|Pods|DerivedData|.gradle|target|out|dist|.next|.nuxt|.cache|.turbo)$ ]]; then
                continue
            fi
            
            traverse_and_clean "$subdir" $((depth + 1)) "$max_depth"
        fi
    done
}

###############################################################################
# Main Script
###############################################################################

main() {
    print_header "Universal Project Cleanup Script"
    
    # Determine root directory
    local root_dir="${1:-$(pwd)}"
    
    if [ ! -d "$root_dir" ]; then
        print_error "Directory does not exist: $root_dir"
        exit 1
    fi
    
    root_dir=$(cd "$root_dir" && pwd)  # Get absolute path
    print_info "Scanning directory: $root_dir"
    echo ""
    
    # Start traversal
    traverse_and_clean "$root_dir"
    
    # Print summary
    echo ""
    print_header "Cleanup Summary"
    echo -e "Total projects cleaned: ${GREEN}$TOTAL_PROJECTS${NC}"
    echo -e "  - Flutter projects: ${GREEN}$FLUTTER_PROJECTS${NC}"
    echo -e "  - Node.js projects: ${GREEN}$NODE_PROJECTS${NC}"
    echo -e "  - Kotlin/Java projects: ${GREEN}$KOTLIN_JAVA_PROJECTS${NC}"
    echo -e "  - Swift/iOS projects: ${GREEN}$SWIFT_PROJECTS${NC}"
    echo ""
    
    local total_freed=$(format_size $TOTAL_SIZE_FREED)
    print_success "Total storage freed: $total_freed"
    echo ""
    
    print_info "Cleanup completed successfully!"
    print_warning "Note: You may need to run 'flutter pub get', 'npm install', or rebuild your projects."
    echo ""
}

# Run main function
main "$@"

