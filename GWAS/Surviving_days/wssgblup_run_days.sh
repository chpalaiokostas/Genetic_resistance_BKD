#!/bin/bash

#
# Run WssGBLUP
#

awk 'BEGIN { for (i==1; i<70368; i++) print 1}' > w

for i in {1..2}
do
  echo par.b90 | blupf90+ | tee pre_$i.log
  cp solutions solutions_$i
  echo postpar.b90 | postGSf90 | tee post_$i.log
  cp snp_sol snp_sol_$i
  cp w w_$i
  awk ' NR > 1 {print $7}' snp_sol > w
done


	
