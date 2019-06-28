#!/bin/bash

# Basically it looks for a ".local" directory containing an install from the
# other script.  Specifically the vim files in ~/.local/bin and 
# ~/.local/share/.../man .  You could probably just reset targets with the
# configure or make install, but I didn't feel like dealing with that.

echo "Making required directories"

mkdir --parents "$HOME/.local/"

echo "Copying to $HOME/.local/"

cp -r "./.local/" "$HOME/" 




WORKING_SHELL="$(basename $SHELL)"


if [ "$WORKING_SHELL" == "bash" ]; then
	ADD_TO_PATH=0
	prof="$HOME/.bashrc"
elif [ "WORKING_SHELL" == "zsh" ]; then
	ADD_TO_PATH=0
	prof="$HOME/.zshrc"
else
	ADD_TO_PATH=1
fi


if [ "$ADD_TO_PATH" -ne 0 ]; then
	echo "Shell type not supported, modify your own PATH"
	exit 1
else
	echo "Adding vim location to your PATH"
	echo -e "\n## Add ~/.local to path for vim8" >> "$prof"
	echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$prof"
	echo 'export MANPATH="$HOME/.local/share/man:$PATH"' >> "$prof"
	echo "Instaniate a new shell or source $prof to adapt to new path"
fi

