#!/bin/sh

# Charon
# Copyright (C) 2021 Tim Clifford, Henry Franks
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

BASE_DIR="$(realpath "$(dirname "$(realpath $0)")/..")"

# Download the Charon exe matching this version
cd $BASE_DIR/charon
version="$(git describe --tags --always HEAD)"
if echo $version | grep -q '^v'; then
	wget "https://github.com/smh-my-head/charon/releases/download/$version/compare.exe"
else
	# just get latest
	wget "$(curl --silent \
		"https://api.github.com/repos/smh-my-head/charon/releases/latest" \
		| perl -ne 'print if s/.*"browser_download_url": "(.*?)".*/\1/')"
fi
cd - >/dev/null

# Set cat as the default pager so that we can more easily read/write text
git config core.pager cat

# Remove existing sld config if it exists and replace it with the latest config
header_start="\
### ---------------------------- BEGIN CHARON ----------------------------- ###\
"
header_end="\
### ----------------------------- END CHARON ------------------------------ ###\
"

setup_config() { # args (header_start, header_end, file to add, file to add to)

	if ! [ -f $4 ]; then
		# Thanks, I hate it
		echo "\
$1
$(cat "$3")
$2" >> $4

	elif cat $4 | grep -q "$1"; then
		echo "Found existing charon config in $4, replacing..."
		# This is cursed, but at least it's not vba...
		f="\
$(grep -B9999 "$1" $4 | grep -v "$1")
$1
$(cat "$3")
$2
$(grep -A9999 "$2" $4 | grep -v "$2")"
		# Can't oneline this because of order of operations
		echo "$f" > $4
	else
		# Thanks, I hate it
		echo "\
$1
$(cat "$3")
$2" >> $4
	fi
}

setup_config \
	"$header_start" "$header_end" \
	"$BASE_DIR/charon/gitconfig" \
	"$BASE_DIR/.git/config"

setup_config \
	"$header_start" "$header_end" \
	"$BASE_DIR/charon/gitattributes" \
	"$BASE_DIR/.gitattributes"

setup_config \
	"$header_start" "$header_end" \
	"$BASE_DIR/charon/gitignore" \
	"$BASE_DIR/.gitignore"
