# QWI
Quarterly Workforce Indicator

# QWI is a part of Longitudinal Employer-Household Dynamics from census

We develop a series of code using STATA to process raw QCEW and Wage record to construct QWI measures at the state level. 

## 1. itq: procecss QCEW files

Goal: 
- clean up , 
- construct, 
- and 

## 2. itw: process Wage record files

Goal:
- clean up , 
- construct, 
- and

## 3. qwi: combine itq and itw results to construct qwi indicators

Goal: 

### qwi_aztec.do
process itq & itq to get ready
### qwi_celtic.do
build qwi-wide-shaped records, longitudinal information across date-referenced fields
### qwi_egyptian.do
produce initial qwi measures
### predecessor-successor sequence
qwi_spartan.do 
qwi_viking.do

## 4. qwi_plus: enhence version that add new measures

Goal:
- add accession to fq, Full-quarter hires HirAS 
- add new hire to fq, new hires into full quarter emp HirNS
- add new entrants, 
- add new entrants to fq, 
- add earnings at time t of accession to fq, Full-quarter hires HirAS, called Hires All(Stable) Average
- add earnings at time t of new hire to fq, new hires into full quarter emp HirNS, called Hires New(Stable) Average
- add earnings of new entrants
- add earnings of new entrants to fq

## 4. qwi_j2j: using qwi measures to construct job to job flow measures

Goal: 

# Reference:

If you want to learn qwi concept, [qwi 101](https://lehd.ces.census.gov/doc/QWI_101.pdf) is a complete documentation. 
For a jump start, we suggest starts with page 10 graph. 

If you want to check out the qwi data for each state, [qwi explore](https://qwiexplorer.ces.census.gov/static/explore.html#x=0&g=0) provide the tool to download data. 

Sitation:
