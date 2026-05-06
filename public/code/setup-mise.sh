#!/bin/bash

# custom script to set up mise on Windows + bash

platform=

function compute-platform() {
    case "$(uname -s)" in
        Linux*)
            if grep -q Microsoft /proc/version 2>/dev/null; then
                platform="wsl"
            else
                platform="linux"
            fi
            ;;
        Darwin*)
            platform="macos"
            ;;
        MINGW*|MSYS*|CYGWIN*)
            platform="windows"
            ;;
        *)
            echo "Unsupported platform: $(uname -s)"
            exit 1
            ;;
    esac
}

function restart-terminal() {
    echo "Restart your terminal to see the changes."
}

function extend-bashrc-for-mise() {

    # quoting and backslashing is a little tricky
    # the whole point is to patch the output of
    # mise hook-env -s bash
    # which contains the definition of PATH
    # we want to replace 'C:\' with '/c/'
    # and then to replace also ';' with ':'
    # note the use of 'EOF' to inline the text as-is without evaluation
    # otherwise we'd have needed a double amount of backslashes...

    function bashrc-windows-content() {
        cat << 'EOF'
# patch-mise-activation
if [[ -z "__MISE_ORIG_PATH" ]]; then
    sed="sed -e s,C:\\\\,/c/,g -e s,\\\\;,:,g"
    eval "$(mise activate bash | sed -e s=mise\\\ hook-env\\\ -s\\\ bash=mise\\\ hook-env\\\ -s\\\ bash\\\ \|\\\ "$sed"=)"
fi
EOF
    }

    function bashrc-regular-content() {
        cat << 'EOF'
# patch-mise-activation
eval "$(mise activate bash)"
EOF
    }

    # create a .bashr_profile if missing, bash is not happy otherwise
    [[ -f ~/.bash_profile ]] || cat > ~/.bash_profile << EOF
[[ -f ~/.bashrc ]] && source ~/.bashrc
EOF

    # avoid duplications in .bashrc
    grep -q '# patch-mise-activation' ~/.bashrc 2> /dev/null && {
        echo ~.bashrc already patched for mise
        return
    }

    case "$platform" in
        windows) bashrc-windows-content ;;
        *) bashrc-regular-content ;;
    esac >> ~/.bashrc
}


function main() {
    compute-platform
    [[ "$platform" == "windows" ]] || {
        echo "This script is for windows only, not $platform - exiting"
        exit 1
    }
    extend-bashrc-for-mise
    restart-terminal
}

# If no arguments, run main, otherwise run the provided command
[[ -z "$@" ]] && main || "$@"
