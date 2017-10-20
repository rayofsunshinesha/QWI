* qwi_phoenician (10/22/2014)
* secondary to qwi_main
* pred/succ evaluation using itw files
* implements 2-way 80-80 rule
* processing stream parallel to QWI build

* j loop - develop predecessor and successor pairs
forvalues j=$yqpfirst/$yqplast {
global yqa: word `j' of $yqclist
global yqb: word `j' of $yqclist
local tm1=`j'-1
global yqc: word `tm1' of $yqclist
local tp1=`j'+1
global yqd: word `tp1' of $yqclist

log using "$log/qwi_phoenician_$yqa.smcl", replace

* inner loop - prep three data files
	global klist "$yqa $yqb $yqc $yqd"
	forvalues k=1/4 {
	global yqk: word `k' of ${klist}
	use "$impw/wr_nzw_${yqk}.dta"  //* using non-zero-wages file
	keep idssn year quarter uiacctno wage
	sort uiacctno
	by uiacctno: egen pfsum=count(real(idssn))    //* count workers at firm, store on each record
	sort idssn wage
	save "$TEMP/wrp_$yqk.dta", replace
	}
* end of inner loop

******* merge a & b, organize, save
use "$TEMP/wrp_$yqa.dta"
rename uiacctno afirm
rename wage awage
rename pfsum afsum
count

joinby idssn using "$TEMP/wrp_$yqb.dta", unmatched(master)
rename uiacctno bfirm
rename wage bwage
rename pfsum bfsum
display "how many obs in a-b-1?"
count
sort afirm idssn bfirm bwage                //* prepare to eliminate duplicates
duplicates drop afirm idssn bfirm, force   //* drop repeated obs of individuals by other firms
display "how many obs in a-b-2?"
count

sort afirm bfirm                                  //* reorganize to make bfirm count
by afirm bfirm: egen abfsum=count(real(idssn))    //* count workers from target firm observed in paired firm
by afirm bfirm: gen pstest1=abfsum/afsum    //* construct bfirm proportion of target firm workers
by afirm bfirm: gen pstest2=abfsum/bfsum    //* construct target firm proportion of bfirm workers
keep if afsum>=5 & bfsum>=5 & abfsum>=5    //* apply filter for scale of firms and transition cluster
display "how many obs in a-b-3?"
count

collapse (firstnm) afsum bfsum abfsum pstest1 pstest2, by(afirm bfirm)  //* collapse to universe of firm combinations
display "how many observed firm combinations?"
count
display "how many observed combinations with 80% or more flowing to-or-from missing firm?"
count if (pstest1>=.8 & pstest1<=1 & afirm=="") | (pstest2>=.8 & pstest2<=1 & afirm=="")
count if (pstest1>=.8 & pstest1<=1 & bfirm=="") | (pstest2>=.8 & pstest2<=1 & bfirm=="")
display "how many observed combinations with 80% or more flowing to-or-from non-missing firms?"
count if (pstest1>=.8 & pstest1<=1 & afirm!="") | (pstest2>=.8 & pstest2<=1 & afirm!="")
count if (pstest1>=.8 & pstest1<=1 & bfirm!="") | (pstest2>=.8 & pstest2<=1 & bfirm!="")
display "trim to target-pred firm pairs"
keep if (pstest1>=.8 & pstest1<=1 & afirm!="") | (pstest2>=.8 & pstest2<=1 & afirm!="")
keep if (pstest1>=.8 & pstest1<=1 & bfirm!="") | (pstest2>=.8 & pstest2<=1 & bfirm!="")
display "how many observed combinations with 80% or more remaining in same firm?"
count if (pstest1>=.8 & pstest1<=1 & bfirm==afirm) | (pstest2>=.8 & pstest2<=1 & bfirm==afirm)
display "eliminate firm pairs that are identical twins"
keep if afirm!=bfirm
generate mfirm=bfirm

display "list of a-b pairs"
*list afirm bfirm afsum bfsum mfirm abfsum pstest1 pstest2
gen psgroup="ab"
save "$TEMP/ab_pairs_$yqa.dta", replace
count
clear

******* merge a & c, organize, save
use "$TEMP/wrp_$yqa.dta"
rename uiacctno afirm
rename wage awage
rename pfsum afsum
count

joinby idssn using "$TEMP/wrp_$yqc.dta", unmatched(master)
rename uiacctno cfirm
rename wage cwage
rename pfsum cfsum
display "how many obs in a-c-1?"
count
sort afirm idssn cfirm cwage                //* prepare to eliminate duplicates
duplicates drop afirm idssn cfirm, force   //* drop repeated obs of individuals by other firms
display "how many obs in a-c-2?"
count

sort afirm cfirm                           //* reorganize to make bfirm count
by afirm cfirm: egen acfsum=count(real(idssn))    //* count workers from target firm observed in paired firm
by afirm cfirm: gen pstest1=acfsum/afsum    //* construct bfirm proportion of target firm workers
by afirm cfirm: gen pstest2=acfsum/cfsum    //* construct target firm proportion of bfirm workers
keep if afsum>=5 & cfsum>=5 & acfsum>=5    //* apply filter for scale of firms and transition cluster
display "how many obs in a-c-3?"
count

collapse (firstnm) afsum cfsum acfsum pstest1 pstest2, by(afirm cfirm)  //* collapse to universe of firm combinations
display "how many observed firm combinations?"
count
display "how many observed combinations with 80% or more flowing to-or-from missing firm?"
count if (pstest1>=.8 & pstest1<=1 & afirm=="") | (pstest2>=.8 & pstest2<=1 & afirm=="")
count if (pstest1>=.8 & pstest1<=1 & cfirm=="") | (pstest2>=.8 & pstest2<=1 & cfirm=="")
display "how many observed combinations with 80% or more flowing to-or-from non-missing firms?"
count if (pstest1>=.8 & pstest1<=1 & afirm!="") | (pstest2>=.8 & pstest2<=1 & afirm!="")
count if (pstest1>=.8 & pstest1<=1 & cfirm!="") | (pstest2>=.8 & pstest2<=1 & cfirm!="")
display "trim to target-pred firm pairs"
keep if (pstest1>=.8 & pstest1<=1 & afirm!="") | (pstest2>=.8 & pstest2<=1 & afirm!="")
keep if (pstest1>=.8 & pstest1<=1 & cfirm!="") | (pstest2>=.8 & pstest2<=1 & cfirm!="")
display "how many observed combinations with 80% or more remaining in same firm?"
count if (pstest1>=.8 & pstest1<=1 & cfirm==afirm) | (pstest2>=.8 & pstest2<=1 & cfirm==afirm)
display "eliminate firm pairs that are identical twins"
keep if afirm!=cfirm
generate mfirm=cfirm

display "list of a-c pairs"
*list afirm cfirm mfirm afsum cfsum acfsum pstest1 pstest2
gen psgroup="ac"
save "$TEMP/ac_pairs_$yqa.dta", replace
count
clear

******* merge a & d, organize, save
use "$TEMP/wrp_$yqa.dta"
rename uiacctno afirm
rename wage awage
rename pfsum afsum
count

joinby idssn using "$TEMP/wrp_$yqd.dta", unmatched(master)
rename uiacctno dfirm
rename wage dwage
rename pfsum dfsum
display "how many obs in a-d-1?"
count
sort afirm idssn dfirm dwage                //* prepare to eliminate duplicates
duplicates drop afirm idssn dfirm, force   //* drop repeated obs of individuals by other firms
display "how many obs in a-d-2?"
count

sort afirm dfirm                           //* reorganize to make bfirm count
by afirm dfirm: egen adfsum=count(real(idssn))    //* count workers from target firm observed in paired firm
by afirm dfirm: gen pstest1=adfsum/afsum    //* construct bfirm proportion of target firm workers
by afirm dfirm: gen pstest2=adfsum/dfsum    //* construct target firm proportion of bfirm workers
keep if afsum>=5 & dfsum>=5 & adfsum>=5    //* apply filter for scale of firms and transition cluster
display "how many obs in a-d-3?"
count

collapse (firstnm) afsum dfsum adfsum pstest1 pstest2, by(afirm dfirm)  //* collapse to universe of firm combinations
display "how many observed firm combinations?"
count
display "how many observed combinations with 80% or more flowing to-or-from missing firm?"
count if (pstest1>=.8 & pstest1<=1 & afirm=="") | (pstest2>=.8 & pstest2<=1 & afirm=="")
count if (pstest1>=.8 & pstest1<=1 & dfirm=="") | (pstest2>=.8 & pstest2<=1 & dfirm=="")
display "how many observed combinations with 80% or more flowing to-or-from non-missing firms?"
count if (pstest1>=.8 & pstest1<=1 & afirm!="") | (pstest2>=.8 & pstest2<=1 & afirm!="")
count if (pstest1>=.8 & pstest1<=1 & dfirm!="") | (pstest2>=.8 & pstest2<=1 & dfirm!="")
display "trim to target-pred firm pairs"
keep if (pstest1>=.8 & pstest1<=1 & afirm!="") | (pstest2>=.8 & pstest2<=1 & afirm!="")
keep if (pstest1>=.8 & pstest1<=1 & dfirm!="") | (pstest2>=.8 & pstest2<=1 & dfirm!="")
display "how many observed combinations with 80% or more remaining in same firm?"
count if (pstest1>=.8 & pstest1<=1 & dfirm==afirm) | (pstest2>=.8 & pstest2<=1 & dfirm==afirm)
keep if afirm!=dfirm
generate mfirm=dfirm

display "list of a-d pairs"
*list afirm dfirm mfirm afsum dfsum adfsum pstest1 pstest2
gen psgroup="ad"
save "$TEMP/ad_pairs_$yqa.dta", replace
count
clear


******* append ab,ac,ad pair,timestamp, save
 
use "$TEMP/ab_pairs_$yqa.dta"
append using "$TEMP/ac_pairs_$yqa.dta"
append using "$TEMP/ad_pairs_$yqa.dta"
display "how many obs in combined dataset?"
count
sort afirm mfirm                      //* prepare to eliminate duplicates across subsamples
list afirm mfirm bfirm cfirm dfirm afsum bfsum cfsum dfsum abfsum acfsum adfsum in 1/120
duplicates report afirm mfirm
*duplicates drop afirm bfirm, force   //* drop repeated obs of ps-firm combinations
collapse (firstnm) bfirm cfirm dfirm afsum bfsum cfsum dfsum abfsum acfsum adfsum, by (afirm mfirm)

display "number of paired firm combinations"
count
display "bfirm=cfirm?"
count if bfirm==cfirm & bfirm!=""
display "bfirm=dfirm?"
count if bfirm==dfirm & bfirm!=""
display "cfirm=dfirm?"
count if cfirm==dfirm & cfirm!=""
display "bfirm=cfirm=dfirm?"
count if bfirm==cfirm & bfirm==dfirm & bfirm!=""

list afirm mfirm bfirm cfirm dfirm afsum bfsum cfsum dfsum abfsum acfsum adfsum in 1/120

gen yqtag="$yqa"

save "$dpr/wqps_pairs_$yqa.dta", replace
describe
duplicates report afirm
preserve

* prep employer data
	global klist "$yqa $yqb $yqc $yqd"
	forvalues k=1/4 {
	global yqk: word `k' of ${klist}
	use "$impq/qcew_ndr_$yqk.dta"  //* using non-duplicate-records file
	keep uiacctno naics owner tradename uia_city uia_state
	sort uiacctno
	save "$TEMP/q_$yqk.dta", replace
	clear
	}
	* end of qcew prep loop

******	attach qcew-afirm, report, save
restore
* start with afirm info
generate uiacctno=afirm
merge m:1 uiacctno using "$TEMP/q_$yqa.dta", keep(master match) generate(a_merge)
rename naics naics_a
rename owner owner_a
rename tradename tradename_a
rename uia_city city_a
rename uia_state state_a
* move to mfirm info
replace uiacctno=mfirm
merge m:1 uiacctno using "$TEMP/q_$yqb.dta", keep(master match) generate(b_merge)
rename naics naics_m
rename owner owner_m
rename tradename tradename_m
rename uia_city city_m
rename uia_state state_m
merge m:1 uiacctno using "$TEMP/q_$yqc.dta", keep(master match) generate(c_merge)
replace naics_m=naics if naics_m==.
replace owner_m=owner if owner_m==.
replace tradename_m=tradename if tradename_m==""
replace city_m=uia_city if city_m==""
replace state_m=uia_state if state_m==""
merge m:1 uiacctno using "$TEMP/q_$yqd.dta", keep(master match) generate(d_merge)
replace naics_m=naics if naics_m==.
replace owner_m=owner if owner_m==.
replace tradename_m=tradename if tradename_m==""
replace city_m=uia_city if city_m==""
replace state_m=uia_state if state_m==""

sort afirm mfirm
list afirm mfirm naics_a naics_m tradename_a tradename_m city_a city_m state_a state_m in 1/120
}
oooops

gen ps_qcew_flag=0
replace ps_qcew_flag=1 if _merge==3
drop _merge
rename bfirm uiacctno
tostring uiacctno, replace format(%7.0f)
sort uiacctno

save "$dpr/ps_remix_pairs_$yqa.dta", replace
describe
clear

}
*end of j loop


**** what's the goal?
**** new columns for qwi file with ps adjusted values
**** t-1,t,t+1 adjustments / increase boq-eoq-fq / decrease acessions-newhires-recalls (how Cornell uses it)
**** could also apply adjustment to "primary job" but would require collapse of selected jobs at t (application beyond Cornell use)
**** should enable this in ps-detour as well, attach adjusted "primary job" info (wages) to the unadjusted primary?

log close
exit
