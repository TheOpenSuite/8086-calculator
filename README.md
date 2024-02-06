# 8086-calculator
An 8086 based program for a calculator that can add, subtract, divide, or multiply 2 numbers, view all the previous results, sort the results from high to low and visa versa, list the even and odd results, and list all the results divisible by a selected number.

## Arrays:
The program uses 5 arrays
Results: This in the main array used to store all the results.
Results2: This array stores the results after being sorted.
Evens: This array stores all the even numbers in the results.
Odds: This array stores all the odd numbers in the results.
Divby: This array stores all the numbers divisible by the number entered by the
user.

## Subroutines:
Our program uses 5 procedures to perform 5 different subroutines
* SortLTH: This procedure copies the results array into a new array called results2
and sorts them using bubble sort algorithm from the least to the highest.
* SortHTL: This procedure copies the results array into a new array called results2
and sorts them using bubble sort algorithm from the highest to least.
* Even_Odd: This procedure reads the results array and checks each number if it’s
even or odd then copies it to either Evens or Odds.
* Div_by: This procedure requests a number from the user and then uses this
number to check if it is divisible by each number in the results array then stores
all the numbers that were divisible into array Divby.
* Import: This procedure reads numbers from an external file and writes them into
the results array.

## Addressing modes:
* This program uses 5 different addressing modes:
* Register addressing
* Immediate addressing
* Direct memory addressing
* Direct-Offset addressing
* Indirect memory addressing

## Files:
This program uses “input.txt” to import numbers into the results array and be
used in the program.
