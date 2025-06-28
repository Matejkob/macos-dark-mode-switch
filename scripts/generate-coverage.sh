#!/bin/bash

# Script to generate code coverage reports for DarkModeSwitch project
# Usage: ./scripts/generate-coverage.sh [build_dir]

set -e  # Exit on any error

# Configuration
BUILD_DIR="${1:-.build}"
COVERAGE_OUTPUT="coverage_report.lcov"
COVERAGE_HTML_DIR="coverage_output"

echo "🔍 Generating code coverage report..."
echo "Build directory: $BUILD_DIR"

# Function to check if a file exists and is executable
check_executable() {
    local file="$1"
    if [ -f "$file" ]; then
        echo "✅ Found: $file"
        return 0
    else
        echo "❌ Missing: $file"
        return 1
    fi
}

# Find all test executables and binaries
echo ""
echo "=== Finding all executables and frameworks ==="
find "$BUILD_DIR" -name "*.xctest" -type d | while read -r bundle; do
    echo "Found test bundle: $bundle"
done

find "$BUILD_DIR" -name "*.framework" -type d | while read -r framework; do
    echo "Found framework: $framework"
done

# Find the App.debug.dylib which contains App target coverage data
APP_DYLIB=$(find "$BUILD_DIR" -name "App.debug.dylib" | head -n 1)

if [ ! -f "$APP_DYLIB" ]; then
    echo "⚠️  Warning: Could not find App.debug.dylib"
    APP_DYLIB=""
else
    echo "✅ Found App.debug.dylib: $APP_DYLIB"
fi

# Find all test bundles
TEST_BUNDLES=$(find "$BUILD_DIR" -name "*.xctest" -type d)

if [ -z "$TEST_BUNDLES" ]; then
    echo "❌ Error: No test bundles found"
    exit 1
fi

# Find the profdata file
PROFDATA_PATH=$(find "$BUILD_DIR" -name "*.profdata" | head -n 1)

if [ -z "$PROFDATA_PATH" ]; then
    echo "❌ Error: Could not find profdata file"
    echo "Make sure to run tests with code coverage enabled:"
    echo "xcodebuild test -enableCodeCoverage YES ..."
    exit 1
fi

echo ""
echo "=== Coverage gathering configuration ==="
echo "Profile data: $PROFDATA_PATH"

# Collect all executables for coverage (including App.debug.dylib)
ALL_EXECUTABLES=""
ADDED_EXECUTABLES=""

# Add App.debug.dylib if it has coverage data
if [ -n "$APP_DYLIB" ] && [ -f "$APP_DYLIB" ]; then
    echo "Testing if App.debug.dylib has coverage data..."
    if xcrun llvm-cov report "$APP_DYLIB" -instr-profile="$PROFDATA_PATH" >/dev/null 2>&1; then
        ALL_EXECUTABLES="$APP_DYLIB"
        echo "✅ Added App.debug.dylib with coverage: $APP_DYLIB"
    else
        echo "⚠️  App.debug.dylib has no coverage data, skipping: $APP_DYLIB"
    fi
fi

# Add all test executables
for bundle in $TEST_BUNDLES; do
    executable_name=$(basename "$bundle" .xctest)
    executable_path="$bundle/Contents/MacOS/$executable_name"
    
    # Check if we already added this executable
    if echo "$ADDED_EXECUTABLES" | grep -q "$executable_path"; then
        echo "Skipping duplicate: $executable_path"
        continue
    fi
    
    if check_executable "$executable_path"; then
        # Test if this executable has coverage data
        if xcrun llvm-cov report "$executable_path" -instr-profile="$PROFDATA_PATH" >/dev/null 2>&1; then
            if [ -z "$ALL_EXECUTABLES" ]; then
                ALL_EXECUTABLES="$executable_path"
            else
                ALL_EXECUTABLES="$ALL_EXECUTABLES -object $executable_path"
            fi
            ADDED_EXECUTABLES="$ADDED_EXECUTABLES $executable_path"
            echo "✅ Added test executable with coverage: $executable_path"
        else
            echo "⚠️  Skipping executable with no coverage data: $executable_path"
        fi
    fi
done

if [ -z "$ALL_EXECUTABLES" ]; then
    echo "❌ Error: No executables found for coverage analysis"
    exit 1
fi


echo ""
echo "=== Generating detailed coverage output ==="
echo "Command: xcrun llvm-cov report $ALL_EXECUTABLES -instr-profile=\"$PROFDATA_PATH\""

# Use show command to see source file coverage
xcrun llvm-cov show \
    $ALL_EXECUTABLES \
    -instr-profile="$PROFDATA_PATH" \
    -format=text \
    -output-dir="$COVERAGE_HTML_DIR" || echo "llvm-cov show failed"

# List what files were found
if [ -d "$COVERAGE_HTML_DIR" ]; then
    echo ""
    echo "=== Coverage output files ==="
    find "$COVERAGE_HTML_DIR" -name "*.txt" | head -20
    
    echo ""
    echo "=== Looking for App source files in coverage ==="
    find "$COVERAGE_HTML_DIR" -name "*.txt" | grep -E "(DarkMode|MenuBar|Settings|Features)" || echo "No App source files found in coverage"
    
    echo ""
    echo "=== All source files (non-test) in coverage ==="
    find "$COVERAGE_HTML_DIR" -name "*.txt" | grep -v Tests | grep Sources || echo "No source files found"
fi

# Generate coverage report WITHOUT filtering first to see what's actually there
echo ""
echo "=== RAW coverage report (no filtering) ==="
xcrun llvm-cov report \
    $ALL_EXECUTABLES \
    -instr-profile="$PROFDATA_PATH" \
    -use-color

echo ""
echo "=== Looking for App target source files specifically ==="
xcrun llvm-cov export -format="lcov" \
    $ALL_EXECUTABLES \
    -instr-profile="$PROFDATA_PATH" \
    | grep "^SF:" | grep -v Tests | grep -v Packages || echo "No App target files found in raw coverage"

# Generate coverage report with filtering
echo ""
echo "=== Filtered coverage report ==="
xcrun llvm-cov report \
    $ALL_EXECUTABLES \
    -instr-profile="$PROFDATA_PATH" \
    -ignore-filename-regex="Tests|\.build" \
    -use-color

# Export to LCOV format with filters to exclude test files
echo ""
echo "=== Exporting to LCOV format ==="
xcrun llvm-cov export -format="lcov" \
    $ALL_EXECUTABLES \
    -instr-profile="$PROFDATA_PATH" \
    -ignore-filename-regex="Tests|\.build" \
    > "$COVERAGE_OUTPUT"

echo ""
echo "=== Coverage report generated ==="
echo "LCOV file: $COVERAGE_OUTPUT"
echo "LCOV file size: $(wc -c < "$COVERAGE_OUTPUT") bytes"

# Debug: Show first few lines of LCOV if not empty
if [ -s "$COVERAGE_OUTPUT" ]; then
    echo ""
    echo "First 10 lines of LCOV report:"
    head -n 10 "$COVERAGE_OUTPUT"
fi

echo ""
echo "✅ Coverage generation complete!"
echo "📊 LCOV report: $COVERAGE_OUTPUT"
if [ -d "$COVERAGE_HTML_DIR" ]; then
    echo "📁 Detailed coverage: $COVERAGE_HTML_DIR/"
fi