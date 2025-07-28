@echo off
:: Batch file to automate WSL2 + Ubuntu 24.04 + ROS2 Iron + Gazebo Harmonic + PX4 installation
:: Run as Administrator for WSL setup

echo.
echo =============================================
echo    Automated ROS2 & Gazebo Harmonic Installer
echo =============================================
echo.
echo This script will:
echo 1. Install WSL2 & Ubuntu 24.04
echo 2. Set up ROS2 Iron inside Ubuntu
echo 3. Install Gazebo Harmonic
echo 4. Install PX4 Autopilot
echo.
echo NOTE: Run as Administrator for WSL setup.
echo.
pause

:: ====================
:: 1. Install WSL2 & Ubuntu 24.04
:: ====================
echo.
echo [1/6] Setting up WSL2 and Ubuntu 24.04...
echo.

:: Enable WSL
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

:: Set WSL2 as default
wsl --set-default-version 2

:: Install Ubuntu 24.04 from Microsoft Store (requires manual confirmation)
echo Installing Ubuntu 24.04 LTS...
start ms-windows-store://pdp/?productid=9NZ3KLHXDJP5
echo.
echo After Ubuntu installation completes, press any key to continue...
pause >nul

:: ====================
:: 2. Launch Ubuntu & Run Setup Script
:: ====================
echo.
echo [2/6] Configuring Ubuntu environment...
echo.

:: Generate a temporary shell script for Ubuntu
echo Creating setup script inside Ubuntu...
(
echo #!/bin/bash
echo
echo echo "Updating system and installing dependencies..."
echo sudo apt update && sudo apt upgrade -y
echo sudo apt install -y build-essential cmake git wget curl vim gnupg2 lsb-release unzip
echo
echo echo "Setting up ROS2 Iron..."
echo sudo apt install -y locales
echo sudo locale-gen en_US en_US.UTF-8
echo sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
echo export LANG=en_US.UTF-8
echo
echo echo "Adding ROS2 repository..."
echo sudo apt install -y software-properties-common curl gnupg lsb-release
echo sudo mkdir -p /usr/share/keyrings
echo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | gpg --dearmor | sudo tee /usr/share/keyrings/ros-archive-keyring.gpg > /dev/null
echo echo "deb [signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
echo
echo echo "Installing ROS2 Iron..."
echo sudo apt update
echo sudo apt install -y ros-iron-desktop
echo
echo echo "Sourcing ROS2..."
echo echo "source /opt/ros/iron/setup.bash" >> ~/.bashrc
echo mkdir -p ~/ros2_ws/src
echo
echo echo "Installing Gazebo Harmonic..."
echo sudo curl -sSL https://packages.osrfoundation.org/gazebo.key | gpg --dearmor | sudo tee /usr/share/keyrings/gazebo-archive-keyring.gpg > /dev/null
echo echo "deb [signed-by=/usr/share/keyrings/gazebo-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null
echo sudo apt update
echo sudo apt install -y gz-harmonic ros-iron-ros-gz ros-iron-ros-gz-bridge
echo echo "export GZ_VERSION=harmonic" >> ~/.bashrc
echo
echo echo "Installing PX4 Autopilot..."
echo cd ~
echo git clone https://github.com/PX4/PX4-Autopilot.git --recursive
echo cd PX4-Autopilot
echo bash ./Tools/setup/ubuntu.sh --no-nuttx
echo
echo echo "Setting up environment variables..."
echo echo "export ROS_PACKAGE_PATH=\$ROS_PACKAGE_PATH:\$HOME/PX4-Autopilot" >> ~/.bashrc
echo echo "export GZ_SIM_RESOURCE_PATH=\$GZ_SIM_RESOURCE_PATH:\$HOME/PX4-Autopilot/Tools/simulation/gz/resources" >> ~/.bashrc
echo
echo echo "Build PX4..."
echo make px4_sitl_default
echo
echo echo "Installation complete! Restart WSL to apply changes."
) > %TEMP%\ubuntu_setup.sh

:: Run the script inside Ubuntu
wsl bash -c "chmod +x /mnt/c/Windows/Temp/ubuntu_setup.sh && /mnt/c/Windows/Temp/ubuntu_setup.sh"

:: ====================
:: Cleanup & Completion
:: ====================
del %TEMP%\ubuntu_setup.sh
echo.
echo [6/6] Installation Complete!
echo.
echo To use ROS2 and Gazebo:
echo 1. Open WSL Ubuntu
echo 2. Run: source ~/.bashrc
echo 3. Test Gazebo: gz sim
echo 4. Test PX4: cd ~/PX4-Autopilot && make px4_sitl_default none
echo.
pause