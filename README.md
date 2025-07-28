# px4-sitl-ros2-wsl-setup
A one-click Windows batch script to automate the installation of ROS2 Iron, Gazebo Harmonic, and PX4 Autopilot in WSL2 (Ubuntu 24.04). Simplifies setup for robotics simulation and MAVLink development.
# ROS2 Iron + Gazebo Harmonic + PX4 Autopilot WSL2 Installer  

🚀 **Automate the setup of ROS2, Gazebo, and PX4 on Windows (WSL2/Ubuntu 24.04)** with a single batch script.  

## Features  
- Installs **WSL2** and **Ubuntu 24.04 LTS**.  
- Configures **ROS2 Iron** with desktop tools.  
- Installs **Gazebo Harmonic** with ROS2 bridge.  
- Sets up **PX4 Autopilot** for SITL simulation.  
- Saves hours of manual setup!  

## Prerequisites  
- Windows 10/11 (x64) with admin rights.  
- Internet connection (for downloads).  
- 20GB+ free disk space (WSL + Gazebo require significant space).  

## Usage  
1. Download the BATCH file.  
2. **Run as Administrator** (required for WSL setup).  
3. Follow on-screen prompts (Ubuntu installation may require manual confirmation).  
4. After completion, open WSL Ubuntu and run:  
   ```bash
   source ~/.bashrc
   gz sim          # Test Gazebo
   cd ~/PX4-Autopilot && make px4_sitl_default none  # Test PX4
