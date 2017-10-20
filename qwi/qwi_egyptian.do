* qwi_egyptian (20151112)
* secondary to qwi_main
*** define qwi measures for employment and wages
*** output files for each quarter (wqe_yyqq.dta)

* build qwi-shaped records, longitudinal information across numbered fields
forvalues j=$yqefirst/$yqelast {
* begin with fields from base period file
	global yqt: word `j' of $yqclist
	global yqtname: word `j' of $yqcnamelist
	local tm4=`j'-4
	global yqtm4: word `tm4' of $yqclist
	local tm3=`j'-3
	global yqtm3: word `tm3' of $yqclist
	local tm2=`j'-2
	global yqtm2: word `tm2' of $yqclist
	local tm1=`j'-1
	global yqtm1: word `tm1' of $yqclist
	local tp1=`j'+1
	global yqtp1: word `tp1' of $yqclist

log using "${log}/qwi_egyptian_${yqt}.smcl", replace

* use output from celtic
use "$dpr/wqc_$yqtname.dta", clear

* develop QWI-based measures
display "workforce measures for base period $yqt"

display "flow employment"
gen qwmt=0
replace qwmt=1 if (wage${yqt}>=1 & wage${yqt}<.)
gen qwmtm4=0
replace qwmtm4=1 if (wage${yqtm4}>=1 & wage${yqtm4}<.)
gen qwmtm3=0
replace qwmtm3=1 if (wage${yqtm3}>=1 & wage${yqtm3}<.)
gen qwmtm2=0
replace qwmtm2=1 if (wage${yqtm2}>=1 & wage${yqtm2}<.)
gen qwmtm1=0
replace qwmtm1=1 if (wage${yqtm1}>=1 & wage${yqtm1}<.)
gen qwmtp1=0
replace qwmtp1=1 if (wage${yqtp1}>=1 & wage${yqtp1}<.)
tabstat qwmt qwmtm4 qwmtm3 qwmtm2 qwmtm1 qwmtp1, statistics(count mean median sum)

display "beginning of quarter employment"
gen qwbt=0
replace qwbt=1 if (qwmtm1==1) & (qwmt==1)
display "end of quarter employment"
gen qwet=0
replace qwet=1 if (qwmt==1) & (qwmtp1==1)
display "full quarter employment"
gen qwft=0
replace qwft=1 if (qwmtm1==1) & (qwmt==1) & (qwmtp1==1)
tabstat qwmt qwbt qwet qwft, statistics(count mean median sum)

display "accessions"
gen qwat=0
replace qwat=1 if (qwmtm1==0) & (qwmt==1)
display "accessions to consecutive quarter status"
gen qwa2t=0
replace qwa2t=1 if (qwat==1) & (qwmtp1==1)
display "acessions to full quarter status"
gen qwa3t=0
replace qwa3t=1 if (qwmtm2==0) & (qwmtm1==1) & (qwmt==1) & (qwmtp1==1)
tabstat qwat qwa2t qwa3t, statistics(count mean median sum)

display "separations"
gen qwst=0
replace qwst=1 if (qwmt==1) & (qwmtp1==0)
display "new hires"
gen qwht=0
replace qwht=1 if (qwmtm4==0) & (qwmtm3==0) & (qwmtm2==0) & (qwmtm1==0) & (qwmt==1)
display "recalls"
gen qwrt=0
replace qwrt=1 if (qwmtm1==0) & (qwmt==1) & (qwht==0)
tabstat qwst qwht qwrt, statistics(count mean median sum)

display "(job based) monthly earnings of quarterly flow employment"
gen qww1t = wage$yqt / 3 if qwmt==1
display "(job based) monthly earnings of begin of quarter employees"
gen qww0t = wage$yqt / 3 if qwbt==1
display "(job based) monthly earnings of end of quarter employees"
gen qww2t = wage$yqt / 3 if qwet==1
display "(job based) monthly earnings of full quarter employees"
gen qww3t = wage$yqt / 3 if qwft==1
tabstat qww1t qww0t qww2t qww3t, statistics(count mean median sum)

sort uiacctno idssn
save "$dpr/wqe_$yqtname.dta", replace
describe

* collapse to individual measures"
sort idssn uiacctno
collapse (sum) qwmt qwbt qwet qwft qww1t qww0t qww2t qww3t, by(idssn)
display "(individual based) quarterly employment measures"
tabstat qwmt qwbt qwet qwft, statistics(count mean median sum)
tabstat qwmt qwbt qwet qwft if qwbt>=1, statistics(count mean median sum)
display "(individual based) monthly earnings measures"
tabstat qww1t, statistics(count mean median sum)
tabstat qww0t if qwbt>=1, statistics(count mean median sum)
tabstat qww2t if qwet>=1, statistics(count mean median sum)
tabstat qww3t if qwft>=1, statistics(count mean median sum)

clear
log close
	}
* end of j loop
