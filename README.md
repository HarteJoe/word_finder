word_finder
===========

Ruby program to find words in a word search puzzle

A word search is essentially a grid of letters. Manipulating the grid, the program scans it for words with
a length greater than 2 letters using a dictionary file. Words that are found are printed to standard out.

A user-defined grid can be used (follow the prompt). This should be a plaintext file that has
each row in the grid as a row of letters in the text file, no spaces!
A random grid will be generated otherwise

The program will look for the dictionary file in the current working directory - it must be called "dict.txt". 
You can alternatively specify a dictionary file as an argument, but if "dict.txt" is present it will be used 
regardless.
