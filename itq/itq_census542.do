* itq_census542 (9/3/2014)
* run from itq_main (iles_to_qcew_a)
* validate iles employer files, save dta
* applies to iles-qcew files from 1999q1 to 2004q1

* loop selected files
forvalues c=1/$ccount {
global ccc : word `c' of $clist

do "$pgm/itq_census542_find.do"
* (returns fcount and fnames)

log using "$log/itq_$ccc.smcl", replace

if (${fcount}==1 | ${fcount}==2 | ${fcount}==3) {

* open employer file (source: ides, format: 542, range: 1999q1 to 2004q1, note: revise file names to ILES (p=prelim, pa=prepre))

infix program_code 1-2 multi_unit_code 3 state 4-5 str uiacctno 6-15 rptunitno 16-20 ein 21-29 str tradename 30-64 str pla_street1 65-99 str pla_street2 100-134 str pla_city 135-164 ///
      str pla_state 165-166 str pla_zip 167-171 str pla_zipx 172-175 address_type 176 coverage_type 177 comment1_flg 178-179 comment2_flg 180-181 comment3_flg 182-183 str year 184-187 str quarter 188 ///
      str legalname 189-223 str name_worksite 224-258 employ_m1 259-264 str employ_m1i 265 employ_m2 266-271 str employ_m2i 272 employ_m3 273-278 str employ_m3i 279 totalwages 280-290 str totalwagesind 291 ///
      str comments 292-348 ild_year 349-352 ild_month 353-354 eld_year 355-358 eld_month 359-360 rad_year 361-364 rad_month 365-366 statuscode 367 county 368-370 ///
      phone 371-380 str uia_street1 381-415 str uia_street2 416-450 str uia_city 451-480 str uia_state 481-482 str uia_zip 483-487 str uia_zipx 488-491 ///
      naics 492-498 auxiliary_NAICS 499-504 uiacctno_p 505-514 rptunitno_p 515-519 uiacctno_s 520-529 rptunitno_s 530-534 owner 535 str township 536-538 sic 539-542 ///		
	  using "$impc/$fname1.TXT"

	generate yrqtr=substr(year,3,2)+"0"+quarter
	keep if yrqtr=="${ccc}"
	display "count of ${ccc} records in ${fname1}, 1 of ${fcount}"
	count
sort uiacctno rptunitno
save "$TEMP/part1.dta", replace
clear
}
* end of fcount 1 loop


if (${fcount}==2 | ${fcount}==3) {

* open employer file (source: ides, format: 542, range: 1999q1 to 2004q1, note: revise file names to ILES (p=prelim, pa=prepre))
infix program_code 1-2 multi_unit_code 3 state 4-5 str uiacctno 6-15 rptunitno 16-20 ein 21-29 str tradename 30-64 str pla_street1 65-99 str pla_street2 100-134 str pla_city 135-164 ///
      str pla_state 165-166 str pla_zip 167-171 str pla_zipx 172-175 address_type 176 coverage_type 177 comment1_flg 178-179 comment2_flg 180-181 comment3_flg 182-183 str year 184-187 str quarter 188 ///
      str legalname 189-223 str name_worksite 224-258 employ_m1 259-264 str employ_m1i 265 employ_m2 266-271 str employ_m2i 272 employ_m3 273-278 str employ_m3i 279 totalwages 280-290 str totalwagesind 291 ///
      str comments 292-348 ild_year 349-352 ild_month 353-354 eld_year 355-358 eld_month 359-360 rad_year 361-364 rad_month 365-366 statuscode 367 county 368-370 ///
      phone 371-380 str uia_street1 381-415 str uia_street2 416-450 str uia_city 451-480 str uia_state 481-482 str uia_zip 483-487 str uia_zipx 488-491 ///
      naics 492-498 auxiliary_NAICS 499-504 uiacctno_p 505-514 rptunitno_p 515-519 uiacctno_s 520-529 rptunitno_s 530-534 owner 535 str township 536-538 sic 539-542 ///
		using "$impc/$fname2.TXT"

	generate yrqtr=substr(year,3,2)+"0"+quarter
	keep if yrqtr=="${ccc}"
	display "count of ${ccc} records in ${fname2}, 2 of ${fcount}"
	count
sort uiacctno rptunitno
save "$TEMP/part2.dta", replace
clear
}
* end of fcount 2 loop

if (${fcount}==3) {

* open employer file (source: ides, format: 542, range: 1999q1 to 2004q1, note: revise file names to ILES (p=prelim, pa=prepre))
infix program_code 1-2 multi_unit_code 3 state 4-5 str uiacctno 6-15 rptunitno 16-20 ein 21-29 str tradename 30-64 str pla_street1 65-99 str pla_street2 100-134 str pla_city 135-164 ///
      str pla_state 165-166 str pla_zip 167-171 str pla_zipx 172-175 address_type 176 coverage_type 177 comment1_flg 178-179 comment2_flg 180-181 comment3_flg 182-183 str year 184-187 str quarter 188 ///
      str legalname 189-223 str name_worksite 224-258 employ_m1 259-264 str employ_m1i 265 employ_m2 266-271 str employ_m2i 272 employ_m3 273-278 str employ_m3i 279 totalwages 280-290 str totalwagesind 291 ///
      str comments 292-348 ild_year 349-352 ild_month 353-354 eld_year 355-358 eld_month 359-360 rad_year 361-364 rad_month 365-366 statuscode 367 county 368-370 ///
      phone 371-380 str uia_street1 381-415 str uia_street2 416-450 str uia_city 451-480 str uia_state 481-482 str uia_zip 483-487 str uia_zipx 488-491 ///
      naics 492-498 auxiliary_NAICS 499-504 uiacctno_p 505-514 rptunitno_p 515-519 uiacctno_s 520-529 rptunitno_s 530-534 owner 535 str township 536-538 sic 539-542 ///
		using "$impc/$fname3.TXT"

	generate yrqtr=substr(year,3,2)+"0"+quarter
	keep if yrqtr=="${ccc}"
	display "count of ${ccc} records in ${fname3}, 3 of ${fcount}"
	count
sort uiacctno rptunitno
save "$TEMP/part3.dta", replace
clear
}
* end of fcount 3 loop


if (${fcount}==1 | ${fcount}==2 | ${fcount}==3) {
use "$TEMP/part1.dta"
}
if (${fcount}==2 | ${fcount}==3) {
append using "$TEMP/part2.dta"
}
if (${fcount}==3) {
append using "$TEMP/part3.dta"
}
* end of conditional append process

display "count of records $ccc"
count
display "count of uiacct-defined employers $ccc"
count if rptunitno==0  //* ??? investigate this issue before implementing
display "count of employers by status code $ccc"
tab statuscode if rptunitno==0, mis
duplicates report uiacctno
describe
sort uiacctno rptunitno
save "$dpr/qcew_a_$ccc.dta", replace

clear
log close
}
* end of date-based loop

* return to itq_main

