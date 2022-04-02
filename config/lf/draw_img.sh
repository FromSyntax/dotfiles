#!/bin/sh
cleanup() {
	~/.config/lf/clear_img.sh
	kill "$UEBERZUGPID"
	pkill -f "tail -f $LF_UEBERZUG_TEMPDIR/fifo"
	rm -rf "$LF_UEBERZUG_TEMPDIR"
}
trap cleanup INT HUP

# Set up temporary directory.
export LF_UEBERZUG_TEMPDIR="$(mktemp -d -t lf-ueberzug-XXXXXX)"

# Launch ueberzug.
mkfifo "$LF_UEBERZUG_TEMPDIR/fifo"
tail -f "$LF_UEBERZUG_TEMPDIR/fifo" | ueberzug layer --silent &
UEBERZUGPID=$!

# Add this script's directory to PATH so that the lf config will find
# lf-ueberzug-cleaner and lf-ueberzgu-previewer. If no startup directory is
# provided, start lf in the examples directory.
export PATH="$PATH:${ZSH_ARGZERO:A:h}"
lf -config "${ZSH_ARGZERO:A:h}/lfrc" "${1:-"${ZSH_ARGZERO:A:h}/examples"}"
cleanup
