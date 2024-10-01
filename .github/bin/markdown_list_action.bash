#! /bin/bash

set -euo pipefail

check_heading_increments() {
    rg '^#{1,6} ' --no-filename -n ./*.md | awk -F: '
    {
        line_num = $1
        heading = $2
        match(heading, /^(#+)/, m)
        current_level = length(m[1])
        if (prev_level && (current_level - prev_level) > 1) {
            print "Improper heading increment at line " line_num
        }
        prev_level = current_level
    }'
}

check_trailing_punctuation() {
    rg -n '^#{1,6} .+[.!?:;]$' ./*.md
}

main() {
    if ! ( compgen -G "./*.md" ) > /dev/null; then
        echo "No Markdown files found!"
        exit 0
    fi

    printf "%s\n" "Checking heading increments..."
    check_heading_increments

    printf "%s\n" "Checking for trailing punctuation in headings..."
    check_trailing_punctuation
}

main "$@"
