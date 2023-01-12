# Windows Shutdown From Sleep
This utility uses a task scheduler and PowerShell to enable you to make your Windows machine shut down after sleeping for a specific time.

## What does the script do?
File set_shutdown.ps1 listens for changes in the machine's power state. If it registers that the device is about to go to sleep, it sets up a wake-up task with a shutdown as its action. If you wake it up before the task begins, the task gets disabled and won't run.

## Created tasks
* ShutdownSleep is the task responsible for shutting down the computer; it is modified accordingly by set_shutdown.ps1
* ShutdownSleepDeamon is the task that runs set_shutdown.ps1 on startup (so it can continuously monitor the power state)

## Customization
* Following settings are located in settings.ini (changes are optional, default values are supplied)
* **Delay** is the time (in whole minutes) for which the machine has to sleep to be turned off
* **TaskName** is used to derive the name of the newly created tasks
* **PSScriptName** (in case you rename the script, change this variable)

## Setup
1. Clone this repository to a desired location
2. Run setup.ps1 as an administrator
3. Either manually run the task ending with "Daemon" in the task scheduler or restart your computer

## Disclaimer
* I renounce any responsibility for any damages (most likely loss of your data) caused by my code. I created this with the best intentions, but I cannot guarantee this code works the way intended. Use it at your own risk.
* This code used to be run manually, and this automated version has not been that thoroughly tested. Feel free to report any bugs you find or propose changes.
