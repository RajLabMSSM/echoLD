# LD_clumping <- function(vcf_subset,
#                         subset_SS){
#   # PLINK clumping: http://zzz.bwh.harvard.edu/plink/clump.shtml
#   # Convert vcf to .map (beagle)
#   ## https://www.cog-genomics.org/plink/1.9/data
#   system(paste("plink", "--vcf",vcf_subset,"--recode beagle --out ./plink_tmp/plink"))
#   # Clumping
#   system("plink", "--file ./plink_tmp/plink.chr-8 --clump",subset_SS,"--out ./plink_tmp")
# }
