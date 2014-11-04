#!/bin/sh

CONFDIR="Configs"

linkall() {
	local src="$1"
	local prefix="$2"
	local lprefix="$3"

	if [ ! -d "${src}" ]; then
		return
	fi

	for file in $(ls "${src}"); do
		local dst="${prefix}${file}"

		if [ -L "${dst}" ]; then
			rm -v "${dst}"
		elif [ -e "${dst}" ]; then
			[ -e "${dst}.bak" ] && rm -rfv "${dst}.bak"
			mv -v "${dst}" "${dst}.bak"
		fi

		ln -sv "${lprefix}${src}/${file}" "${dst}"
	done
}

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

linkall "${CONFDIR}/${MODULE}/dotfile" "${HOME}/." ""
linkall "${CONFDIR}/${MODULE}/config" "${HOME}/.config/" "../"

