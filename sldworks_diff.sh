#!/bin/sh

# SolidWorks Git Tools
# Copyright (C) 2021 Ellie Clifford, Henry Franks
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

# executed by git with the following args:
# |  $1  |      $2      |  $3  |  $4  |      $5      |  $6  |  $7  |
# | name | tmp_location | hash | mode | tmp_location | hash | mode |
# |------|----------------------------|----------------------------|
# |      |          left diff         |         right diff         |

# exit if the parts are identical
if [ "$3" = "$6" ]; then
	if ! [ "$4" = "$7" ]; then
		echo "$1 differs in mode"
		exit 1
	else
		exit 0
	fi
fi

if ! [ -f /c/Program\ Files/SOLIDWORKS\ Corp/SOLIDWORKS/SLDWORKS.exe ]; then
	echo "It does not appear that SolidWorks is installed"
	echo "Files $left_filename and $right_filename differ"
	exit 1
fi

# move the files somewhere more understandable
left_filename="$(echo "$1" | sed 's/\(.*\)\.\([^.]*\)/\1_LEFT\.\2/')"
right_filename="$(echo "$1" | sed 's/\(.*\)\.\([^.]*\)/\1_RIGHT\.\2/')"
cp $2 $left_filename
cp $5 $right_filename

echo "Opening SolidWorks to diff $left_filename and $right_filename..."
echo "SolidWorks must exit fully before this diff can exit"

/c/Program\ Files/SOLIDWORKS\ Corp/SOLIDWORKS/SLDWORKS.exe \
	//m sldworks-git-tools/compare.swb \
	/*$(realpath $left_filename | xargs cygpath -w) \
	/*$(realpath $right_filename | xargs cygpath -w)

rm $left_filename $right_filename
