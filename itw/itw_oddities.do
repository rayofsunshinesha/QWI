* itw_oddities (20161229)
* no comment

capture log close
clear
clear matrix
set more off

* global references $xxx defines path options below
* global reference $TEMP uses available memory for temp files
* global references $xxx defines path options below
global log "/workshop/pgm/wr/log"
global impwr "/workshop/dproducts/wr/itw"
global dpr "/workshop/dproducts/wr/itw"

log using "$log/oddities_itw.smcl", replace

**global wlist "9001 9002 9003 9004 9101 9102 9103 9104 9201 9202 9203 9204 9301 9302 9303 9304 9401 9402 9403 9404 9501 9502 9503 9504 9601 9602 9603 9604 9701 9702 9703 9704 9801 9802 9803 9804 9901 9902 9903 9904" 
**global wlist "0001 0002 0003 0004 0101 0102 0103 0104 0201 0202 0203 0204 0301 0302 0303 0304 0401 0402 0403 0404 0501 0502 0503 0504 0601 0602 0603 0604 0701 0702 0703 0704 0801 0802 0803 0804 0901 0902 0903 0904"  
**global wlist "1001 1002 1003 1004 1101 1102 1103 1104 1201 1202 1203 1204 1301 1302 1303 1304 1401 1402 1403 1404"
global wlist "1604 1701 1702"
global wplist "1604 1701p 1702pa"
global wcount "3"

* loop through specified dates of itw files
forvalues w=1/$wcount {
global www : word `w' of $wlist
global wwwp : word `w' of $wplist

use "${impwr}/wr_a_${wwwp}.dta"

display "report and process ${wwwp}"

* reveal wage field oddities
gen wage_odd=99
replace wage_odd=. if wage==.
replace wage_odd=0 if wage==0
replace wage_odd=0.9 if (wage>0 & wage<1)
replace wage_odd=1 if wage>=1

count
tab wage_odd, mis

drop if (wage==0 | wage==.)
count
save "${dpr}/wr_nzw_${wwwp}.dta", replace   //* save non-zero-wages file

clear
	}
* end of loop

log close
exit
