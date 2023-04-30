

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo

echo -e "\nAverage number of goals in all games from the winning teams:"
echo

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo

echo -e "\nAverage number of goals in all games from both teams:"
echo

echo -e "\nMost goals scored in a single game by one team:"
echo

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo

echo -e "\nWinner of the 2018 tournament team name:"
echo

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo

echo -e "\nList of unique winning team names in the whole data set:"
echo



if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
# Get the team_id
  if [[ $WINNER != "winner" ]]
  then 
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

#If not found, then insert
  if [[ -z $WINNER_ID ]]
  then 
    INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    
    if [[ $INSERT_WINNER_RESULT = "INSERT 0 1" ]]
    then 
    echo Inserted into teams, $WINNER
    fi

#Get next team_id
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
fi 


#Get opponent names
  
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

#If not found, then insert
  if [[ -z $OPPONENT_ID ]]
  then 
    INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    if [[ $INSERT_OPPONENT_RESULT = "INSERT 0 1" ]]
    then 
    echo Inserted into teams, $OPPONENT
  fi
fi
#Get next game_id
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

echo "$($PSQL "INSERT INTO games(year,round,winner_goals,opponent_goals,winner_id,opponent_id) VALUES($YEAR,'$ROUND',$WINNER_GOALS,$OPPONENT_GOALS,$WINNER_ID,$OPPONENT_ID)")"
          
fi

done
