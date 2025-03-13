#!/bin/bash

# Blue Onyx Mac ARM Setup Script
# Version 1.0

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print status messages
print_status() {
    echo -e "${BLUE}[BLUE ONYX SETUP]${NC} $1"
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

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Validate macOS ARM architecture
validate_architecture() {
    print_status "Checking system architecture..."
    arch=$(uname -m)
    if [[ "$arch" != "arm64" ]]; then
        print_error "This script is designed for Mac ARM (M1/M2) architecture. Detected: $arch"
    fi
    print_success "Confirmed Mac ARM architecture"
}

# Check and install Homebrew
install_homebrew() {
    print_status "Checking Homebrew installation..."
    if ! command_exists brew; then
        print_status "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    brew update
    print_success "Homebrew is installed and updated"
}

# Install required dependencies
install_dependencies() {
    print_status "Installing required dependencies..."
    
    # OpenSSL
    print_status "Installing OpenSSL..."
    brew install openssl
    
    # CMake
    print_status "Installing CMake..."
    brew install cmake
    
    # Additional development tools
    print_status "Installing additional development tools..."
    brew install pkg-config
    
    print_success "All dependencies installed"
}

# Install Rust
install_rust() {
    print_status "Checking Rust installation..."
    if ! command_exists rustc; then
        print_status "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    fi
    
    print_status "Adding ARM64 Rust target..."
    rustup target add aarch64-apple-darwin
    
    print_success "Rust is installed with ARM64 target"
}

# Clone Blue Onyx repository
clone_repository() {
    print_status "Cloning Blue Onyx repository..."
    
    # Check if repository already exists
    if [ -d "blue-onyx" ]; then
        print_status "Blue Onyx directory already exists. Updating..."
        cd blue-onyx
        git pull
    else
        git clone https://github.com/xnorpx/blue-onyx.git
        cd blue-onyx
    fi
    
    print_success "Blue Onyx repository is ready"
}

# Set up environment variables
setup_environment() {
    print_status "Setting up environment variables..."
    
    export OPENSSL_DIR=$(brew --prefix openssl)
    export OPENSSL_INCLUDE_DIR=$OPENSSL_DIR/include
    export OPENSSL_LIB_DIR=$OPENSSL_DIR/lib
    
    print_success "Environment variables configured"
}

# Build Blue Onyx
build_blue_onyx() {
    print_status "Building Blue Onyx..."
    
    cargo build --release
    
    print_success "Blue Onyx built successfully"
}

# Main setup function
main() {
    clear
    echo -e "${YELLOW}Blue Onyx Mac ARM Setup Script${NC}"
    echo "-----------------------------------"
    
    validate_architecture
    install_homebrew
    install_dependencies
    install_rust
    clone_repository
    setup_environment
    build_blue_onyx
    
    echo -e "\n${GREEN}✓ Blue Onyx Setup Complete!${NC}"
    echo -e "You can now run the Blue Onyx binary at: ${BLUE}./target/release/blue-onyx${NC}"
}

# Run the main setup function
main