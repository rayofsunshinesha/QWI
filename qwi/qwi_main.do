* qwi_main (20170104)
* process 6 quarters (t-4 through t+1) of wr-qcew files
* produce 1 quarter (t) of qwi-enhanced records

clear
clear matrix
version 12
set more off
set linesize 200

* global reference $TEMP uses available memory for temp files
* global references $xxx defines path options below
global pgm "/yourpath/yourfolder"
global log "/yourpath/yourfolder"
global impw "/yourpath/yourfolder"
global impq "/yourpath/yourfolder"
global dpr "/yourpath/yourfolder"

*** qwi_aztec.do
*** process itq-itw for qwi work
*** output files for each quarter (wqa_yyqq.dta)

**assign global date references (for dceo 1101-1302 need 1001-1303)
**global yqalist "1001 1002 1003 1004 1101 1102 1103 1104 1201 1202 1203 1204 1301 1302 1303"
* assign global date references (for wdis 0801-1401 need 0701-1402)
global yqalist "1601 1602p"
global yqafirst "1"
global yqalast "2"

do "$pgm/qwi_aztec.do"
* uses non-zero wages (if zero wage count needed, must create alternate path)

*** qwi_celtic.do
*** build qwi-wide-shaped records, longitudinal information across date-referenced fields
*** output files for each quarter (wqc_yyqq.dta)

* assign global date references (point to period t, list must include periods t-4 through t+1)
global yqclist "1404 1501 1502 1503 1504 1601 1602p"
* name list provides reference for output (use p when t+1 is prelim)
global yqcnamelist "1404 1501 1502 1503 1504 1601p 1602x"
global yqcfirst "5"
global yqclast "6"

do "$pgm/qwi_celtic.do"

*** qwi_egyptian.do
*** produce initial qwi measures
*** output files for each quarter (wqe_yyqq.dta)

* assign global date references for processing loop
global yqefirst "5"
global yqelast "6"

do "$pgm/qwi_egyptian.do"


*** predecessor-successor sequence
*** qwi_spartan.do, identify qualifying p/s firm pairs
*** qwi_viking.do, reconnect and produce adjusted qwi measures

global yqpfirst "5"
global yqplast "6"

***"$pgm/qwi_phoenician.do"  // earlier version, conquered by roman
***"$pgm/qwi_roman.do"  // earlier version, conquered by spartan
do "$pgm/qwi_spartan.do"
do "$pgm/qwi_viking.do"
*** add pred-succ columns to egyptian output in viking

exit
