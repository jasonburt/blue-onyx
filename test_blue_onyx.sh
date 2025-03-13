#!/bin/bash

# Blue Onyx Installation Test Script
# Version 1.0

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print status messages
print_status() {
    echo -e "${BLUE}[BLUE ONYX TEST]${NC} $1"
}

# Function to print success messages
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Function to print error messages
print_error() {
    echo -e "${RED}✗ $1${NC}"
    exit 1
}

# Validate binary exists
validate_binary() {
    print_status "Checking Blue Onyx binary..."
    if [ ! -f "./target/release/blue-onyx" ]; then
        print_error "Blue Onyx binary not found. Please compile the project first."
    fi
    print_success "Blue Onyx binary found"
}

# Test help command
test_help_command() {
    print_status "Testing help command..."
    output=$(./target/release/blue-onyx --help)
    if [[ $? -ne 0 ]]; then
        print_error "Help command failed"
    fi
    
    # Check for key help text
    if [[ ! "$output" =~ "Usage:" ]]; then
        print_error "Help output does not contain expected content"
    fi
    
    print_success "Help command works correctly"
}

# Start service and test basic connectivity
test_service_startup() {
    print_status "Starting Blue Onyx service..."
    
    # Kill any existing instances
    pkill -f blue-onyx
    
    # Start service in background
    ./target/release/blue-onyx &
    SERVICE_PID=$!
    
    # Wait for service to start
    sleep 5
    
    # Test service connectivity
    response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:32168)
    
    if [[ "$response" != "200" ]]; then
        print_error "Service not responding. HTTP status: $response"
    fi
    
    print_success "Service started and responding"
    
    # Kill the service
    kill $SERVICE_PID
    wait $SERVICE_PID 2>/dev/null
}

# Test model download
test_model_download() {
    print_status "Testing model download..."
    
    # Create a temporary directory
    temp_dir=$(mktemp -d)
    
    # Download models
    ./target/release/blue-onyx --download-model-path "$temp_dir"
    
    if [ ! -f "$temp_dir/rt-detrv2-s.onnx" ]; then
        print_error "Model download failed"
    fi
    
    # Clean up
    rm -rf "$temp_dir"
    
    print_success "Model download successful"
}

# Main test function
main() {
    clear
    echo -e "${YELLOW}Blue Onyx Installation Test Script${NC}"
    echo "-----------------------------------"
    
    validate_binary
    test_help_command
    test_service_startup
    test_model_download
    
    echo -e "\n${GREEN}✓ All Blue Onyx Tests Passed Successfully!${NC}"
}

# Run the main test function
main