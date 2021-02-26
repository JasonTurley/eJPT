#!/bin/bash

echo "Two ways to iterate over a sequence of numbers!"

echo "option 1: use the seq command"
for i in $(seq 1 10); do
	echo "$i";
done

echo "option 2: use built-in braces {1..10}"
for i in {1..10}; do
	echo "$i";
done

