#!/bin/bash
read -p 'Number of Students:' count

echo "***  Begin Individual Challenge Export   ***"
echo "============================================"

for ((x=1; x<=$count; x++))

do docker exec ctfd_db_1 mysql -N -s -uroot -pctfd -e "use ctfd; SELECT challenges.value, challenges.category, challenges.name, submissions.type, submissions.user_id, users.name, submissions.date FROM challenges JOIN submissions ON challenges.id=submissions.challenge_id JOIN users ON submissions.user_id=users.id AND submissions.type='correct' AND users.id='$x' WHERE challenges.value <> '0' AND challenges.state='visible' INTO OUTFILE '${x}.csv' FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';"




echo " - student ${x} challenge grades exported! -"

done

mv /opt/CTFd/.data/mysql/ctfd/*.csv /home/chicken/

echo "***  Student grades in /home/chicken   ****"

echo "==========================================="
