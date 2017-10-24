* itq_census1060 (9/3/2014)
* run from itq_main (iles_to_qcew_a)
* validate iles employer files, save dta
* applies to iles-qcew files from 2004q2 to 2009q4

* loop selected files
forvalues b=1/$bcount {
global bbb : word `b' of $blist

*** match date entered with single file name needed
*** will need multi-file references in next group
do "$pgm/itq_census1060_find.do"

log using "$log/itq_$bbb.smcl", replace

* main route for all census1060 files, except for 2005q3
if ${bbb}!=0503 {
* open employer file (source: ides, format: 1060, range: 2010 Q1 to present, note: revise file names to ILES (p=prelim, pa=prepre))
		infix str transcode 1 state 2-3 str year 4-7 str quarter 8 str uiacctno 9-18 rptunitno 19-23 ein 24-32 uiacctno_p 33-42 rptunitno_p 43-47 uiacctno_s 48-57 rptunitno_s 58-62 str legalname 63-97 str tradename 98-132 ///
		str uia_street1 133-167 str uia_street2 168-202 str uia_city 203-232 str uia_state 233-234 str uia_zip 235-239 str uia_zipx 240-243 ///
		str pla_street1 244-278 str pla_street2 279-313 str pla_city 314-343 str pla_state 344-345 str pla_zip 346-350 str pla_zipx 351-354 ///
		str moa_street1 355-389 str moa_street2 390-424 str moa_city 425-454 str moa_state 455-456 str moa_zip 457-461 str moa_zipx 462-465 moa_type 466 ///
		str rptunitdesc 467-501 phone 502-511 ///
		sud_year 512-515 sud_month 516-517 sud_day 518-519 ild_year 520-523 ild_month 524-525 ild_day 526-527 eld_year 528-531 eld_month 532-533 eld_day 534-535 rad_year 536-539 rad_month 540-541 rad_day 542-543 ///
		statuscode 544 str cesind 545 arsresponse 546-547 arsrefile 548-551 oldcounty 552-554 oldowner 555 arsverify_year 556-559 oldtownship 560-562 maxrptunitno 563-567 str mwrmailind 568 oldnaics 569-574 ///
		str datasource 575 str specialind 576 str agent 577-580 sic 581-584 str nsta 585-590 naics 591-596 owner 597 str orgztype 598 county 599-601 str township 602-604 aux 605 ///
		employ_m1 606-611 str employ_m1i 612 employ_m2 613-618 str employ_m2i 619 employ_m3 620-625 str employ_m3i 626 totalwages 627-637 str totalwagesind 638 taxablewages 639-649 contributionsdue 650-658 ///
		coveragetype 659 meei 660 rptchgind 661 comment1 662-663 comment2 664-665 comment3 666-667 str comment_narrative 668-724 collectmode 725-726 econchgind 727-728 uia_type 729 pla_datechg 730-737 ///
		str geosoft 738 str geosource 739 str geomatch 740-743 str geolocation 744-746 lattitude 747-755 longitude 756-766 geoupdate 767-771 geoplace 772-776 str geoclass 777-778 censusblock 779-793 censustract 794-797 ///
		str source_ac 798 str ps_pfi 799 ps_tryear 800-803 ps_trmonth 804-805 ps_trday 806-807 str multi_succ 808 str multi_pred 809 str source_pred 810 str source_succ 811 str ps_sup1 812-827 str ps_sup2 828-843 ///
		str arstpa 844 phone_ext 845-849 str es202contact_attn 850-884 str es202contact_title 885-919 str es202contact_email 920-979 es202contact_fax 980-989 str es202contact_web 990-1049 str futureuse 1050-1060 ///
		using "$impb/$fname.TXT"
	}
* detour for 2005q3, replacement ides220 file with reconcile to census1060
	else {
		infix county 1-3 naics 4-9 str uiacctno 10-19 rptunitno 20-24 str emplrname 25-59 ///
		str street_address 60-94 str city 95-114 str state 115-116 str zip 117-121 phone 122-131 str areacode 132-133 ///
		sic 134-137 size 138 str nonprofit 139 ownership 140 alwayszero 141 meei 142 employ_m1 143-149 employ_m2 150-156 employ_m3 157-163 totalwages 164-173 taxablewages 174-183 ///
		lattitude 184-192 longitude 193-203 str yearqtr 204-208 str filler 209-220 using "$impa/$fname.txt"

		rename emplrname tradename 
		rename street_address uia_street1
		rename city uia_city
		rename state uia_state
		rename zip uia_zip
		* yearqtr
		generate year=substr(yearqtr,1,4)
		generate quarter=substr(yearqtr,-1,1)
		rename ownership owner
		generate statuscode=0
	}
		
display "count of records $bbb"
count
display "count of uiacct-defined employers $bbb"
count if rptunitno==0
display "count of employers by status code $bbb"
tab statuscode if rptunitno==0, mis
duplicates report uiacctno
describe
sort uiacctno rptunitno
save "$dpr/qcew_a_$bbb.dta", replace
clear
log close
}
* end of loop

* return to itq_main
