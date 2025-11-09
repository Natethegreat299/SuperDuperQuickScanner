# SuperDuperQuickScanner (SDQS)






SDQS is a modular PowerShell diagnostic and inventory tool designed for rapid system assessments.


It collects system, network, and hardware information and generates styled HTML reports with navigation.





## Features


- System, network, and security modules


- HTML reports with navigation bar


- Plug-and-play PowerShell design


- Works fully offline





## Usage


1. Open PowerShell in the QuickLook directory.  
2. Run the script:
```powershell
./SuperDuperQuickScanner.ps1
```


Reports are automatically generated in the `/Reports` folder and will automatically open.

If SDQS doesn’t start due to PowerShell’s execution policy,

run the following command in PowerShell to allow the script for this session only: 

```Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass```





This temporarily allows SDQS to run without permanently changing your system’s policy.


After closing PowerShell, your normal security settings are restored automatically.

