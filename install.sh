#!/bin/sh

linkall() {
	local src="$1"
	local dst="$2"
	for file in $(ls "${src}"); do
		local dfile="${dst}/.${file}"

		if [ -L "${dfile}" ]; then
			rm -v "${dfile}"
		elif [ -e "${dfile}" ]; then
			[ -e "${dfile}.bak" ] && rm -rfv "${dfile}.bak"
			mv -v "${dfile}" "${dfile}.bak"
		fi

		ln -sv "${src}/${file}" "${dfile}"
	done
}

CONFDIR="Configs"

MODULE="$1"
if [ -z "${MODULE}" ]; then
	echo "require one argument"
	exit 1
fi

cd "${HOME}"
if [ ! -d "${HOME}/${CONFDIR}" ]; then
	echo "config directory not found: ${CONFDIR}"
	exit 1
fi

if [ ! -d "${HOME}/${CONFDIR}/${MODULE}" ]; then
	echo "module not found: ${MODULE}"
	exit 1
fi

linkall "${CONFDIR}/${MODULE}/dotfile" "${HOME}"
linkall "${CONFDIR}/${MODULE}/config" "${HOME}/.config"

