#!/bin/bash

# custom script to configure vscode for all students in a reasonable way
# namely, disable the AI-oriented features (copilot, chat side bar, ...)
# this goes in the *user* settings, so it applies to all workspaces

# REQUIREMENTS: we use Python to merge our settings into existing ones

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


settings_dir=

function compute-settings-dir() {
    case "$platform" in
        macos)
            settings_dir="$HOME/Library/Application Support/Code/User"
            ;;
        linux)
            settings_dir="$HOME/.config/Code/User"
            ;;
        windows)
            settings_dir="$APPDATA/Code/User"
            ;;
        wsl)
            # vscode runs on the windows side, and so do its user settings
            local appdata=$(powershell.exe -NoProfile -Command 'Write-Output $env:APPDATA' 2>/dev/null | tr -d '\r')
            [[ -n "$appdata" ]] || { echo "could not locate the windows APPDATA folder"; exit 1; }
            settings_dir="$(wslpath "$appdata")/Code/User"
            ;;
    esac
}


function cat-vscode-settings() {
    cat << 'EOF'
{
    "chat.disableAIFeatures": true,
    "workbench.secondarySideBar.defaultVisibility": "hidden",
    "github.copilot.enable": { "*": false }
}
EOF
}


function configure-vscode() {
    local settings="$settings_dir/settings.json"
    mkdir -p "$settings_dir"

    # no settings yet (or an empty file): just create them
    if [[ ! -s "$settings" ]]; then
        cat-vscode-settings > "$settings"
        echo "created $settings"
        return
    fi

    # otherwise we need to merge into the existing settings - use python
    local python=""
    local cmd
    for cmd in python3 python py; do
        type "$cmd" >& /dev/null && { python=$cmd; break; }
    done
    [[ -n "$python" ]] || {
        echo "you have an existing $settings but no python to merge into it"
        echo "please add the following settings manually:"
        cat-vscode-settings
        exit 1
    }

    # keep a backup, then merge
    cp "$settings" "$settings.bak"
    echo "your previous settings are saved as $settings.bak"

    "$python" - "$settings" << 'EOF' || exit 1
import json, sys

# vscode tolerates comments and trailing commas, plain json does not
# so scan the text, ignoring string contents, and drop what json chokes on
def strip_jsonc(text):
    out, i, n, in_string = [], 0, len(text), False
    while i < n:
        c = text[i]
        if in_string:
            out.append(c)
            if c == '\\' and i + 1 < n:
                out.append(text[i+1]); i += 2; continue
            if c == '"':
                in_string = False
            i += 1
        elif c == '"':
            in_string = True; out.append(c); i += 1
        elif text[i:i+2] == '//':
            while i < n and text[i] != '\n':
                i += 1
        elif text[i:i+2] == '/*':
            end = text.find('*/', i+2)
            i = n if end < 0 else end + 2
        elif c == ',':
            j = i + 1
            while j < n and (text[j] in ' \t\r\n' or text[j:j+2] in ('//', '/*')):
                if text[j:j+2] == '//':
                    while j < n and text[j] != '\n': j += 1
                elif text[j:j+2] == '/*':
                    end = text.find('*/', j+2); j = n if end < 0 else end + 2
                else:
                    j += 1
            if j < n and text[j] in '}]':
                i += 1          # trailing comma: drop it
            else:
                out.append(c); i += 1
        else:
            out.append(c); i += 1
    return ''.join(out)

path = sys.argv[1]
with open(path, encoding="utf-8") as f:
    text = f.read()

try:
    settings = json.loads(strip_jsonc(text))
except json.JSONDecodeError:
    sys.exit(f"could not parse {path} - please add the settings manually")

settings.update({
    "chat.disableAIFeatures": True,
    "workbench.secondarySideBar.defaultVisibility": "hidden",
    "github.copilot.enable": {"*": False},
})

with open(path, "w", encoding="utf-8") as f:
    json.dump(settings, f, indent=4)
    f.write("\n")

print(f"updated {path}")
EOF
}


function restart-vscode() {
    echo "Restart vscode to see the changes."
}


function main() {
    compute-platform
    compute-settings-dir
    configure-vscode
    restart-vscode
}

# If no arguments, run main, otherwise run the provided command
[[ -z "$@" ]] && main || "$@"
