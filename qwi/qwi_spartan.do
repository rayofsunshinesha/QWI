* qwi_spartan (20151112)
* secondary to qwi_main
* pred/succ evaluation using itw files
* implements 2-way 80-80 rule
* processing stream parallel to QWI build

* j loop - develop predecessor and successor pairs
forvalues j=$yqpfirst/$yqplast {
global yqa: word `j' of $yqclist
global yqb: word `j' of $yqclist
global yqtname: word `j' of $yqcnamelist
local tm1=`j'-1
global yqc: word `tm1' of $yqclist
local tp1=`j'+1
global yqd: word `tp1' of $yqclist

log using "$log/qwi_spartan_$yqa.smcl", replace

* inner loop - prep five data files
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
	preserve
	rename uiacctno mfirm
	keep idssn afirm mfirm
	save "$TEMP/wrs_ab.dta", replace
	restore
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
	preserve
	rename uiacctno mfirm
	keep idssn afirm mfirm
	save "$TEMP/wrs_ac.dta", replace
	restore
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
	preserve
	rename uiacctno mfirm
	keep idssn afirm mfirm
	save "$TEMP/wrs_ad.dta", replace
	restore
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

******* append ab & ac for predecessors.  timestamp, save.
 
use "$TEMP/ab_pairs_$yqa.dta"
append using "$TEMP/ac_pairs_$yqa.dta"
display "how many obs in combined dataset?"
count
sort afirm mfirm                      //* prepare to eliminate duplicates across subsamples
list afirm mfirm psgroup bfirm cfirm afsum bfsum cfsum abfsum acfsum in 1/40
duplicates report afirm mfirm
collapse (firstnm) bfirm cfirm afsum bfsum cfsum abfsum acfsum, by (afirm mfirm)

display "number of paired firm combinations"
count
display "bfirm=cfirm?"
count if bfirm==cfirm & bfirm!=""

list afirm mfirm bfirm cfirm afsum bfsum cfsum abfsum acfsum in 1/40

gen yqtag="$yqa"
sort afirm mfirm
save "$TEMP/wqs_ppairs_$yqa.dta", replace
describe
duplicates report afirm
clear

*** rebuild partial wr file with pred info

use "$TEMP/wrs_ab.dta", clear
append using "$TEMP/wrs_ac.dta"
sort afirm mfirm idssn
gen uno=1
collapse (sum) uno, by(afirm mfirm idssn)
count
merge m:1 afirm mfirm using "$TEMP/wqs_ppairs_$yqa.dta", keep(match) generate(merge_pred)
count
rename afirm uiacctno
sort idssn uiacctno
duplicates report idssn uiacctno
duplicates drop idssn uiacctno, force
keep idssn uiacctno merge_pred
save "$dpr/wqs_pred_$yqtname.dta", replace
describe
clear

******* append ab & ad for successors.  timestamp, save.
 
use "$TEMP/ab_pairs_$yqa.dta"
append using "$TEMP/ad_pairs_$yqa.dta"
display "how many obs in combined dataset?"
count
sort afirm mfirm                      //* prepare to eliminate duplicates across subsamples
list afirm mfirm psgroup bfirm dfirm afsum bfsum dfsum abfsum adfsum in 1/40
duplicates report afirm mfirm
collapse (firstnm) bfirm dfirm afsum bfsum dfsum abfsum adfsum, by (afirm mfirm)

display "number of paired firm combinations"
count
display "bfirm=dfirm?"
count if bfirm==dfirm & bfirm!=""

list afirm mfirm bfirm dfirm afsum bfsum dfsum abfsum adfsum in 1/40

gen yqtag="$yqa"
sort afirm mfirm
save "$TEMP/wqs_spairs_$yqa.dta", replace
describe
duplicates report afirm
clear

*** rebuild partial wr file with succ info

use "$TEMP/wrs_ab.dta", clear
append using "$TEMP/wrs_ad.dta"
sort afirm mfirm idssn
generate uno=1
collapse (sum) uno, by(afirm mfirm idssn)
count
merge m:1 afirm mfirm using "$TEMP/wqs_spairs_$yqa.dta", keep(match) generate(merge_succ)
count
rename afirm uiacctno
sort idssn uiacctno
duplicates report idssn uiacctno
duplicates drop idssn uiacctno, force
keep idssn uiacctno merge_succ
save "$dpr/wqs_succ_$yqtname.dta", replace
describe
clear

log close
}
* end of loop
* return to main
