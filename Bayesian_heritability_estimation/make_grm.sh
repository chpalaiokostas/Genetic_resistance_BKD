

plink --make-bed \
  --file data/LD_array_BKD_common/ac_bkd_ld_geno \
  --allow-extra-chr \
  --out plink/geno



./tools/gcta-1.95.1-macOS-arm64/bin/gcta64 --make-grm-gz --bfile plink/geno --autosome-num 50
