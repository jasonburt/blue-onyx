<div style="display: flex; justify-content: space-between; align-items: flex-start; width: 100%;">
    <img src="assets/logo_medium.png" alt="blue_onyx" style="height: 200px;" />
    <img src="assets/demo.jpg" alt="blue_onyx" style="height: 200px;" />
</div>


# Object Detection Service

Object detection service written in Rust with Onnx inference engine.
Supports Blue Iris and Agent DVR.

## TL;DR

Current features:

| Feature                                     | Windows x86_64 | Linux x86_64 |
|---------------------------------------------|:--------------:|:------------:|
| RT-DETR-V2 ONNX Models                      | 🟢             | 🟢          |
| Yolo 5 ONNX Models (including custom)       | 🟢             | 🟢          |
| Run as a service                            | 🟢             | ❌          |
| Docker image                                | ❌             | 🟢          |
| CPU Inference                               | 🟢             | 🟢          |
| AMD GPU Inference                           | 🟢             | ❌          |
| Intel GPU Inference                         | 🟢             | ❌          |
| Nvidia GPU Inference                        | 🟢             | ❌          |
| Coral TPU Inference                         | ❌             | ❌          |


## Install on Windows with THE one mighty oneliner

```powershell
 powershell -NoProfile -Command "curl 'https://github.com/xnorpx/blue-onyx/releases/latest/download/install_latest_blue_onyx.ps1' -o 'install_latest_blue_onyx.ps1'; Unblock-File '.\install_latest_blue_onyx.ps1'; powershell.exe -ExecutionPolicy Bypass -File '.\install_latest_blue_onyx.ps1'"
```

## Install as service on Windows

**Note: You need to run as administrator to register the service and change the install path and command line arguments for your setup.**
```powershell
sc.exe create blue_onyx_service binPath= "$env:USERPROFILE\.blue-onyx\blue_onyx_service.exe --port 32168" start= auto displayname= "Blue Onyx Service"
net start blue_onyx_service
```

Verify it is working by going to http://127.0.0.1:32168/

(If you don't want to run blue_onyx as a service you can just run blue_onyx.exe)

## Docker container on Linux

```bash
docker pull ghcr.io/xnorpx/blue_onyx:latest
docker run -d -p 32168:32168 ghcr.io/xnorpx/blue_onyx:latest --log-level debug --port 32168
```

## I don't trust scripts I want to install myself

- [Download latest release](https://github.com/xnorpx/blue-onyx/releases)
- Unzip
- Run blue_onyx

## Notes on Linux

If you run outside of docker you need to install OpenSSL 3

## Installation on Mac ARM (M1/M2) Architecture

### Prerequisites

1. Install Rust for ARM architecture:
```bash
# Install Rust using rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Ensure you have the ARM64 target
rustup target add aarch64-apple-darwin
```

2. Install required dependencies:
```bash
# Install OpenSSL (required for building)
brew install openssl

# Install additional system dependencies
brew install cmake
```

### Compiling Blue Onyx

1. Clone the repository:
```bash
git clone https://github.com/xnorpx/blue-onyx.git
cd blue-onyx
```

2. Set environment variables for OpenSSL (important for ARM Macs):
```bash
export OPENSSL_DIR=$(brew --prefix openssl)
export OPENSSL_INCLUDE_DIR=$OPENSSL_DIR/include
export OPENSSL_LIB_DIR=$OPENSSL_DIR/lib
```

3. Build the project:
```bash
# For debug build
cargo build

# For release build (recommended)
cargo build --release
```

### Running Blue Onyx

After compilation, you can run the binary:
```bash
# Debug build
./target/debug/blue-onyx

# Release build
./target/release/blue-onyx
```

### Notes for Mac ARM Users

- Ensure you're using the latest version of Rust
- Some dependencies might require additional configuration for ARM architecture
- If you encounter any build issues, check the project's GitHub issues or open a new issue

## Tips

Help:
```bash
blue_onyx.exe --help
```

Download models:
```bash
blue_onyx.exe --download-model-path .
```

Run service with larger model:
```bash
blue_onyx.exe --model rt-detrv2-x.onnx
Initializing detector with model: "rt-detrv2-x.onnx"
```

Benchmark GPU
```bash
blue_onyx_benchmark.exe --repeat 100 --save-stats-path .
Device Name,Version,Type,Platform,EndpointProvider,Images,Total [s],Min [ms],Max [ms],Average [ms],FPS
Intel(R) Iris(R) Xe Graphics,0.1.0,GPU,Windows,DML,100,14.3,116.8,168.3,143.2,7.0
```

Benchmark CPU
```bash
blue_onyx_benchmark.exe --repeat 100 --save-stats-path . --force-cpu
Device Name,Version,Type,Platform,EndpointProvider,Images,Total [s],Min [ms],Max [ms],Average [ms],FPS
12th Gen Intel(R) Core(TM) i7-1265U,0.1.0,CPU,Windows,CPU,100,28.2,239.6,398.2,281.5,3.6
```

Test Service
```bash
blue_onyx.exe
```

Then run in another terminal do 100 requests with 100 ms interval
```bash
test_blue_onyx.exe --number-of-requests 100 --interval 100
```

Test image and save image with boundary box use --image to specify your own image.
```bash
blue_onyx_benchmark.exe --save-image-path .
```

<div align="center">
    <img src="assets/dog_bike_car_od.jpg" alt="dog_bike_car_od"/>
</div>
