echo -e "\033[1;34m🛠 My Custom Commands 🛠\033[0m"

# List aliases from your .zshrc (or .bashrc)
grep '^alias ' ~/.zshrc | while read -r line; do
    echo -e "\033[1;32m${line#alias }\033[0m"
done
