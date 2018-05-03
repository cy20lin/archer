
# COMMAND_USAGE="help <layers>..."
# COMMAND_DESCRIPTION="this help content."

command_entry() {
    echo ""
    echo "archer <command> <args>..."
    echo ""
    echo "command:"
    echo "  help                           this help content."
    echo "  install           <layers>...  install layers and their dependencies."
    echo ""
    echo "command (experimental):"
    echo "  raw-install       <layers>...  install layers without dependencies."
    echo "  force-install     <layers>...  install layers and dependencies even if already installed."
    echo "  raw-force-install <layers>...  install layers even if already installed."
    echo ""
    echo "examples:"
    echo "  archer install app/emacs app/spacemacs lang/c-c++"
    echo "  archer install /ubuntu/app/emacs lang/c-c++"
    echo ""

}
