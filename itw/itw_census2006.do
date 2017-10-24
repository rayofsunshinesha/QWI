* itw_census2006 (8/28/2014) group b
* run from itw_main (ilui_to_wr_a)
* validate ilui employer files, save dta
* applies to ilui-wr files from 2006q2 to 2009q4

* loop selected files
forvalues b=1/$bcount {
global bbb : word `b' of $blist

*** match date entered with single file name needed
do "$pgm/itw_census2006_find.do" //*delete R

log using "$log/itw_$bbb.smcl", replace

* open wage record file 
infix str idssn 1-9 str namefirst 10-24 str namemiddle 25 str namelast 26-45 state 46-47 str uiacctno 48-57 ///
	rptunitno 58-62 ein 63-71 str year 72-75 str quarter 76 wage 77-86 using "$impb/${fname}.TXT" //* all in .TXT 

 * gateway processing & review
tab year quarter
generate yrqtr=substr(year,3,2)+"0"+quarter
keep if yrqtr=="${bbb}"

display "count of ${bbb} records in ${fname}"
count
	
sort uiacctno
codebook uiacctno
tab rptunitno, mis

codebook idssn
duplicates report idssn

gen wage_ind=.
	replace wage_ind=0 if wage <1
	replace wage_ind=1 if wage >=1
tab wage_ind, mis

save "$dpr/wr_a_${bbb}.dta", replace
clear
log close
}
* end of loop

* return to itw_main
