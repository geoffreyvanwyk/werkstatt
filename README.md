# Werkstatt
> An instant software development environment in Ubuntu for Windows
> Subsystem for Linux, built with Ansible.

## Base Distribution
Werkstatt is based on Ubuntu 22.04. The following sections describe how the base distribution was prepared before the playbooks were executed upon it.

### Installation
The base distribution **Ubuntu 22.04** was prepared by firstly installing the Windows Subsystem for Linux (WSL) by following the [official documentation](https://aka.ms/wsl).

In Powershell, Ubuntu 22.04 was installed with the following command.

```powershell
wsl --install Ubuntu-22.04
```

When prompted for the Unix username and password, the following values were provided.

* **username:** werker
* **password:** nullfehler

### Configuration
To automatically login with the `werker` user when launching the distribution, add the following to the file `/etc/wsl.conf`. The file does not exist yet, so you have to create it.

```ini
[user]
default=werker
```

To unclutter the executable `PATH` variable, add the following to `/etc/wsl.conf`.

```ini
[interop]
appendWindowsPath=false
```

### SSH Connection
To use another WSL distribution as a control node and the base distribution as the managed node, you have to install the OpenSSH server on the base distribution.

```bash
sudo apt update
sudo apt install --yes openssh-server
```

Create SSH keys for the server.

```bash
sudo ssh-keygen -A
```

Edit the SSH server configuration in `/etc/ssh/sshd_config` to allow for password authentication by uncommenting the line:

```
#PasswordAuthentication yes
```

Limit connections to the local computer by changing:

```ini
#ListenAddress 0.0.0.0
```

To:

```ini
ListenAddress 127.0.0.1
```

Prevent port conflicts by changing the port the SSH server listens on by uncommenting the line in the same file:

```ini
#Port 22
```

Restart the server with:

```bash
sudo service ssh restart
```

## License
Copyright &copy; 2023 Geoffrey van Wyk (https://geoffreyvanwyk.dev)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
