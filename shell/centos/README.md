
```
sudo yum -y install zsh
```

Alacritty requires the most recent stable Rust compiler to install it.

Install Required Dependency Packages
1. First install Rust programming language using an rustup installer script and follow on screen instructions.

 Next, you need to install a few additional libraries to build Alacritty on your Linux distributions, as shown.

--------- On CentOS/RHEL ---------
# yum install cmake freetype-devel fontconfig-devel xclip
# yum group install "Development Tools"

Installing Alacritty Terminal Emulator in Linux
3. Once you have installed all the required packages, next clone the Alacritty source code repository and compile it using following commands.

$ cd Downloads
$ git clone https://github.com/jwilm/alacritty.git
$ cd alacritty
$ cargo build --release

Visual Studio Code on Linux
Installation https://code.visualstudio.com/docs/setup/linux
See the Download Visual Studio Code page for a complete list of available installation options.

RHEL, Fedora, and CentOS based distributions
We currently ship the stable 64-bit VS Code in a yum repository, the following script will install the key and repository:

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

Once all the prerequisites are installed, compiling Alacritty should be easy:

cargo build --release