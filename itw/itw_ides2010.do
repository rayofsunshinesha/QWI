* itw_ides2010 (8/28/2014) group a
* run from itw_main (ilui_to_wr_a)
* validate ilui employer files, save dta
* applies to ilui-wr files from 2010q1 to present

* loop selected files
forvalues a=1/$acount {
global aaa : word `a' of $alist
global paa : word `a' of $paalist
global fname "ILUI${paa}.txt"   //* if problems, confirm ILUI or ilui, p variations, TXT or txt.

log using "$log/itw_$paa.smcl", replace

* open wage record file 
	infix str idssn 1-9 str namefirst 10-24 str namemiddle 25 str namelast 26-45 state 46-47 str uiacctno 48-57 ///
	rptunitno 58-62 ein 63-71 str year 72-75 str quarter 76 wage 77-86 using "$impa/${fname}"

* gateway processing & review
tab year quarter
generate yrqtr=substr(year,3,2)+"0"+quarter
keep if yrqtr=="${aaa}"

display "count of ${aaa} records in ${fname}"
count
	
sort uiacctno //***may not able to sort since uiacctno is a string variable!
codebook uiacctno
tab rptunitno, mis

codebook idssn
duplicates report idssn

gen wage_ind=.
	replace wage_ind=0 if wage <1
	replace wage_ind=1 if wage >=1
tab wage_ind, mis

save "$dpr/wr_a_$paa.dta", replace

clear
log close
}
* end of loop

* return to itw_main
