* itw_dual2000 (8/28/2014) group c
* run from itw_main (ilui_to_wr_a)
* validate ilui employer files, save dta
* applies to ilui-wr files from 2000q2 to 2006q1

* loop selected files
forvalues c=1/$ccount {
global ccc : word `c' of $clist

*** match date entered with single file name needed
do "$pgm/itw_dual2000_find.do" //*delete R

log using "$log/itw_$ccc.smcl", replace

if (${fcount}==1 | ${fcount}==2 | ${fcount}==3 | ${fcount}==9 ) {

* open wage record file 
infix str idssn 1-9 str namefirst 10-24 str namemiddle 25 str namelast 26-45 state 46-47 str uiacctno 48-57 ///
	rptunitno 58-62 ein 63-71 str year 72-75 str quarter 76 wage 77-86 using "$impc/${fname1}" //* .TXT or .txt is not consistant

* gateway processing & review
tab year quarter
generate yrqtr=substr(year,3,2)+"0"+quarter
keep if yrqtr=="${ccc}"

display "count of ${ccc} records in ${fname1}, 1 of ${fcount}"
count

sort uiacctno
save "$TEMP/part1.dta", replace
clear	
}
* end of fcount 1 loop

if (${fcount}==2 | ${fcount}==3 | ${fcount}==9 ) {
* open wage record file 
infix str idssn 1-9 str namefirst 10-24 str namemiddle 25 str namelast 26-45 state 46-47 str uiacctno 48-57 ///
	rptunitno 58-62 ein 63-71 str year 72-75 str quarter 76 wage 77-86 using "$impc/${fname2}" //* .TXT or .txt is not consistant

* gateway processing & review
tab year quarter
generate yrqtr=substr(year,3,2)+"0"+quarter
keep if yrqtr=="${ccc}"

display "count of ${ccc} records in ${fname2}, 2 of ${fcount}"
count

sort uiacctno
save "$TEMP/part2.dta", replace
clear	
}
* end of fcount 2 loop

if (${fcount}==3 | ${fcount}==9 ) {
* open wage record file 
infix str idssn 1-9 str namefirst 10-24 str namemiddle 25 str namelast 26-45 state 46-47 str uiacctno 48-57 ///
	rptunitno 58-62 ein 63-71 str year 72-75 str quarter 76 wage 77-86 using "$impc/${fname3}" //* .TXT or .txt is not consistant

* gateway processing & review
tab year quarter
generate yrqtr=substr(year,3,2)+"0"+quarter
keep if yrqtr=="${ccc}"

display "count of ${ccc} records in ${fname3}, 3 of ${fcount}"
count

sort uiacctno
save "$TEMP/part3.dta", replace
clear	
}
* end of fcount 3 loop

if ( ${fcount}==9 ) {
* open wage record file 
infix str idssn 1-9 str namefirst 10-24 str namemiddle 25 str namelast 26-45 state 46-47 str uiacctno 48-57 ///
	rptunitno 58-62 ein 63-71 str year 72-75 str quarter 76 wage 77-86 using "$impc/${fname4}" //* .TXT or .txt is not consistant

* gateway processing & review
tab year quarter
generate yrqtr=substr(year,3,2)+"0"+quarter
keep if yrqtr=="${ccc}"

display "count of ${ccc} records in ${fname4}, 4 of ${fcount}"
count

sort uiacctno
save "$TEMP/part4.dta", replace
clear	
}	
* end of fcount 4 loop

if ( ${fcount}==9 ) {
* open wage record file 
infix str idssn 1-9 str namefirst 10-24 str namemiddle 25 str namelast 26-45 state 46-47 str uiacctno 48-57 ///
	rptunitno 58-62 ein 63-71 str year 72-75 str quarter 76 wage 77-86 using "$impc/${fname5}" //* .TXT or .txt is not consistant

* gateway processing & review
tab year quarter
generate yrqtr=substr(year,3,2)+"0"+quarter
keep if yrqtr=="${ccc}"

display "count of ${ccc} records in ${fname5}, 5 of ${fcount}"
count

sort uiacctno
save "$TEMP/part5.dta", replace
clear	
}	
* end of fcount 5 loop

if ( ${fcount}==9 ) {
* open wage record file 
infix str idssn 1-9 str namefirst 10-24 str namemiddle 25 str namelast 26-45 state 46-47 str uiacctno 48-57 ///
	rptunitno 58-62 ein 63-71 str year 72-75 str quarter 76 wage 77-86 using "$impc/${fname6}" //* .TXT or .txt is not consistant

* gateway processing & review
tab year quarter
generate yrqtr=substr(year,3,2)+"0"+quarter
keep if yrqtr=="${ccc}"

display "count of ${ccc} records in ${fname6}, 6 of ${fcount}"
count

sort uiacctno
save "$TEMP/part6.dta", replace
clear	
}	
* end of fcount 6 loop

if ( ${fcount}==9 ) {
* open wage record file 
infix str idssn 1-9 str namefirst 10-24 str namemiddle 25 str namelast 26-45 state 46-47 str uiacctno 48-57 ///
	rptunitno 58-62 ein 63-71 str year 72-75 str quarter 76 wage 77-86 using "$impc/${fname7}" //* .TXT or .txt is not consistant

* gateway processing & review
tab year quarter
generate yrqtr=substr(year,3,2)+"0"+quarter
keep if yrqtr=="${ccc}"

display "count of ${ccc} records in ${fname7}, 7 of ${fcount}"
count

sort uiacctno
save "$TEMP/part7.dta", replace
clear	
}
* end of fcount 7 loop

if ( ${fcount}==9 ) {
* open wage record file 
infix str idssn 1-9 str namefirst 10-24 str namemiddle 25 str namelast 26-45 state 46-47 str uiacctno 48-57 ///
	rptunitno 58-62 ein 63-71 str year 72-75 str quarter 76 wage 77-86 using "$impc/${fname8}" //* .TXT or .txt is not consistant

* gateway processing & review
tab year quarter
generate yrqtr=substr(year,3,2)+"0"+quarter
keep if yrqtr=="${ccc}"

display "count of ${ccc} records in ${fname8}, 8 of ${fcount}"
count

sort uiacctno
save "$TEMP/part8.dta", replace
clear	
}	
* end of fcount 8 loop

if ( ${fcount}==9 ) {
* open wage record file 
infix str idssn 1-9 str namefirst 10-24 str namemiddle 25 str namelast 26-45 state 46-47 str uiacctno 48-57 ///
	rptunitno 58-62 ein 63-71 str year 72-75 str quarter 76 wage 77-86 using "$impc/${fname9}" //* .TXT or .txt is not consistant

* gateway processing & review
tab year quarter
generate yrqtr=substr(year,3,2)+"0"+quarter
keep if yrqtr=="${ccc}"

display "count of ${ccc} records in ${fname9}, 9 of ${fcount}"
count

sort uiacctno
save "$TEMP/part9.dta", replace
clear	
}	
* end of fcount 9 loop



if (${fcount}==1 | ${fcount}==2 | ${fcount}==3 | ${fcount}==9 ) {
use "$TEMP/part1.dta"
}
if ( ${fcount}==2 | ${fcount}==3 | ${fcount}==9 ) {
append using "$TEMP/part2.dta"
}
if (${fcount}==3 | ${fcount}==9 ) {
append using "$TEMP/part3.dta"
}
if (${fcount}==9 ) {
append using "$TEMP/part4.dta"
append using "$TEMP/part5.dta"
append using "$TEMP/part6.dta"
append using "$TEMP/part7.dta"
append using "$TEMP/part8.dta"
append using "$TEMP/part9.dta"
}
* end of conditional append process

display "count of records ${ccc}"
count

codebook uiacctno
tab rptunitno, mis

codebook idssn
duplicates report idssn

gen wage_ind=.
	replace wage_ind=0 if wage <1
	replace wage_ind=1 if wage >=1
tab wage_ind, mis

save "$dpr/wr_a_$ccc.dta", replace
clear
log close
}
* end of loop

* return to itw_main
