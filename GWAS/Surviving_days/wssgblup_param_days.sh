#!/bin/bash

# Prepare parameter files for running WssGBLUP
#

renumf90 ac_bkd_days.par > renum.log

preGSf90 renf90.par

sed -i.bak -e 's/ac_bkd_all_geno_bf90.txt/ac_bkd_all_geno_bf90.txt_clean/' -e 's/map_bf90.txt/map_bf90.txt_clean/' renf90.par
sed -i.bak 's/OPTION saveCleanSNPs/#OPTION saveCleanSNPs/' renf90.par
sed -i.bak 's/OPTION hwe/#OPTION hwe/' renf90.par
echo "OPTION no_quality_control" >> renf90.par

cp renf90.par par.b90
cp renf90.par postpar.b90

echo "OPTION saveGInverse" >> par.b90
echo "OPTION weightedG w" >> par.b90

sed -i.bak 's/OPTION sol se/#OPTION sol se/g' postpar.b90
echo "OPTION which_weight 4" >> postpar.b90
echo "OPTION weightedG w" >> postpar.b90
echo "OPTION readGInverse" >> postpar.b90
#echo "OPTION Manhattan_plot_R" >> postpar.b90
echo "OPTION windows_variance_mbp 1" >> postpar.b90
