# CONTRIBUTING

## Build from Source Code

To build Werkstatt from its source code, you will need two distributions, one
acting as the Ansible _control node_ and the other as the Ansible
_managed node_.

The control node must have Ansible installed. The easiest way get set up with
Ansible is to use an instance of Werkstatt; otherwise, instructions will be provided later in this guide. See the
[Ansible documentation](https://docs.ansible.com/ansible/latest/installation_guide/index.html)
for how to do that.

The managed node is an instance of the base distribution
(Ubuntu). The importation and preparation of the base distribution will be
described here firstly.

### 1. Prerequisites

1. **7-Zip:** In order to extract the compressed distribution image file,
   install the [7-zip](https://7-zip.org/) archive utility. Powershell does not
   support _.gz_ files.

2. **Windows Terminal:** [Windows Terminal](https://aka.ms/terminal)
   makes it easy to work with multiple WSL distributions and multiple Poweshell
   sessions.

### 2. Directories for Working with WSL

Using Powershell (version 5+), create a set of directories that make it
convenient to work with WSL distributions.

```powershell
New-Item -ItemType Directory -Path $HOME\WSL
New-Item -ItemType Directory -Path $HOME\WSL\Distributions
New-Item -ItemType Directory -Path $HOME\WSL\Exports
```

About the directories:

- _$HOME\WSL\Distributions_ will contain the virtual hard disks of the
  distributions.
- _$HOME\WSL\Exports_ will contain the images of exported distributions.

### 3. Import Base Distribution

1. Using Powershell, download the official WSL compressed image for Ubuntu. The
   file is approximately **230 MB** large.

   ```powershell
   Invoke-WebRequest `
     -Uri https://cloud-images.ubuntu.com/wsl/jammy/current/ubuntu-jammy-wsl-amd64-wsl.rootfs.tar.gz `
     -OutFile $HOME\WSL\Exports\ubuntu-jammy-wsl-amd64-wsl.rootfs.tar.gz
   ```

2. Extract the image from the compressed archive. This should take only a few
   seconds. The file _ubuntu-jammy-wsl-amd64-wsl.rootfs.tar_ will appear in the
   _Exports_ directory. It will have an approximate size of **700 MB**.

   ```powershell
   7z e $HOME\WSL\Exports\ubuntu-jammy-wsl-amd64-wsl.rootfs.tar.gz `
     -o"$HOME\WSL\Exports"
   ```

3. If you have previously imported the base distribution, unregister the
   _Fabrik_ distribution then delete its files.

   ```powershell
   wsl --unregister Fabrik
   Remove-Item $HOME\WSL\Distributions\Fabrik
   ```

4. Import the image into a distribution named _Fabrik_ (German word for
   factory). This will take a few seconds. The created
   _$HOME\WSL\Distributions\Fabrik\ext4.vhdx_ will be approximately **850 MB**.

   ```powershell
   wsl --import Fabrik $HOME\WSL\Distributions\Fabrik $HOME\WSL\Exports\ubuntu-jammy-wsl-amd64-wsl.rootfs.tar
   ```

### 4. Prepare Base Distribution

1.  In Powershell, connect to the _Fabrik_ distribution as the `root` user,
    automatically changing to the root user's home directory. It should take
    less than a minute to connect. You will be presented with an Ubuntu welcome
    message (on first start-up) and the Bash prompt.

    ```powershell
    wsl --distribution Fabrik --user root --cd /root
    ```

2.  In Fabrik, in Bash, update the package lists, then upgrade the packages if
    there are any that are upgradable.

    ```shell
    apt update
    apt --yes upgrade
    ```

3.  Install an SSH server.

    ```shell
    apt --yes install openssh-server
    ```

4.  Configure the SSH server such that it allows authentication by password.

    ```shell
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
    ```

5.  Configure the SSH server such that it only allows connections from localhost.

    ```shell
    sed -i 's/#ListenAddress 0.0.0.0/ListenAddress 127.0.0.1/' /etc/ssh/sshd_config
    sed -i 's/#ListenAddress ::/ListenAddress ::1/' /etc/ssh/sshd_config
    ```

6.  Configure the SSH server such that it allows the `root` user to connect with
    a password.

    ```shell
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
    ```

7.  Set the password of the `root` user. This is necessary to be able to connect
    to Fabrik with Ansible. When prompted for "New password: ", and
    "Retype new password: " enter `strong`

    ```shell
    passwd
    ```

8.  Start the SSH service.

    ```shell
    service ssh start
    ```

9.  Return to Powershell by exiting from Fabrik. Fabrik will still be running in the background.

    ```shell
    exit
    ```

10. Connect to the _control node_ distribution, then clone the Werkstatt source
    code repository. If your control node is an instance of Ubuntu, then Git
    will be preinstalled.

    ```shell
    git clone https://github.com/geoffreyvanwyk/werkstatt
    ```

11. If you do not have Ansible set up yet on your control node, do the
    following. If your control node is an instance of Ubuntu, Python will be
    preinistalled but Pip will not be. Install Pip; then, from the root of the
    Werkstatt repository, install all the required Python packages. For more
    information on how to set up Ansible, see the
    [Ansible documentation](https://docs.ansible.com/ansible/latest/installation_guide/index.html)

            ```shell
            sudo apt --yes install python3-pip
            pip install --requirement requirements.txt
            ```

12. From the root of the Werkstatt repository, install the required Ansible roles and collections.

    ```shell
    ansible-galaxy role install --role-file requirements.yml
    ansible-galaxy collection install --requirements-file requirements.yml
    ```

13. Run the _fabrik.yml_ playbook to complete the preparation of the base
    distribution. When prompted for "SSH password: ", enter `strong`.

    ```shell
    ansible-playbook --inventory 127.0.0.1, --user root --ask-pass playbooks/fabrik.yml
    ```

14. Return to Powershell by exiting the control node.

    ```shell
    exit
    ```

### 5. Back Up Fabrik

This section describes how to create a back-up of Fabrik so that it is easier
to get started fresh in the future.

1. In Powershell, power off Fabrik.

   ```powershell
   wsl --terminate Fabrik
   ```

2. Create an image that captures Fabrik's current state.

   ```powershell
   wsl --export Fabrik $HOME\WSL\Exports\fabrik.tar
   ```

> **NOTE**
> In the future, in case you want to build a fresh instance of Werkstatt,
> instead of preparing the base distribution again, just import Fabrik from
> this image. You might have to an existing instance of Fabrik firstly.
>
> ```powershell
> wsl --terminate Fabrik
> wsl --unregister Fabrik
> Remove-Item $HOME\WSL\Distributions\Fabrik
> wsl --import Fabrik $HOME\WSL\Distributions\Fabrik $HOME\WSL\Exports\fabrik.tar
> ```

### 6. Build Werkstatt

1. From Powershell, firstly terminate Fabrik, then connect to Fabrik again.
   This is to make sure that `werker` will be the default user upon connection
   and to make sure it is running.

   ```powershell
   wsl --distribution Fabrik --cd ~
   ```

2. Ensure that the SSH service is running (normally it will be running, because
   it is enabled by default). This will also test that `sudo` does not require
   a password. Then return to Powershell.

   ```shell
   whoami
   sudo service ssh start
   exit
   ```

3. Connect to the control node, then change directory to the root of the
   Werkstatt repository.

4. Build Werkstatt within Fabrik by running the `main.yml` Ansible playbook.

   ```shell
   ansible-playbook playbooks/main.yml
   ```
