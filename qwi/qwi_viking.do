* qwi_viking (20151112)
* secondary to qwi_main
* connect pred/succ pairs and produce adjusted qwi measures

* v loop - for each period t
forvalues v=$yqpfirst/$yqplast {
global yqv: word `v' of $yqclist
global yqtname: word `j' of $yqcnamelist

log using "$log/qwi_viking_$yqv.smcl", replace

* begin with dproduct from egyptian with qwi measures
use "$dpr/wqe_$yqtname.dta", clear
sort idssn uiacctno
describe

* merge with spartan pred-succ files
merge 1:1 idssn uiacctno using "$dpr/wqs_pred_$yqtname.dta", keep(match master) generate(merge_vp)
replace merge_pred=0 if merge_pred==.
merge 1:1 idssn uiacctno using "$dpr/wqs_succ_$yqtname.dta", keep(match master) generate(merge_vs)
replace merge_succ=0 if merge_succ==.

tab merge_pred merge_succ, mis

* revise qwi measures
display "workforce measures for base period $yqv"

display "flow employment"
gen qxmt=qwmt
gen qxmtm4=qwmtm4
gen qxmtm3=qwmtm3
gen qxmtm2=qwmtm2
gen qxmtm1=qwmtm1
	replace qxmtm1=1 if (merge_pred==3)
gen qxmtp1=qwmtp1
	replace qxmtp1=1 if (merge_succ==3)
tabstat qwmt qwmtm4 qwmtm3 qwmtm2 qwmtm1 qwmtp1 qxmt qxmtm4 qxmtm3 qxmtm2 qxmtm1 qxmtp1, statistics(count mean median sum)

display "beginning of quarter employment"
gen qxbt=0
replace qxbt=1 if (qxmtm1==1) & (qxmt==1)
display "end of quarter employment"
gen qxet=0
replace qxet=1 if (qxmt==1) & (qxmtp1==1)
display "full quarter employment"
gen qxft=0
replace qxft=1 if (qxmtm1==1) & (qxmt==1) & (qxmtp1==1)
tabstat qwmt qwbt qwet qwft qxmt qxbt qxet qxft , statistics(count mean median sum)

display "accessions"
gen qxat=0
replace qxat=1 if (qxmtm1==0) & (qxmt==1)
display "accessions to consecutive quarter status"
gen qxa2t=0
replace qxa2t=1 if (qxat==1) & (qxmtp1==1)
display "acessions to full quarter status"
gen qxa3t=0
replace qxa3t=1 if (qxmtm2==0) & (qxmtm1==1) & (qxmt==1) & (qxmtp1==1)
tabstat qwat qwa2t qwa3t qxat qxa2t qxa3t, statistics(count mean median sum)

display "separations"
gen qxst=0
replace qxst=1 if (qxmt==1) & (qxmtp1==0)
display "new hires"
gen qxht=0
replace qxht=1 if (qxmtm4==0) & (qxmtm3==0) & (qxmtm2==0) & (qxmtm1==0) & (qxmt==1)
display "recalls"
gen qxrt=0
replace qxrt=1 if (qxmtm1==0) & (qxmt==1) & (qxht==0)
tabstat qwst qwht qwrt qxst qxht qxrt, statistics(count mean median sum)

display "(job based) monthly earnings of quarterly flow employment"
gen qxw1t = wage$yqv / 3 if qxmt==1
display "(job based) monthly earnings of begin of quarter employees"
gen qxw0t = wage$yqv / 3 if qxbt==1
display "(job based) monthly earnings of end of quarter employees"
gen qxw2t = wage$yqv / 3 if qxet==1
display "(job based) monthly earnings of full quarter employees"
gen qxw3t = wage$yqv / 3 if qxft==1
tabstat qww1t qww0t qww2t qww3t qxw1t qxw0t qxw2t qxw3t, statistics(count mean median sum)

* save
sort idssn uiacctno
save "$dpr/wqv_$yqtname.dta", replace
describe

log close
clear
}
* end of v loop
* return to main
