# Werkstatt

> A [WSL](https://aka.ms/wsl) distribution based on
> [Ubuntu](https://ubuntu.com), packed with the best programmes the
> command-line has to offer.

## Installation

### Prerequisites

1. You need to have WSL (Windows Subsystem for Linux) already
   enabled on your Windows 10 or 11 computer. See the
   [WSL documentation](https://learn.microsoft.com/en-us/windows/wsl/install) for
   guidance on how to do that.

2. Create directories for managing your WSL distributions and images with the
   following Powershell commands.

   ```powershell
   New-Item -ItemType Directory -Path $\WSL
   New-Item -ItemType Directory -Path $\WSL\Distributions
   New-Item -ItemType Directory -Path $\WSL\Exports
   ```

### Download Image & Import

1. Dowload the latest the latest release of Werkstatt in the form of the
   compressed image file into the _Exports_ directory created previously.

   ```powershell
   Invoke-WebRequest `
     -Uri https://github.com/geoffreyvanwyk/werkstatt/releases/latest/download/werkstatt.tar.zip `
     -OutFile $HOME\WSL\Exports\werkstatt.tar.zip
   ```

2. Extract the image file from the compressed archive. The file _werkstatt.tar_
   will appear in the _Exports_ directory.

   ```powershell
   Expand-Archive `
     -Path $HOME\WSL\Exports\werkstatt.tar.zip `
     -DestinationPath $HOME\WSL\Exports
   ```

3. Import a fresh instance of Werkstatt. This will take less than 5 minutes.

   ```powershell
   wsl --import Werkstatt ~\WSL\Distributions\Werkstatt ~\WSL\Exports\werkstatt.tar
   ```

## Usage

### Connect

You can connect to Werkstatt either with Powershell or much easier with
[Windows Terminal](https://aka.ms/terminal).

From Powershell, connect to Werkstatt with the following command:

```powershell
wsl --distribution Werkstatt --user werker --cd /home/werker
```

With Windows Terminal, Werkstatt will automatically appear in the list of
distributions in the Window Terminal's drop-down menu. For convenience, in
Windows Terminal, in the settings for Werkstatt set the "Starting Directory"
setting for Werkstatt to '~'.

### User

`werker` is the user for which all the features have been set up. The user has
`sudo` privilege and does not need to specify a password when using `sudo`. In
case it is needed, the password for this user is `nullfehler`.

## License

Copyright &copy; 2024 Geoffrey van Wyk (https://geoffreyvanwyk.dev)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <https://www.gnu.org/licenses/>.
