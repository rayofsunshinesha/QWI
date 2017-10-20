* qwi_celtic (20151112)
* secondary to qwi_main
*** build qwi-wide-shaped records, longitudinal information across date-referenced fields
*** output files for each quarter (wqc_yyqq.dta)

* build qwi-shaped records, longitudinal information across numbered fields
forvalues j=$yqcfirst/$yqclast {

* begin with fields from base period file
global yqt: word `j' of $yqclist
global yqtname: word `j' of $yqcnamelist
use "$dpr/wqa_$yqt.dta"

log using "${log}/qwi_celtic_${yqt}.smcl", replace
count

* attach fields from relative period files
	local tm4=`j'-4
	global yqtm4: word `tm4' of $yqclist
	merge 1:1 uiacctno idssn using "$dpr/wqa_$yqtm4.dta", generate(merge_${yqtm4}) keep(master match)
	
	local tm3=`j'-3
	global yqtm3: word `tm3' of $yqclist
	merge 1:1 uiacctno idssn using "$dpr/wqa_$yqtm3.dta", generate(merge_${yqtm3}) keep(master match)

	local tm2=`j'-2
	global yqtm2: word `tm2' of $yqclist
	merge 1:1 uiacctno idssn using "$dpr/wqa_$yqtm2.dta", generate(merge_${yqtm2}) keep(master match)

	local tm1=`j'-1
	global yqtm1: word `tm1' of $yqclist
	merge 1:1 uiacctno idssn using "$dpr/wqa_$yqtm1.dta", generate(merge_${yqtm1}) keep(master match)

	local tp1=`j'+1
	global yqtp1: word `tp1' of $yqclist
	merge 1:1 uiacctno idssn using "$dpr/wqa_$yqtp1.dta", generate(merge_${yqtp1}) keep(master match)
	
sort uiacctno idssn
save "$dpr/wqc_$yqtname.dta", replace
describe
count

clear
log close
}
* end of loop

