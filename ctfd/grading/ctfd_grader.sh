#!/bin/bash

read -p 'Number of Students:' count

# Query total number of available 5, 10, and 15 point challenges from ctfd server
available_5=$(docker exec ctfd_db_1 mysql -N -s -uroot -pctfd -e "use ctfd; SELECT value, category, name FROM challenges WHERE state='visible' AND value='5';" | wc -l)
available_10=$(docker exec ctfd_db_1 mysql -N -s -uroot -pctfd -e "use ctfd; SELECT value, category, name FROM challenges WHERE state='visible' AND value='10';" | wc -l)
available_15=$(docker exec ctfd_db_1 mysql -N -s -uroot -pctfd -e "use ctfd; SELECT value, category, name FROM challenges WHERE state='visible' AND value='15';" | wc -l)



for ((x=1; x<=$count; x++))
do

# Query student challenges that were correctly solved and export to .csv file
	docker exec ctfd_db_1 mysql -N -s -uroot -pctfd -e "use ctfd; SELECT challenges.value, challenges.category, challenges.name, submissions.type, submissions.user_id, users.name, submissions.date FROM challenges JOIN submissions ON challenges.id=submissions.challenge_id JOIN users ON submissions.user_id=users.id AND submissions.type='correct' AND users.id='$x' WHERE challenges.value <> '0' INTO OUTFILE '${x}.csv' FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';"
	​
	echo " - student ${x} challenge grades exported! -"

# Query .csv file per student id for name and print
	name="$(cat $x.csv | awk -F',' '{print $6}' | head -1)"

# Query .csv file per student id for completed challenges of each category
	completed_5="$(cat ${x}.csv | egrep "^5" | wc -l)"
	completed_10="$(cat ${x}.csv | egrep "^10" | wc -l)"
	completed_15="$(cat ${x}.csv | egrep "^15" | wc -l)"

# Query .csv file per student id for completed challenges of each category and divide by total challenges available
	div_5="$(echo ${completed_5}/${available_5} | bc -l)"
	div_10="$(echo ${completed_10}/${available_10} | bc -l)"
	div_15="$(echo ${completed_15}/${available_15} | bc -l)"

# Create percentage per challenge category
	result_5=$(bc <<< "${div_5}*100" | sed 's/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$//')
	result_10=$(bc <<< "${div_10}*100" | sed 's/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$//')
	result_15=$(bc <<< "${div_15}*100" | sed 's/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$//')

# Create percentage per challenge category with weight added
	final_5=$(bc <<< "${div_5}*.5*100" | sed 's/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$//')
	final_10=$(bc <<< "${div_10}*.2*100" | sed 's/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$//')
	final_15=$(bc <<< "${div_15}*.3*100" | sed 's/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$//')
	total_ctfd=$(bc <<< "${final_5}+${final_10}+${final_15}" | sed 's/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$//')

# Print data in human readable format
	echo
	echo 
	echo "*    Grading student ${name}      *"
	echo "======================================================================================================================="
	echo 
	echo "${result_5}% of easy challenges, ${completed_5} of ${available_5} challenges completed, ${final_5}% of final grade"
	echo 
	echo "${result_10}% of medium challenges, ${completed_10} of ${available_10} challenges completed, ${final_10}% of final grade"
	echo
	echo "${result_15}% of hard challenges, ${completed_15} of ${available_15} challenges completed, ${final_15}% of final grade"
	echo
	echo "Total CTF Grade: ${total_ctfd}%" 

	echo "======================================================================================================================="

done
