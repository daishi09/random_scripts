docker exec ctfd_db_1 mysql -uroot -pctfd -e "use ctfd; select id, name, value from challenges;"

docker exec ctfd_db_1 mysql -uroot -pctfd -e "use ctfd; select id, name, value from challenges;"

docker exec ctfd_db_1 mysql -N -s -uroot -pctfd -e "use ctfd; describe submissions;"

docker exec ctfd_db_1 mysql -N -s -uroot -pctfd -e "use ctfd; show tables;"

docker exec ctfd_db_1 mysql -N -s -uroot -pctfd -e "use ctfd; select users.name, challenge_id, challenges.name from submissions inner join users on submissions.user_id=users.id join submissions.challenge_id=challenges.id;"


docker exec ctfd_db_1 mysql -N -s -uroot -pctfd -e "use ctfd; select users.name, challenges.name from submissions inner join users.name on submissions.user_id=user.id join submissions.challenge_id=challenges.id;"

select users.name, challenges.name, submissions.

--------

* challenges 
challenges.id challanges.name challenges.value

* users
user.id user.name

* solves
solves.user_id solves.challenge_id 

+-----------------------------------------------+-----------------+------------------+-------------------------------+
| challenges.id joined with solves.challenge_id | challenges.name | challenges.value | user.id joined with user.name |
+-----------------------------------------------+-----------------+------------------+-------------------------------+


docker exec ctfd_db_1 mysql -N -s -uroot -pctfd -e "use ctfd; select challenges.id, challenges.name, value, users.name from challenges inner join users inner join solves on solves.id=challenges.id;" > userdata.txt


#Query activity
docker exec -it ctfd_db_1 mysql -u root -p'ctfd' --database=ctfd -e 'SELECT value,category,name FROM challenges WHERE category="Networking - 1 - Fundamentals - Follow A Packet";

docker exec ctfd_db_1 mysql -N -s -uroot -pctfd -e 'use ctfd; SELECT challenges.category, challenges.name, submissions.type, submissions.user_id, users.name, submissions.date FROM challenges JOIN submissions ON challenges.id=submissions.challenge_id
JOIN users ON submissions.user_id=users.id AND submissions.type="correct" AND users.name NOT LIKE "ctf%" AND users.name NOT LIKE "stu%" AND users.name LIKE "connor.mathews";'

#create csv for individual student
docker exec ctfd_db_1 mysql -N -s -uroot -pctfd -e 'use ctfd; SELECT challenges.category, challenges.name, submissions.type, submissions.user_id, users.name, submissions.date FROM challenges JOIN submissions ON challenges.id=submissions.challenge_id
JOIN users ON submissions.user_id=users.id AND submissions.type="correct" AND users.name NOT LIKE "ctf%" AND users.name NOT LIKE "stu%" AND users.name LIKE "connor.mathews" INTO OUTFILE "/tmp/mathews.csv" FIELDS TERMINATED BY "," LINES TERMINATED BY "\n";

#check running contianers
docker container ls -a
docker ps

#create bash shell on container
docker exec -it fdd250a99297 bash

#copy file from container to host
docker cp fdd250a99297:/tmp/mathews.csv home/chicken/
