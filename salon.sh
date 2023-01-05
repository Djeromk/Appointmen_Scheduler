#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
MAIN_MENU() {
if [[ $1 ]]
then
echo -e "\n$1"
fi
  AVALIABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")

if [[ -z $AVALIABLE_SERVICES ]]
then
echo "Sorry, there are no avaliable services"
else
echo -e "\nChoose a serice:\n"
  echo "$AVALIABLE_SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
  read SERVICE_ID_SELECTED
  
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    MAIN_MENU "This is not a number! Try again."
  else
  CHECK_SERV_ID=$($PSQL "SELECT service_id, name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    if [[ -z $CHECK_SERV_ID ]]
    then
    MAIN_MENU "Not a valid service! Try again." 
    else
    echo "$CHECK_SERV_ID" | while read SERV_ID BAR SERV_NAME
    do
    echo -e "\nYou have chosen $SERV_NAME service\n"
    done
echo "Enter your phone number:"
read CUSTOMER_PHONE
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo "You are not yet in our database. What is your name?"
      read CUSTOMER_NAME
      INSERT_CUSTOMER_NAME=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    fi

echo -e "\nWhat time do you want your service to be done, $CUSTOMER_NAME"
read SERVICE_TIME
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

if [[ $SERVICE_TIME ]]
then
INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

if [[ $INSERT_APPOINTMENT ]]
then

 echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
fi
fi
    fi
  fi

 fi
}

MAIN_MENU