* itw_ancient1990 (8/28/2014) group d
* run from itw_main (ilui_to_wr_a)
* validate ilui employer files, save dta
* applies to ilui-wr files from 1990q1 to 2000q1

* loop selected files
forvalues d=1/$dcount {
global ddd : word `d' of $dlist

*** match date entered with single file name needed
do "$pgm/itw_ancient1990_find.do" //*delete R 

log using "$log/itw_$ddd.smcl", replace

if (${fcount}==1 | ${fcount}==2 ) {

* open wage record file 
infix str idssn 1-9 str namefirst 10-24 str namemiddle 25 str namelast 26-45 state 46-47 str uiacctno 48-57 ///
	rptunitno 58-62 ein 63-71 str year 72-75 str quarter 76 wage 77-86 using "$impd/${fname1}" //* .TXT or .txt is not consistant

* gateway processing & review
tab year quarter
generate yrqtr=substr(year,3,2)+"0"+quarter
keep if yrqtr=="${ddd}"

display "count of ${ddd} records in ${fname1}, 1 of ${fcount}"
count

sort uiacctno
save "$TEMP/part1.dta", replace
clear
}
* end of fcount 1 loop

if (${fcount}==2 ) {
* open wage record file 
infix str idssn 1-9 str namefirst 10-24 str namemiddle 25 str namelast 26-45 state 46-47 str uiacctno 48-57 ///
	rptunitno 58-62 ein 63-71 str year 72-75 str quarter 76 wage 77-86 using "$impd/${fname2}" //* .TXT or .txt is not consistant

* gateway processing & review
tab year quarter
generate yrqtr=substr(year,3,2)+"0"+quarter
keep if yrqtr=="${ddd}"

display "count of ${ddd} records in ${fname2}, 2 of ${fcount}"
count

sort uiacctno
save "$TEMP/part2.dta", replace
clear	
}
* end of fcount 2 loop

if (${fcount}==1 | ${fcount}==2 ) {
use "$TEMP/part1.dta"
}
if ( ${fcount}==2 ) {
append using "$TEMP/part2.dta"
}
* end of conditional append process

display "count of records $ddd"
count

codebook uiacctno
tab rptunitno, mis

codebook idssn
duplicates report idssn

gen wage_ind=.
	replace wage_ind=0 if wage <1
	replace wage_ind=1 if wage >=1
tab wage_ind, mis

save "$dpr/wr_a_$ddd.dta", replace
clear
log close
}
* end of loop

* return to itw_main
