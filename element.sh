#!/bin/bash

PSQL="psql -U freecodecamp -d periodic_table -t --no-align -c"

if [[ $1 ]]
then
  #if there is an argument
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    #it's a number
    CONDITION="properties.atomic_number=$1"
  else
    #it's a text
    CONDITION="symbol='$1' OR name='$1'"
  fi
  ATOMIC_NUMBER=$($PSQL "SELECT properties.atomic_number FROM properties JOIN elements ON properties.atomic_number = elements.atomic_number WHERE $CONDITION")
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    SYMBOL=$($PSQL "SELECT elements.symbol FROM elements JOIN properties ON elements.atomic_number = properties.atomic_number WHERE $CONDITION")
    NAME=$($PSQL "SELECT elements.name FROM elements JOIN properties ON elements.atomic_number = properties.atomic_number WHERE $CONDITION")
    TYPE=$($PSQL "SELECT types.type FROM types JOIN properties ON properties.type_id = types.type_id JOIN elements ON properties.atomic_number = elements.atomic_number WHERE $CONDITION")
    MASS=$($PSQL "SELECT properties.atomic_mass FROM properties JOIN elements ON properties.atomic_number = elements.atomic_number WHERE $CONDITION")
    MELTING_POINT=$($PSQL "SELECT properties.melting_point_celsius FROM properties JOIN elements ON properties.atomic_number = elements.atomic_number WHERE $CONDITION")
    BOILING_POINT=$($PSQL "SELECT properties.boiling_point_celsius FROM properties JOIN elements ON properties.atomic_number = elements.atomic_number WHERE $CONDITION")
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
else
  #if there is no argument
  echo "Please provide an element as an argument."
fi
#done
