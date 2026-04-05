# --- Shell Integration ---
TOOLS_DIR="$(cd "$(dirname "$0")" && pwd)"

case "$SHELL" in
    */fish)
        source_line="source $TOOLS_DIR/integration.fish"
        config_file="$HOME/.config/fish/config.fish"
        ;;
    */zsh)
        source_line="source $TOOLS_DIR/integration.sh"
        config_file="$HOME/.zshrc"
        ;;
    */bash)
        source_line="source $TOOLS_DIR/integration.sh"
        config_file="$HOME/.bashrc"
        ;;
    *)
        source_line=""
        config_file=""
        ;;
esac

if [[ -n "$source_line" && -n "$config_file" ]]; then
    if grep -qF "$source_line" "$config_file" 2>/dev/null; then
        echo "[shell] Already configured in $config_file"
    else
        echo ""
        echo "[shell] Add this line to $config_file:"
        echo "  $source_line"
        echo ""
        read -p "[shell] Add it now? [y/N] " -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "" >> "$config_file"
            echo "# Claude Code Router" >> "$config_file"
            echo "$source_line" >> "$config_file"
            echo "[shell] Added to $config_file"
            echo "[shell] Run 'source $config_file' or restart your shell"
        fi
    fi
elif [[ -z "$source_line" ]]; then
    echo "[shell] Unsupported shell: $SHELL"
    echo "[shell] Manually add to your shell config:"
    echo "  source $TOOLS_DIR/integration.sh  # for bash/zsh"
    echo "  source $TOOLS_DIR/integration.fish  # for fish"
fi
