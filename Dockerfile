# escape=`

# Use the latest Windows Server Core image.
FROM --platform=windows/amd64 mcr.microsoft.com/windows/servercore:ltsc2019

# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

# Download the Build Tools bootstrapper.
ADD https://aka.ms/vs/16/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe

# Install Build Tools with the  Microsoft.VisualStudio.Component.VC.Tools.x86.x64 workload, excluding workloads and components with known issues.
RUN C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
    --installPath C:\BuildTools `
    --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 `
 || IF "%ERRORLEVEL%"=="3010" EXIT 0

# Define the entry point for the docker container.
# This entry point starts the developer command prompt and launches the PowerShell shell.
ENTRYPOINT ["C:\\BuildTools\\Common7\\Tools\\vsdevcmd\\ext\\vcvars.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]
