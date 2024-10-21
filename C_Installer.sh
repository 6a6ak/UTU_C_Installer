#!/bin/bash

# Updating system and installing dependencies
echo "Updating system and installing dependencies..."
sudo apt update
sudo apt install -y software-properties-common apt-transport-https build-essential wget gdb

# Installing Visual Studio Code
echo "Installing Visual Studio Code..."
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update
sudo apt install -y code

# Installing C/C++ extension for VS Code
echo "Installing C/C++ extension for VS Code..."
code --install-extension ms-vscode.cpptools

# Setting up tasks.json configuration
echo "Setting up tasks.json..."
mkdir -p .vscode
cat <<EOL > .vscode/tasks.json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "build",
            "type": "shell",
            "command": "g++",
            "args": [
                "-g",
                "\${file}",
                "-o",
                "\${fileDirname}/\${fileBasenameNoExtension}"
            ],
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "problemMatcher": ["\$gcc"],
            "detail": "Generated task for building C++ files"
        }
    ]
}
EOL

# Setting up launch.json configuration
echo "Setting up launch.json..."
cat <<EOL > .vscode/launch.json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "C++ Launch",
            "type": "cppdbg",
            "request": "launch",
            "program": "\${fileDirname}/\${fileBasenameNoExtension}",
            "args": [],
            "stopAtEntry": false,
            "cwd": "\${fileDirname}",
            "environment": [],
            "externalConsole": false,
            "MIMode": "gdb",
            "setupCommands": [
                {
                    "description": "Enable pretty-printing for gdb",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": true
                }
            ],
            "preLaunchTask": "build",
            "miDebuggerPath": "/usr/bin/gdb",
            "internalConsoleOptions": "openOnSessionStart"
        }
    ]
}
EOL

# Success message
echo "Setup completed successfully. You can now use VS Code for C/C++ development."
