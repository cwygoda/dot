# dot

Personal dotfiles managed with symlinks.

## Structure

```
src/           # Dotfiles source (mirrors home directory structure)
install.sh     # Symlink installer script
```

## Usage

```bash
./install.sh           # Skip existing files
./install.sh -i        # Interactive mode (diff + prompt for conflicts)
./install.sh -f        # Force overwrite existing files
```

The script will:
- Create symlinks from `$HOME` to files in `src/`
- Automatically create parent directories as needed
- Prompt for git email and create `~/.gitconfig.local` on first run

## Machine-Local Config

Some settings differ per machine and are excluded from the repo:

| File                 | Purpose                                    |
|----------------------|--------------------------------------------|
| `~/.gitconfig.local` | Git user.email (created by install script) |
