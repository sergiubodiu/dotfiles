# [Sergiu](https://github.com/sergiubodiu)’s  ✨ dotfiles

These are the base dotfiles that I start with when I set up a
new environment.

## 📦 Install

To install the dotfiles just run the appropriate snippet in the
terminal:

(:warning: **DO NOT** run the setup snippet if you don't fully
understand [what it does](main.sh). Seriously, **DON'T**!)

|   OS   | Snippet                                                                                      |
| :----: | :------------------------------------------------------------------------------------------- |
|  OS X  | `bash -c "$(curl -LsS https://raw.github.com/sergiubodiu/dotfiles/master/install/main.sh)"`  |
| Ubuntu | `bash -c "$(wget -qO - https://raw.github.com/sergiubodiu/dotfiles/master/install/main.sh)"` |
| Cygwin | `bash -c "$(wget -qO - https://raw.github.com/sergiubodiu/dotfiles/master/install/main.sh)"` |

[VS Codium][VSCodium plugins] plugins.

curl -LsS rawgit.com/transcode-open/apt-cyg/master/apt-cyg > apt-cyg
curl -LsS rawgit.com/StevenBlack/hosts/master/data/mvps.org/hosts > hosts

Read about [SSH Hardening](https://medium.com/@jasonrigden/hardening-ssh-1bcb99cd4cef)

## ⚡ Modern Shell Configuration

- **No Oh My Zsh**: Native Zsh with modern tools
- **Starship Prompt**: Fast, customizable cross-shell prompt
- **Smart Plugins**: Homebrew-managed zsh plugins
  - autosuggestions
  - syntax-highlighting
  - history-substring-search

### Modern CLI Tools
- **eza**: Modern `ls` replacement with colors and icons
- **fzf**: Fuzzy finder for files, history, and more
- **starship**: Beautiful, minimal prompt

### Developer Tools
- Git with enhanced configuration
- Modern terminal (Alacritty)
- Development IDEs (VS Codium, Zed)

## 📁 Structure

```
.
├── bin/                  # Custom scripts/executables (symlinked to ~/bin)
├── dircolors/            # Solarized dircolors theme (submodule)
├── fonts/                # Powerline-patched fonts (submodule)
├── git/                  # Git configuration files and templates
├── install/              # Installation/bootstrap scripts
├── macos/                # macOS-specific dotfiles & preferences
├── shell/                # Shared shell configs (zsh, bash, aliases, functions)
├── ubuntu/               # Ubuntu/Linux-specific configs
├── windows/              # Windows-specific configs (PowerShell, Git settings)
├── README.md             # Main documentation
```

## 🔧 Configuration Files

### Zsh Configuration

**`.zshenv`** (Environment & PATH)
- Homebrew setup
- Language runtime paths (Go, Python, Rust)
- Editor preferences

**`.zshrc`** (Interactive Shell)
- History configuration (10,000 entries, deduplication)
- Key bindings (Emacs-style)
- Plugin loading (syntax highlighting, autosuggestions)
- Tool integrations (fzf, direnv, chruby, nvm)
- Modern aliases (eza-based)
- Starship prompt initialization

### Git Configuration

**`.gitconfig`**
- Useful aliases (`amend`, `lg`, `rlc`, `sync`, `ulc`)
- Enhanced `git lg` with colors and relative dates
- SSH push URLs for GitHub
- LFS support

## 🛠️ Setup

```bash
ssh-keygen -t rsa -b 4096 -C "sergiu.bodiu@mailnator.com"
## Create local export configuration: .exports.local
export DOTFILES_DIR_PATH='/Users/add name/.dotfiles'
```

**`.gitconfig.local`** Create local git configuration: 

```bash
[user]
    name = 'add name'
    email = 'add name@email'

## Mac Only
[credential]
    helper = osxkeychain

## Windows Only https://github.com/Microsoft/Git-Credential-Manager-for-Windows
[core]
    editor = 'c:/workspace/scoop/shims/code' -w
    packedGitLimit = 128m
    packedGitWindowSize = 128m
[credential]
    helper = manager
```

Look for [Git Submodules](.gitmodules):

```bash
eval `ssh-agent -s`
ssh-add ~/.ssh/*_rsa
git submodule update --init --recursive
```

You can init and update the modules separetely:
```bash
git submodule init
git submodule update
```

How to add & remove submodules:

```bash
git submodule add git://github.com/robbyrussell/oh-my-zsh.git

git submodule deinit oh-my-zsh
git rm oh-my-zsh
```    

Source common utilities:

```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"
```


### Homebrew Packages

Edit `Brewfile` to add/remove packages:

```ruby
# Add a new CLI tool
brew 'ripgrep'

# Add a new application
cask 'android-file-transfer'
```

Then run:
```bash
brew bundle install
brew bundle cleanup -f  # Remove packages not in Brewfile
```

### Zsh Configuration

Edit configuration files:
```bash
nano ~/.dotfiles/shell/zshrc    # Shell behavior
nano ~/.dotfiles/shell/macos/zprofile   # Environment variables
```

### Starship Prompt

Customize the prompt:
```bash
mkdir -p ~/.config
starship preset nerd-font-symbols > ~/.config/starship.toml
git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes
# Edit ~/.config/starship.toml to customize
```

### Edit the sudo PAM configuration

```bash
sudo cp /etc/pam.d/sudo /etc/pam.d/sudo.bak
sudo nano /etc/pam.d/sudo
# Add this exact line as the very first non-comment line in the file (right after the comments, before any auth lines)
auth       sufficient     pam_tid.so
```

## 📚 Additional Resources

- [Starship Documentation](https://starship.rs/)
- [Zsh Manual](https://zsh.sourceforge.io/Doc/)
- [Homebrew Documentation](https://docs.brew.sh/)

## 🤝 Contributing

This is a personal configuration repository, but feel free to fork and adapt to your needs!

## 📝 License

MIT License - Use freely for your own workstation setup