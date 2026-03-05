#!/bin/bash

#
# Run WssGBLUP
#

awk 'BEGIN { for (i==1; i<70368; i++) print 1}' > w

for i in {1..2}
do
  gibbsf90+ par.b90 < gibbs_params.txt
  mv final_solutions solutions
  cp solutions solutions_$i
  postGSf90 postpar.b90 > post_$i.log
  cp snp_sol snp_sol_$i
  cp w w_$i
  awk ' NR > 1 {print $7}' snp_sol > w
done


	
