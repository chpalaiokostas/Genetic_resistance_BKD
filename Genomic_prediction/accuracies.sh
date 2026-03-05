#!/bin/bash

#Parameter files for cv
for i in {1..3}
do
	cp ac_bkd_days.par val_${i}.par
	sed -i "s/ac_bkd_surviving_days.txt/ac_pheno_val${i}.txt/" "val_${i}.par"
	renumf90 val_${i}.par
	preGSf90 renf90.par
	sed -i 's/ac_bkd_all_geno_bf90.txt/ac_bkd_all_geno_bf90.txt_clean/' renf90.par
	sed -i 's/OPTION saveCleanSNPs/#OPTION saveCleanSNPs/' renf90.par
	echo "OPTION no_quality_control" >> renf90.par
	blupf90+ renf90.par
	postGSf90 renf90.par
	predf90 --snpfile ac_bkd_all_geno_bf90.txt_clean --use_mu_hat --only-dgv --outfile dgv --no_rpg
	awk -v OFS="\t" '{$1=$1;print}' dgv > dgv_${i}
	rm dgv
	rm ac_bkd_all_geno_bf90.txt_*
	Rscript --vanilla accuracy_estimation.R ac_pheno_tst${i}.txt dgv_${i} >> accuracies.txt
done

