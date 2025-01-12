# Vanguard Fucker

Simple powershell script that can be run as-is to enable or disable Vanguard by Riot.

This has only been tested on Windows 10 build 19045 and Powershell 7, but should run fine on any Windows 10 machine, and likely lower versions of Powershell as well as it relies primarily on Windows Executables directly to perform any actual actions.

### What is Vanguard

Vanguard is a Ring 0 level anti-cheat software developed by Riot as a form of stopping cheaters in their games (primarily Valorant, but now League of Legends as well).

### Reasoning

I wrote this as I don't particularly like having these types of programs running on my computer all the time, especially considering I am not playing these games in any large capacity.

Ring 0 level programs are given the very _maximum_ level of permissions to your machine. It can in theory do anything it wants without your say. It _probably_ won't. That being said, while I understand the desire to stop cheaters; regardless of how open or forthcoming they are with their software, humans are fallible and exploits will inevitably be found. I would prefer to have the option to reduce the attack surface as much as possible by being able to disable these programs whenever I wish, and as easily as possible.

## Usage

Download the powershell script and run it.

This script requires administrator level privileges to run. If it is not run as an administrator, it will request to open an administrator instance of Powershell to run the script in. It will then ask if you wish to enable or disable Vanguard with `e` for enable or `d` for disable, or optionally `x` to exit

Enabling (`e`) Vanguard configures all associated Vanguard programs to run on start-up. These programs require a restart to run properly, so the script will prompt you to restart immediately if you so wish. Any key other than `y` will be treated as a rejection for a restart. Restarting will immediately close any open programs, be sure to save your work.

Disabling (`d`) Vanguard will not only configure all associated Vanguard programs to _not_ run on startup, but will also stop said programs. A restart is not required here, as the Ring 0 program _must_ start on boot in order to work properly.

### Notes

As you should always do, be sure to look at what you are running to make sure that something shady isn't happening. Hopefully I wrote this script in such a way that it is very easy to understand what is occurring, even for the layman. But for the more obfuscated portions, here is a quick key:

- [sc.exe](https://ss64.com/nt/sc.html)
  - used to configure services (programs like Vanguard that run in the background)
  - used here to configure Vanguard services to either:
    - run on demand (starts when requested to)
    - run on system boot (starts when the system starts up)
    - not run at all
- [net.exe](https://ss64.com/nt/net-service.html)
  - can be used to stop or start services (among other things)
  - used here specifically to stop already running services
- [taskkill.exe](https://ss64.com/nt/taskkill.html)
  - probably obvious, used to kill running tasks (processes)
  - the `/IM` flag specifies that we are using an `Image Name` to find our process. Otherwise, we would require a `Process ID` which is dynamic, whereas the `Image Name` is static
  - this one may fail as the `vgtray` is not always running even if the other items are, but is included for completeness
- [shutdown.exe](https://ss64.com/nt/shutdown.html)
  - another obvious one, used to shutdown the computer. Can also be used to restart or logoff a user.
  - `/r` used to signify this is a restart
  - `/f` used to force the closure of any open programs
  - `/t` specifies a timer in seconds, here we say `0` to restart immediately
  - `/d` specifies a reason for the shutdown. In our case, `P`lanned : `4` Application : `1` Maintenance is the code we are passing in


## Contributing

I made this primarily for myself and any friends who might wish to use it, but I am always open for suggestions to make usage a bit easier. Fork and PR into the `main` branch.