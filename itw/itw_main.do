* itw_main (20171006)
* calls itw_secondary.do in response to user input
* validate ilui employer files, save dta

clear
clear matrix
set more off

* global reference $TEMP uses available memory for temp files
* global references $xxx defines path options below
global pgm "/workshop/pgm/wr"
global log "/workshop/pgm/wr/log"
global impa "/workshop/import/wr/ides_wr"
global impb "/workshop/import/wr/census_wr"
global impc "/workshop/import/wr/census_wr"
global impd "/workshop/import/wr/census_wr"
global dpr "/workshop/dproducts/wr/itw"

* specifications for employer files to be processed
* (wr source data and format changes over time)

* group a: dates from 2010q1 to present
* process which dates? (alist examples: 1204 1301 1402)
* process which dates? (paalist examples: 1204 1301p 1402pa)
* how many dates in your list?
**global alist "1001 1002 1003 1004 1101 1102 1103 1104 1201 1202 1203 1204 1301 1302 1303 1304 1401"
**global paalist "1001 1002 1003 1004 1101 1102 1103 1104 1201 1202 1203 1204 1301 1302 1303 1304 1401"
global alist "1604 1701 1702"
global paalist "1604 1701p 1702pa"
global acount "3"
	if $acount>0 {
	do "$pgm/itw_ides2010.do"
	}
	* return to main

* group b: dates from 2006q2 to 2009q4
* process which dates? (examples: 0602 0803 0904)
* how many dates in your list?
global blist "0602 0603 0604 0701 0702 0703 0704 0801 0802 0803 0804 0901 0902 0903 0904"
global bcount "0"
	if $bcount>0 {
	do "$pgm/itw_census2006.do"
	}
	* research questions: 0902
	* return to main

* group c: dates from 2000q2 to 2006q1
* process which dates? (examples: 0002 0103 0401)
* how many dates in your list?
global clist ""
global ccount "0"
	if $ccount>0 {
	do "$pgm/itw_dual2000.do"
	}
	* return to main

* group d: dates from 1990q1 to 2000q1
* process which dates? (examples: 9102 9504 0001)
* how many dates in your list?
global dlist "9401 9402 9403 9404 9501 9502 9503 9504 9601 9602 9603 9604 9701 9702"
global dcount "0"
	if $dcount>0 {
	do "$pgm/itw_ancient1990.do"
	}
	* return to main

exit
