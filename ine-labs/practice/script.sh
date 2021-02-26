#!/bin/bash

x=444
y=321

if [ "$x" -eq "$y" ]; then
	echo "The values are equal!";
elif [ "$x" -lt "$y" ]; then
	echo "$x is less than $y"
else
	echo "$x is greater than $y"
fi
