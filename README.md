# dot

Personal dotfiles managed with symlinks.

## Structure

```
src/           # Dotfiles source (mirrors home directory structure)
install.sh     # Symlink installer script
```

## Usage

```bash
./install.sh
```

The script will:
- Create symlinks from `$HOME` to files in `src/`
- Skip files that already exist in the home directory
- Automatically create parent directories as needed
