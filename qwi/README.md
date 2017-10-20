# qwi process

- There are a sequence of sub do files from aztec to viking (genius naming btw) 
- first process itq & itw file , then connect them longitudinally, then adjust predecessor-successor

## qwi_aztec.do

- process itq-itw for qwi work
- output files for each quarter (wqa_yyqq.dta)
- we only process the new files because old files have been processed already from last run. 
- if this is your first run, you need to process at least from t-4 to t+1 to create qwi at time t.

## qwi_celtic.do

- build qwi-wide-shaped records, longitudinal information across date-referenced fields
- output files for each quarter (wqc_yyqq.dta)
- you pick the t time files you want to process, but need to include t-4 through t+1 for each t you are procecssing

## qwi_egyptian.do

- produce initial qwi measures
- output files for each quarter (wqe_yyqq.dta)
- the t time files should be consistant with qwi_celtic.do

# predecessor-successor sequence

- qwi_phoenician.do, earlier version, conquered by roman
- qwi_roman.do", earlier version, conquered by spartan

## qwi_spartan.do

- identify qualifying p/s firm pairs
- the t time files should be consistant with qwi_celtic.do

## qwi_viking.do

- reconnect and produce adjusted qwi measures
- the t time files should be consistant with qwi_celtic.do

