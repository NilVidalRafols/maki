#!/usr/bin/env bash

main_content=""
system_content=""
model=""
next_is_system=0
next_is_template=0
next_is_system_template=0
next_is_model=0
no_stream=1

cmd=(maki)
s_cmd=(maki)
extra_args=()
pipe=0
s_pipe=0
while [[ $# -gt 0 ]]; do
    arg="$1"
    shift

    if [[ "$arg" == "-st" ]]; then
        s_cmd+=(-t "$1")
        [[ $1 == "-" ]] && s_pipe=1
        shift

    elif [[ "$arg" == "-s" ]]; then
        s_cmd+=("$1")
        [[ $1 == "-" ]] && s_pipe=1
        shift

    elif [[ "$arg" == "-t" ]]; then
        cmd+=(-t "$1")
        [[ $1 == "-" ]] && pipe=1
        shift
        
    elif [[ "$arg" == "-m" ]]; then
        extra_args+=(-m $1)
        shift

    elif [[ "$arg" == "--no-stream" ]]; then
        extra_args+=("$arg")

    else
        cmd+=("$arg")
        [[ "$arg" == "-" ]] && pipe=1
    fi
done

# Execute the maki command for main and system contents
if [[ $pipe -eq 1 || $s_pipe -eq 1 ]]; then
    cached_stdin=$(cat)
fi

if [[ $pipe -eq 1 ]]; then
    main_content="$(printf '%s' "$cached_stdin" | "${cmd[@]}")"$'\n'
else
    main_content="$("${cmd[@]}")"$'\n'
fi

if [[ $s_pipe -eq 1 ]]; then
    system_content="$(printf '%s' "$cached_stdin" | "${s_cmd[@]}")"$'\n'
else
    system_content="$("${s_cmd[@]}")"$'\n'
fi

# Trim trailing newlines
main_content="${main_content%$'\n'}"
system_content="${system_content%$'\n'}"

# printf "maki-llm mapped to [ printf '%%s' <main content> | llm -s <system content> %s ]\n" "${extra_args[*]}"
# printf 'MAIN:\n%s\n' "$main_content"
# printf 'SYSTEM:\n%s\n' "$system_content"

# Run the llm command
cmd=(llm)
[[ -n $system_content ]] && cmd+=(-s "$system_content")
[[ -n $extra_args ]] && cmd+=("${extra_args[@]}")
printf '%s' "$main_content" | "${cmd[@]}"
