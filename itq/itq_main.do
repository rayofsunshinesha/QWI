* itq_main (20171006)
* validate iles employer files, save dta

clear
clear matrix
set more off

* global reference $TEMP uses available memory for temp files
* global references $xxx defines path options below
global pgm "/yourpath/yourfolder"
global log "/yourpath/yourfolder"
global impa "/yourpath/yourfolder"
global impb "/yourpath/yourfolder"
global impc "/yourpath/yourfolder"
global dpr "/yourpath/yourfolder"

**log using "$log/itq_view.smcl", replace

* specifications for employer files to be processed
* (qcew source data and format changes over time)

* group a: dates from 2010q1 to present
* process which dates? (examples: 1204 1301p 1402pa)
* how many dates in your list?
global alist "1604 1701p 1702pa"
global acount "3"
	if $acount>0 {
	do "$pgm/itq_ides1060.do"
	}
	* return to main

* group b: dates from 2004q2 to 2009q4
* process which dates? (examples: 0402 0904) (note: 0503 restricted file as substitute)
* how many dates in your list?
global blist ""
global bcount "0"
	if $bcount>0 {
	do "$pgm/itq_census1060.do"
	}
	* return to main

* group c: dates from 1990q1 to 2004q1
* process which dates? (examples: 9001 0003 0401)
* how many dates in your list?
global clist ""
global ccount "0"
	if $ccount>0 {
	do "$pgm/itq_census542.do"
	}
	* return to main

exit
