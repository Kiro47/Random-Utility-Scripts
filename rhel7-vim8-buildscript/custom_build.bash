#!/bin/bash

# Made to run on RHEL 7 using python36 SCL
# Installs into your home directory at ~/.local/
# I like to add mine to my path env vars in my .bashrc, in this case I want it
# to be before system defaults.
# export PATH="$HOME:/.local/bin:$PATH"
# export MANPATH="$HOME:/.local/share/man:$PATH"

DEPENDENCIES=("ruby" "ruby-devel" "lua" "lua-devel" "luajit" "luajit-devel" "ctags" "git" "python" "python-devel" "rh-python36" "tcl-devel" "perl" "perl-devel" "perl-ExtUtils-ParseXS" "perl-ExtUtils-XSpp" "perl-ExtUtils-CBuilder" "perl-ExtUtils-Embed")

for pkg in "${DEPENDENCIES[@]}"
do
	rpm -q "${pkg}" 1> /dev/null
	MISSING="$?"
	if [ "$MISSING"  -ne 0 ]; then
		printf "\033[1;33mMissing dependency: "
		echo "$pkg"
		ABORT_FLAG=1;
	fi

done

if [ "$ABORT_FLAG" -ne 0 ]; then
	echo -e "\033[0;31mAborting due to missing dependencies"
	echo -e "\033[0m"
	exit 1
fi


source /opt/rh/rh-python36/enable


# Cloning vim
git clone https://github.com/vim/vim.git

cd vim

make clean

./configure --prefix ~/.local/ \
	--with-features=huge \
	--prefix=$HOME/.local/ \
	--enable-luainterp=yes --enable-perlinterp=yes --enable-pythoninterp=yes --enable-python3interp=yes --enable-tclinterp=yes --enable-rubyinterp=yes \
	--with-python-command=python2.7 --with-python3-command=python3 \
	--with-python-config-dir=/usr/lib64/python2.7/config --with-python3-config-dir=/opt/rh/rh-python36/root/usr/lib64/python3.6/config-3.6m-x86_64-linux-gnu \
	--enable-cscope \
	--enable-gui=gtk2 --enable-multibyte --with-x \
    --with-compiledby=Kiro

BUILD_THREADS="$(( $(grep -c ^processor /proc/cpuinfo) / 2))"
echo "Building with $BUILD_THREADS threads"
make VIMRUNTIMEDIR="$HOME"/.local/share/vim/vim81 -j"${BUILD_THREADS}"
make install

