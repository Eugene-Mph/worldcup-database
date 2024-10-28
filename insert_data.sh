#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games;")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WG OG
do
  
  if [[ $YEAR != year ]]
  then
    # echo $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS

    # find winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    
    # if not found
    if [[ -z $WINNER_ID   ]]
    then
      # insert team name
      WINNER_INSERTED=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
      
    fi
    if [[ -z $OPPONENT_ID  ]]
    then
      OPPONENT_INSERTED=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    fi
    GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, winner_goals, opponent_id, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $WG, $OPPONENT_ID, $OG);")
    echo $GAMES $YEAR, $ROUND, $WINNER, $WG, $OPPONENT, $OG
  fi
done
echo done


