# this portion lifted from the internet to prompt UAC elevation
# probably old but whatever it works
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
  if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
    $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
    Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
    Exit
  }
}
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
function Invoke-VanguardFucker {
  Write-Host "Would you like to enable or disable Riot Vanguard? (e/d) or (x) to exit"
  $res = (Read-Key).ToLower()
  switch ($res) {
    "e" {
      Write-Host "Enabling..."
      Enable-Vanguard
      Exit-Script
    }
    "d" {
      Write-Host "Disabling..."
      Disable-Vanguard
      Exit-Script
    }
    "x" {
      Exit-Script
    }
    Default {
      Write-Host "Please type either 'e', 'd', or 'x' only"
      Invoke-VanguardFucker
    }
  }
}

# used so that ANY keypress is treated as input
function Read-Key {
  while ($true) {
    return [Console]::ReadKey($true).keychar.ToString()
  }
}

function Exit-Script {
  Write-Host "Press any key to exit"
  Read-Key
  Exit 0
}

function Enable-Vanguard {
  sc.exe config vgc start=demand
  sc.exe config vgk start=system
  
  Write-Host "Do you want to restart now? This will close all currently open programs and restart immediately. You may lose data if you have not saved recently. (y/n | default = n)"
  $ret = (Read-Key).ToLower()
  if ($ret -eq "y") {
    shutdown.exe /r /f /t 0 /d P:4:1
  }
  else {
    Write-Host "Restart cancelled"
    Write-Host "Riot Vanguard is still configured to run on system startup, and will do so on next reboot"
    Write-Host "Rerun this script again to disable it"
    Exit-Script
  }
}
function Disable-Vanguard {
  sc.exe config vgc start=disabled
  sc.exe config vgk start=disabled
  net.exe stop vgc
  net.exe stop vgk
  taskkill.exe /IM vgtray.exe

  Exit-Script
}

Invoke-VanguardFucker