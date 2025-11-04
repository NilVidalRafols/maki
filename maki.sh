
next_is_template=0

for arg in "$@"; do
    if [[ "$arg" == "-t" ]]; then
        # Template flag is found
        next_is_template=1

    elif [[ $next_is_template -eq 1 ]]; then
        # Try to find prompt file without extension
        found=0
        for file in "$HOME/.prompts/$arg".*; do
            if [[ -f "$file" ]]; then
                cat "$file"
                found=1
                break
            fi
        done
        if [[ $found -eq 0 ]]; then
            echo "template $arg not found in $HOME/.prompts/"
            exit 1
        fi
        next_is_template=0

    elif [[ "$arg" == "-" ]]; then
        # Read from stdin
        cat

    elif [[ -f "$arg" ]]; then
        # If it's an existing file, read its contents
        cat "$arg"

    else
        # If no file is found, treat it as a string
        echo "$arg"
    fi
done

