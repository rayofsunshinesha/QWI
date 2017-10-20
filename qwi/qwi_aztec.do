* qwi_aztec (10/14/2014)
* secondary to qwi_main
*** process itq-itw for qwi work / output files for each quarter (wqa_yyqq.dta)

* loop, combine itw-itq, keep selected fields, and attach dates to varnames
forvalues i=$yqafirst/$yqalast {
global yq: word `i' of $yqalist
log using "${log}/qwi_aztec_${yq}.smcl", replace

* prep employer data
use "$impq/qcew_ndr_$yq.dta"  //* using non-duplicate-records file
keep uiacctno rptunitno ein uiacctno_p rptunitno_p uiacctno_s rptunitno_s naics owner coveragetype meei ///
  employ_m1 employ_m1i employ_m2 employ_m2i employ_m3 employ_m3i totalwages totalwagesind taxablewages
**keep if rptunitno==0  //* not needed with ndr
rename uiacctno_p uiacct_p
rename uiacctno_s uiacct_s
sort uiacctno
save "$TEMP/q.dta", replace
clear
* prep employee data
use "$impw/wr_nzw_$yq.dta"  //* using non-zero-wages file
keep idssn year quarter namefirst namemiddle namelast state uiacctno rptunitno ein wage
rename ein ein_wr
rename rptunitno rptunitno_wr
sort uiacctno
* merge with employer data, simplify
merge m:1 uiacctno using "$TEMP/q.dta", keep(master match) generate(wq_merge)

keep idssn year quarter namefirst namemiddle namelast state rptunitno_wr ein_wr wage ///
  uiacctno rptunitno ein uiacct_p rptunitno_p uiacct_s rptunitno_s naics owner coveragetype meei wq_merge ///
  employ_m1 employ_m1i employ_m2 employ_m2i employ_m3 employ_m3i totalwages totalwagesind taxablewages

rename (year quarter namefirst namemiddle namelast state rptunitno_wr ein_wr wage) ///
       (year quarter namefirst$yq namemiddle$yq namelast$yq state$yq rptunitno_wr$yq ein_wr$yq wage$yq)
rename (uiacctno rptunitno ein uiacct_p rptunitno_p uiacct_s rptunitno_s naics owner coveragetype meei wq_merge) ///
       (uiacctno rptunitno ein$yq uiacct_p$yq rptunitno_p$yq uiacct_s$yq rptunitno_s$yq naics$yq owner$yq coveragetype$yq meei$yq wq_merge$yq)
rename (employ_m1 employ_m1i employ_m2 employ_m2i employ_m3 employ_m3i totalwages totalwagesind taxablewages) ///
       (employ_m1$yq employ_m1i$yq employ_m2$yq employ_m2i$yq employ_m3$yq employ_m3i$yq totalwages$yq totalwagesind$yq taxablewages$yq)

sort uiacctno idssn
save "$dpr/wqa_$yq.dta", replace
display "##################################"
display "duplicates report for wqa file $yq"
codebook uiacctno
duplicates report uiacctno
codebook idssn
duplicates report idssn
duplicates report uiacctno idssn
describe
log close
clear
}
* end of i loop
