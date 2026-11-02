# macOS configuration

Personal macOS configuration for AeroSpace, Ghostty, tmux and Firefox.

## Install

```sh
git clone https://github.com/nagendraallam/aerospace.git ~/.config/aerospace-config
cd ~/.config/aerospace-config
./install.sh
```

The installer can install the required Homebrew applications, links each configuration into its expected location, finds or creates the default Firefox profile, and installs the separate [Neovim configuration](https://github.com/nagendraallam/nvim).

Existing configuration paths are moved to timestamped backups before links are created. Run `./install.sh --help` for options such as installing only the configuration files.

## Included

- **AeroSpace:** five workspaces, application pinning, launch shortcuts and shortcut help.
- **Ghostty:** transparent neutral background, light blur, keyboard forwarding and automatic tmux attachment.
- **tmux:** window numbering, Neovim shortcut forwarding and Gruvbox status styling.
- **Firefox:** WhiteSur-based UI, vertical tabs, squared content area and toolbar layout.

Firefox browser data is deliberately excluded. The repository contains no history, cookies, saved logins, bookmarks, sessions, Firefox Sync data or extension storage.

## Third-party theme

The Firefox CSS under `firefox/chrome/WhiteSur` is derived from [WhiteSur Firefox Theme](https://github.com/vinceliuice/WhiteSur-firefox-theme), originally by Vince, and is distributed under its MIT license. Local compatibility and appearance changes are included so the installed result matches this setup.
