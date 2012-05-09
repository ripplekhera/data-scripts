#!/bin/bash

function contains()
{
	local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) 
    do
        if [ "${!i}" == "${value}" ]; then
            echo "y"
            return 0
        fi
    done
    echo "n"
    return 1
}

A=("one" "two" "three four")
if [ $(contains "${A[@]}" "one") == "y" ]; then
    echo "contains one"
fi
if [ $(contains "${A[@]}" "three") == "y" ]; then
    echo "contains three"
fi
