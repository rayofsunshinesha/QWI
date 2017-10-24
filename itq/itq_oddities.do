* itq_oddities (20170619)
* no comment

capture log close
clear
clear matrix
set more off
set linesize 200

* global references $xxx defines path options below
* global reference $TEMP uses available memory for temp files
* global references $xxx defines path options below
global log "/workshop/pgm/wr/log"
global impqc "/workshop/dproducts/wr/itq"
global dpr "/workshop/dproducts/wr/itq"

**global wlist "9001 9002 9003 9004 9101 9102 9103 9104 9201 9202 9203 9204 9301 9302 9303 9304 9401 9402 9403 9404 9501 9502 9503 9504 9601 9602 9603 9604 9701 9702 9703 9704 9801 9802 9803 9804 9901 9902 9903 9904" 
**global wlist "0001 0002 0003 0004 0101 0102 0103 0104 0201 0202 0203 0204 0301 0302 0303 0304 0401 0402 0403 0404 0501 0502 0503 0504 0601 0602 0603 0604 0701 0702 0703 0704 0801 0802 0803 0804 0901 0902 0903 0904"  
**global wlist "1001 1002 1003 1004 1101 1102 1103 1104 1201 1202 1203 1204 1301 1302 1303 1304 1401 1402 1403 1404"
global wlist "1604 1701 1702"
global wplist "1604 1701p 1702pa"
global wcount "3"

* loop through specified dates of itq files
forvalues w=1/$wcount {
global www : word `w' of $wlist
global wwwp : word `w' of $wplist

log using "$log/oddities_itq_${wwwp}.smcl", replace

use "${impqc}/qcew_a_${wwwp}.dta"

display "report and process ${wwwp}"
* reformat loop to include leading zeroes
if ${www}==0503 {
replace uiacctno = string(real(uiacctno),"%010.0f")
}
* end of reformat loop

* reveal employer information oddities
sort uiacctno rptunitno
codebook uiacctno rptunitno naics sic

preserve  //* run code on subset of records matching condition
keep  if naics==. & rptunitno==0
display "are missing naics a potential problem?"
count
display "are missing naics an actual problem?"
keep if naics==. & rptunitno==0 & (employ_m1>3 | employ_m2>3 | employ_m3>3)
count
if _N>0 {
tabstat employ_m1 employ_m2 employ_m3, statistics(count mean max sum)
}
restore   //* return to full file

by uiacctno: generate n1 = _n
by uiacctno: generate n2 = _N
display "how many employer records?"
count
display "how many unique employers?"
count if n1==n2
display "are values for rptunitno consistent with assumed pattern?"
count if n1==1
count if rptunitno==0
count if n1==1 & rptunitno==0

keep if rptunitno==0
duplicates report uiacctno
duplicates list uiacctno rptunitno naics employ_m1 in 1/100
duplicates drop uiacctno, force

save "${dpr}/qcew_ndr_${wwwp}.dta", replace   //* save non-duplicate-records file

clear
log close
	}
* end of loop

exit
