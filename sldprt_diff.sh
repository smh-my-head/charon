#!/bin/sh
# executed by git: I can't find actual documentation but I think
# it is executed with the following args:
# |  $1  |      $2      |  $3  |  $4  |      $5      |  $6  |  $7  |
# | name | tmp_location | hash | mode | tmp_location | hash | mode |
# |------|----------------------------|----------------------------|
# |      |          left diff         |         right diff         |

# TODO: some sort of macro thing
# A macro can be invoked with e.g.
#/c/Program\ Files/SOLIDWORKS\ Corp/SOLIDWORKS/SLDWORKS.exe /m sldworks-git-tools/compareprt.swp $1 $2

# exit if the parts are identical
if [ "$3" = "$6" ]; then
	if ! [ "$4" = "$7" ]; then
		echo "$1 differs in mode"
		exit 1
	else
		exit 0
	fi
fi

# move the files somewhere more understandable
left_filename="$(echo "$1" | sed 's/\(.*\)\.\([^.]*\)/\1_LEFT\.\2/')"
right_filename="$(echo "$1" | sed 's/\(.*\)\.\([^.]*\)/\1_RIGHT\.\2/')"
cp $2 $left_filename
cp $5 $right_filename

echo "Parts $left_filename and $right_filename differ."
echo "You can use the compare feature in SolidWorks to see a diff."
echo -n "Press enter to continue "
read -p "(this will delete $left_filename and $right_filename)"
rm $left_filename $right_filename
