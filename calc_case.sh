#!/bin/bash

while true
do
  echo "1. Add"
  echo "2. Subsctract"
  echo "3. Multiply"
  echo "4. Divide"
  echo "5. Quit"

  read -r -p "Enter your choice: " choice

case $choice in
        1) read -r -p "Enter Number1: " number1
           read -r -p "Enter Number2: " number2
           echo Answer=$(( number1 + number2 ))
           ;;
        2) read -r -p "Enter Number1: " number1
           read -r -p "Enter Number2: " number2
           echo Answer=$(( number1 - number2 ))
		   ;;
		3) read -r -p "Enter Number1: " number1
           read -r -p "Enter Number2: " number2
           echo Answer=$(( number1 * number2 ))
           ;;
        4) read -r -p "Enter Number1: " number1
           read -r -p "Enter Number2: " number2
           echo Answer=$(( number1 / number2 ))
           ;;
        5) break
           ;;
esac
done