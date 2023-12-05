# Use Ubuntu as the base image
FROM ubuntu:latest

# Set non-interactive installation mode
ENV DEBIAN_FRONTEND=noninteractive

# Set environment variables for Android and Flutter
ENV ANDROID_HOME=/usr/lib/android-sdk
ENV ANDROID_SDK_ROOT=$ANDROID_HOME
ENV FLUTTER_HOME=/flutter
ENV PATH="$PATH:$FLUTTER_HOME/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"

# Install necessary dependencies for GUI support, Android/Flutter development, Linux development, CMake/Ninja, and Android Emulator
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-11-jdk \
    x11-apps \
    cmake \
    clang \
    pkg-config \
    libgtk-3-dev \
    ninja-build \
    qemu-kvm \
    libvirt-daemon-system \
    libvirt-clients \
    bridge-utils \
    libqt5widgets5 \
    libqt5gui5 \
    libqt5core5a \
    libgl1-mesa-glx \
    libqt5x11extras5 \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-render-util0 \
    libxcb-render0 \
    libxcb-shape0 \
    libxcb-sync1 \
    libxcb-xfixes0 \
    libxcb-xinerama0 \
    libxkbcommon-x11-0 \
    libxkbcommon0 \
    libxcb-xinerama0 \
    && rm -rf /var/lib/apt/lists/*
    
# Download and install Android SDK
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    cd ${ANDROID_HOME}/cmdline-tools && \
    curl -o cmdline-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip && \
    unzip cmdline-tools.zip && \
    rm cmdline-tools.zip && \
    mv cmdline-tools latest

# Accept Android SDK licenses
RUN yes | sdkmanager --licenses

# Clean any existing emulator installations and install Android SDK components including system images for emulator
RUN rm -rf /usr/lib/android-sdk/emulator* && \
    sdkmanager "platform-tools" "platforms;android-30" "build-tools;30.0.3" "emulator" "system-images;android-30;default;x86_64"

# Create an Android emulator
RUN echo "no" | avdmanager create avd -n testEmulator -k "system-images;android-30;default;x86_64"

# Download and install Flutter SDK
RUN git clone https://github.com/flutter/flutter.git -b stable ${FLUTTER_HOME}

# Run basic check to download Dart SDK
RUN flutter doctor

# Set the work directory
WORKDIR /app

# Expose the necessary port numbers (adjust if necessary)
EXPOSE 8080 44300

