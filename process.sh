#!/bin/bash
cat $1 | awk -F, 'BEGIN{sum=0; kol=0} {if ($18 !=-1) {sum += $18; kol++}} END{print "RATING_AVG " sum/kol}'


#cat $1 | awk -F, '{print $1}' | awk -F_ '{print $1}' | sort | uniq > /tmp/my_tmp_countries.txt
#while read -r line; do
#  eval "$line=$((0))";
#done < /tmp/my_tmp_countries.txt

#cat $1 | awk -F, '{print $1}' | awk -F_ '{print $1}' > /tmp/my_tmp_allcntr.txt
#while read -r line; do
#  eval "(($line++))";
#done < /tmp/my_tmp_allcntr.txt

#echo $china

#while read -r line; do
  #tmp=eval $line
#  eval "echo ${line}"
#  echo "HOTELNUMBER $line "
#done < /tmp/my_tmp_countries.txt



declare -A hotelnum
cat $1 | awk -F, '{print $1}' | awk -F_ '{print $1}' > /tmp/my_tmp_allcntr.txt
while read -r line; do
  if [ ${hotelnum[$line]+_} ]; then hotelnum[$line]=$((${hotelnum[$line]}+1)); else hotelnum+=( [$line]=1 ); fi;
done < /tmp/my_tmp_allcntr.txt

#echo ${hotelnum['china']}

for key in "${!hotelnum[@]}"; do echo "HOTELNUMBER $key ${hotelnum[$key]}"; done



#declare -A hilton_sum
#declare -A hilton_kol
#declare -A holiday_sum
#declare -A holiday_kol
##cat $1 | awk -F, '{print $1}' | awk -F_ '{print $1}' | sort | uniq > /tmp/my_tmp_countries.txt
#cat $1 | awk -F, '{if ($12 != -1 && $12 != 0) {print $1, $2, $12}}' | awk -F_ '{print $1, $NF}' | awk  '{print $1, $3, $NF}' > /tmp/my_tmp_cntry-hotel-clean.txt
#while read -r cntry hotel clean; do
#  #echo '123' $cntry $hotel $clean
#  #if (( $(echo "$clean != 0.0" | bc -l) )); then
#    #echo "4444" $clean
#    if [[ $hotel = "holiday" ]]; then
#      if [ ${holiday_sum[$cntry]+_} ]; then 
#        holiday_sum[$cntry]="$(echo "${holiday_sum[$cntry]}+$clean" | bc -l)";
#        holiday_kol[$cntry]=$((${holiday_kol[$cntry]}+1));
#      else 
#        holiday_sum+=( [$cntry]=$clean );
#        holiday_kol+=( [$cntry]=1 );
#      fi;
#    fi;
#    if [[ $hotel = "hilton" ]]; then
#      if [ ${hilton_sum[$cntry]+_} ]; then  
#        #echo ${hilton_sum[$cntry]}
#        #echo $(echo "${hilton_sum[$cntry]}+$clean" | bc -l)
#        hilton_sum[$cntry]="$(echo "${hilton_sum[$cntry]}+$clean" | bc -l)";
#        hilton_kol[$cntry]=$((${hilton_kol[$cntry]}+1));
#      else
#        hilton_sum+=( [$cntry]=$clean )
#        hilton_kol+=( [$cntry]=1 )
#      fi;
#    fi;
#  #fi;
#done < /tmp/my_tmp_cntry-hotel-clean.txt
#
##for key in "${!holiday_sum[@]}"; do echo "CLEANLINESS" $key "$(echo "${holiday_sum[$key]}/${holiday_kol[$key]}" | bc -l)" "$(echo "${hilton_sum[$key]}/${hilton_kol[$key]}" | bc -l)"; done
#for key in "${!holiday_sum[@]}"; do printf "CLEANLINESS %s %.5f %.5f\n" $key "$(echo "${holiday_sum[$key]}/${holiday_kol[$key]}" | bc -l)" "$(echo "${hilton_sum[$key]}/${hilton_kol[$key]}" | bc -l)"; done


cat $1 | tr [:upper:] [:lower:] | awk -F, '{
  if($7 != -1 && $12 != 0 && $12 != -1){
    if($2 ~ /holiday inn/){
      holiday_sum[$7] += $12;
      holiday_kol[$7] += 1;
    }
    else if ($2 ~ /hilton/){
      hilton_sum[$7] += $12;
      hilton_kol[$7] += 1;
    }
  }
}
END{
  for (i in hilton_sum){
    print "CLEANLINESS", i, holiday_sum[i]/holiday_kol[i], hilton_sum[i]/hilton_kol[i]
  }
}'





cat $1 | awk -F, '{if ($12 != -1){if($18 != -1){print $12 "," $18}}}' > /tmp/my_tmp_clean-overal.txt
gnuplot << EOF
  set terminal png size 300,400
  set output 'cleanliness_vs_overalRatingSource.png'
  set datafile separator ','
  set fit quiet
  f(x) = m*x + b
  fit f(x) '/tmp/my_tmp_clean-overal.txt' using 2:1 via m,b
  plot '/tmp/my_tmp_clean-overal.txt' using 2:1 title 'CLEANLINESS vs overal_ratingsource' with points, f(x) title 'fit'
EOF





