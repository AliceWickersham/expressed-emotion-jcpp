use "[filepath]" , clear

*********************************
***EXPLORING AND CLEANING DATA***
*********************************

*Exploring data
codebook , compact

*Investigating data missingness in each variable under study
misstable summarize

foreach var in bwgre5 warme10 disse10 cdie12 masce12 totadde12 CDtotcrit_emt12 PH_E INTCF_E EXTCF_E THDCF_E {
	gen `var'_missing=(`var'!=.)
	lab def `var'_missing 0 "Missing" 1 "Observed"
	lab val `var'_missing `var'_missing 
	tab `var'_missing 
	drop `var'_missing 
}

*Investigating complete cases for both twins (excluding birth weight)
gen complete_cases=(warme10!=. &  warmy10!=. &  disse10!=. &  dissy10!=. &  cdie12!=. &  cdiy12!=. &  masce12!=. &  mascy12!=. &  totadde12!=. &  totaddy12!=. &  CDtotcrit_emt12!=. &  CDtotcrit_ymt12!=. &  PH_E!=. &  PH_Y!=. &  INTCF_E!=. &  INTCF_Y!=. &  EXTCF_E!=. &  EXTCF_Y!=. &  THDCF_E!=. &  THDCF_Y!=.)
lab var complete_cases "Indicator of complete cases across all variables under study, excluding birth weight"
lab def complete_cases 0 "Incomplete" 1 "Complete"
lab val complete_cases complete_cases 

tab complete_cases

*Descriptives - full sample
foreach var in torder risks cohort sampsex zygosity seswq35 sethnic {
	tab `var' 
}

tabstat warme10 disse10 bwgre5 totexte5 totemoe5 cdie12 masce12 totadde12 CDtotcrit_emt12 PH_E INTCF_E EXTCF_E THDCF_E , s(n, mean, sd)

*Descriptives - complete cases
foreach var in torder risks cohort sampsex zygosity seswq35 sethnic {
	tab `var' if complete_cases==1
}

tabstat warme10 disse10 bwgre5 totexte5 totemoe5 cdie12 masce12 totadde12 CDtotcrit_emt12 PH_E INTCF_E EXTCF_E THDCF_E if complete_cases==1, s(n, mean, sd)

*Checking correlation between negativity and warmth 
pwcorr disse10 warme10 , obs sig

*Keeping complete cases (excluding birth weight) for analysis
drop if complete_cases==0

****************************
***DESCRIPTIVE STATISTICS***
****************************

tab sampsex
tab zygosity 
tab seswq35
tab sethnic
summarize bwgre5 warme10 disse10 INTCF_E totexte5 totemoe5 cdie12 masce12 totadde12 CDtotcrit_emt12 PH_E INTCF_E EXTCF_E THDCF_E 

count if bwgre5==. 

***********************************************
***ANALYSIS 1: MATERNAL EE AND ADOLESCENT MH***
***********************************************

***Warmth exposure***

foreach var in cdie12 masce12 totadde12 CDtotcrit_emt12 PH_E INTCF_E EXTCF_E THDCF_E {
	regress `var' warme10, cluster(familyid)
	regress `var' warme10 i.sampsex i.seswq35 , cluster(familyid)
	regress `var' warme10 i.sampsex i.seswq35 totemoe5 totexte5, cluster(familyid)

}

*Checking linear regression assumptions - warmth exposure
/*
cd "[filepath]"

foreach var in cdie12 masce12 totadde12 CDtotcrit_emt12 PH_E INTCF_E EXTCF_E THDCF_E {
	regress `var' warme10 i.sampsex i.seswq35 totemoe5 totexte5, cluster(familyid)
	predict `var'_pred
	predict `var'_resid, residuals
	
	*Normal residuals
	hist `var'_resid , title(`var')
	graph save `var'_normal.gph , replace 
	
	*Heteroskedasticity
	scatter `var'_resid `var'_pred , title(`var')
	graph save `var'_homosked.gph , replace 
	
	*Non-linear relationship
	regress `var' c.warme10##c.warme10 i.sampsex i.seswq35 totemoe5 totexte5, cluster(familyid)
	
	drop `var'_pred `var'_resid
}

graph combine cdie12_normal.gph masce12_normal.gph totadde12_normal.gph CDtotcrit_emt12_normal.gph PH_E_normal.gph INTCF_E_normal.gph EXTCF_E_normal.gph THDCF_E_normal.gph

graph combine cdie12_homosked.gph masce12_homosked.gph totadde12_homosked.gph CDtotcrit_emt12_homosked.gph PH_E_homosked.gph INTCF_E_homosked.gph EXTCF_E_homosked.gph THDCF_E_homosked.gph

foreach var in cdie12 masce12 totadde12 CDtotcrit_emt12 PH_E INTCF_E EXTCF_E THDCF_E {
	erase `var'_normal.gph
	erase `var'_homosked.gph
}

*/

***Dissatisfaction/negativity exposure***

foreach var in cdie12 masce12 totadde12 CDtotcrit_emt12 PH_E INTCF_E EXTCF_E THDCF_E {
	regress `var' disse10, cluster(familyid)
	regress `var' disse10 i.sampsex i.seswq35 , cluster(familyid)
	regress `var' disse10 i.sampsex i.seswq35 totemoe5 totexte5, cluster(familyid)
}

*Checking linear regression assumptions - dissatisfaction/negativity exposure
/*
cd "[filepath]"

foreach var in cdie12 masce12 totadde12 CDtotcrit_emt12 PH_E INTCF_E EXTCF_E THDCF_E {
	regress `var' disse10 i.sampsex i.seswq35 totemoe5 totexte5, cluster(familyid)
	predict `var'_pred
	predict `var'_resid, residuals
	
	*Normal residuals
	hist `var'_resid , title(`var')
	graph save `var'_normal.gph , replace 
	
	*Heteroskedasticity
	scatter `var'_resid `var'_pred , title(`var')
	graph save `var'_homosked.gph , replace 
	
	*Non-linear relationship
	regress `var' c.disse10##c.disse10 i.sampsex i.seswq35 totemoe5 totexte5, cluster(familyid)
	
	drop `var'_pred `var'_resid
}

graph combine cdie12_normal.gph masce12_normal.gph totadde12_normal.gph CDtotcrit_emt12_normal.gph PH_E_normal.gph INTCF_E_normal.gph EXTCF_E_normal.gph THDCF_E_normal.gph

graph combine cdie12_homosked.gph masce12_homosked.gph totadde12_homosked.gph CDtotcrit_emt12_homosked.gph PH_E_homosked.gph INTCF_E_homosked.gph EXTCF_E_homosked.gph THDCF_E_homosked.gph

foreach var in cdie12 masce12 totadde12 CDtotcrit_emt12 PH_E INTCF_E EXTCF_E THDCF_E {
	erase `var'_normal.gph
	erase `var'_homosked.gph
}
*/

***Deriving Beta coefficients (clustering option removed)***

***Warmth exposure*** 
set cformat %9.2f

foreach var in cdie12 masce12 totadde12 CDtotcrit_emt12 PH_E INTCF_E EXTCF_E THDCF_E {
	regress `var' warme10, beta 
	regress `var' warme10 i.sampsex i.seswq35 , beta
	regress `var' warme10 i.sampsex i.seswq35 totemoe5 totexte5, beta

}

***Dissatisfaction/negativity exposure*** 

foreach var in cdie12 masce12 totadde12 CDtotcrit_emt12 PH_E INTCF_E EXTCF_E THDCF_E {
	regress `var' disse10, beta
	regress `var' disse10 i.sampsex i.seswq35 , beta
	regress `var' disse10 i.sampsex i.seswq35 totemoe5 totexte5, beta
}


*********************************************
***ANALYSIS 2: SIMILARITY BETWEEN MZ TWINS***
*********************************************

preserve

keep if zygosity==1 & torder==1

pwcorr warme10 warmy10 , obs sig
pwcorr disse10 dissy10 , obs sig
pwcorr cdie12 cdiy12 , obs sig
pwcorr masce12 mascy12 , obs sig
pwcorr totadde12 totaddy12 , obs sig
pwcorr CDtotcrit_emt12 CDtotcrit_ymt12 , obs sig
pwcorr PH_E PH_Y , obs sig
pwcorr INTCF_E INTCF_Y , obs sig
pwcorr EXTCF_E EXTCF_Y , obs sig
pwcorr THDCF_E THDCF_Y , obs sig

restore

******************************************
***ANALYSIS 3: TWIN DIFFERENCE ANALYSES***
******************************************

***Creating twin difference variables***
*Exposures
gen tdiffdiss10 = disse10 - dissy10
lab var tdiffdiss10 "Twin difference in maternal dissatisfaction/negativity at age 10"

gen tdiffwarm10 = warme10 - warmy10
lab var tdiffwarm10 "Twin difference in maternal warmth at age 10"

*Outcomes

gen tdiffcdi = cdie12 - cdiy12
label variable tdiffcdi "Twin difference in depression symptoms at age 12"

gen tdiffmasc = masce12 - mascy12
label variable tdiffmasc "Twin difference in anxiety symptoms at age 12"

gen tdifftotadd = totadde12 - totaddy12
label variable tdifftotadd "Twin difference in ADHD symptoms at age 12"

gen tdiffCDtotcrit = CDtotcrit_emt12 - CDtotcrit_ymt12
label variable tdiffCDtotcrit "Twin difference in CD symptoms at age 12"

gen tdiffPH = PH_E - PH_Y
label variable tdiffPH "Twin difference in P-factor symptoms at age 18"

gen tdiffINTCF = INTCF_E - INTCF_Y
label variable tdiffINTCF "Twin difference in internalising symptoms at age 18"

gen tdiffEXTCF = EXTCF_E - EXTCF_Y
label variable tdiffEXTCF "Twin difference in externalising symptoms at age 18"

gen tdiffTHDCF = THDCF_E - THDCF_Y
label variable tdiffTHDCF "Twin difference in thought disorder symptoms at age 18"

*Covariates

gen tdiffemo5 = totemoe5 - totemoy5
label variable tdiffemo5 "Twin difference in emotional problems at age 5"

gen tdiffext5 = totexte5 - totexty5
label variable tdiffext5 "Twin difference in externalising problems at age 5"

gen tdiffbwgr5 = bwgre5 - bwgry5
label variable tdiffbwgr5 "Twin difference in birth weight at age 5"

***Analysis***

*Keeping MZ twins and elder twin only
keep if zygosity==1 & torder==1

*Twin difference analysis - warmth exposure

foreach var in tdiffcdi tdiffmasc tdifftotadd tdiffCDtotcrit tdiffPH tdiffINTCF tdiffEXTCF tdiffTHDCF {
	regress `var' tdiffwarm10 
	regress `var' tdiffwarm10 tdiffemo5 tdiffext5
	regress `var' tdiffwarm10 tdiffemo5 tdiffext5 tdiffbwgr5
}

*Checking linear regression assumptions - twin difference warmth exposure
/*
cd "[filepath]"

foreach var in tdiffcdi tdiffmasc tdifftotadd tdiffCDtotcrit tdiffPH tdiffINTCF tdiffEXTCF tdiffTHDCF {
	regress `var' tdiffwarm10 tdiffemo5 tdiffext5 tdiffbwgr5
	predict `var'_pred
	predict `var'_resid, residuals
	
	*Normal residuals
	hist `var'_resid , title(`var')
	graph save `var'_normal.gph , replace 
	
	*Heteroskedasticity
	scatter `var'_resid `var'_pred , title(`var')
	graph save `var'_homosked.gph , replace 
	
	*Non-linear relationship
	regress `var' c.tdiffwarm10##c.tdiffwarm10 tdiffemo5 tdiffext5 tdiffbwgr5
	
	drop `var'_pred `var'_resid
}

graph combine tdiffcdi_normal.gph tdiffmasc_normal.gph tdifftotadd_normal.gph tdiffCDtotcrit_normal.gph tdiffPH_normal.gph tdiffINTCF_normal.gph tdiffEXTCF_normal.gph tdiffTHDCF_normal.gph

graph combine tdiffcdi_homosked.gph tdiffmasc_homosked.gph tdifftotadd_homosked.gph tdiffCDtotcrit_homosked.gph tdiffPH_homosked.gph tdiffINTCF_homosked.gph tdiffEXTCF_homosked.gph tdiffTHDCF_homosked.gph

foreach var in tdiffcdi tdiffmasc tdifftotadd tdiffCDtotcrit tdiffPH tdiffINTCF tdiffEXTCF tdiffTHDCF {
	erase `var'_normal.gph
	erase `var'_homosked.gph
}
*/


*Twin difference analysis - dissatisfaction/negativity exposure exposure

foreach var in tdiffcdi tdiffmasc tdifftotadd tdiffCDtotcrit tdiffPH tdiffINTCF tdiffEXTCF tdiffTHDCF {
	regress `var' tdiffdiss10
	regress `var' tdiffdiss10 tdiffemo5 tdiffext5 
	regress `var' tdiffdiss10 tdiffemo5 tdiffext5 tdiffbwgr5
}

*Checking linear regression assumptions - twin difference dissatisfaction/negativity exposure
/*
cd "[filepath]"

foreach var in tdiffcdi tdiffmasc tdifftotadd tdiffCDtotcrit tdiffPH tdiffINTCF tdiffEXTCF tdiffTHDCF {
	regress `var' tdiffdiss10 tdiffemo5 tdiffext5 tdiffbwgr5
	predict `var'_pred
	predict `var'_resid, residuals
	
	*Normal residuals
	hist `var'_resid , title(`var')
	graph save `var'_normal.gph , replace 
	
	*Heteroskedasticity
	scatter `var'_resid `var'_pred , title(`var')
	graph save `var'_homosked.gph , replace 
	
	*Non-linear relationship
	regress `var' c.tdiffdiss10##c.tdiffdiss10 tdiffemo5 tdiffext5 tdiffbwgr5
	
	drop `var'_pred `var'_resid
}

graph combine tdiffcdi_normal.gph tdiffmasc_normal.gph tdifftotadd_normal.gph tdiffCDtotcrit_normal.gph tdiffPH_normal.gph tdiffINTCF_normal.gph tdiffEXTCF_normal.gph tdiffTHDCF_normal.gph

graph combine tdiffcdi_homosked.gph tdiffmasc_homosked.gph tdifftotadd_homosked.gph tdiffCDtotcrit_homosked.gph tdiffPH_homosked.gph tdiffINTCF_homosked.gph tdiffEXTCF_homosked.gph tdiffTHDCF_homosked.gph

foreach var in tdiffcdi tdiffmasc tdifftotadd tdiffCDtotcrit tdiffPH tdiffINTCF tdiffEXTCF tdiffTHDCF {
	erase `var'_normal.gph
	erase `var'_homosked.gph
}

*/

***Deriving Beta coefficients (clustering option removed)***

***Warmth exposure***
set cformat %9.2f

foreach var in tdiffcdi tdiffmasc tdifftotadd tdiffCDtotcrit tdiffPH tdiffINTCF tdiffEXTCF tdiffTHDCF {
	regress `var' tdiffwarm10 , beta
	regress `var' tdiffwarm10 tdiffemo5 tdiffext5 , beta
	regress `var' tdiffwarm10 tdiffemo5 tdiffext5 tdiffbwgr5 , beta
}

***Dissatisfaction/negativity exposure***

foreach var in tdiffcdi tdiffmasc tdifftotadd tdiffCDtotcrit tdiffPH tdiffINTCF tdiffEXTCF tdiffTHDCF {
	regress `var' tdiffdiss10 , beta
	regress `var' tdiffdiss10 tdiffemo5 tdiffext5 , beta
	regress `var' tdiffdiss10 tdiffemo5 tdiffext5 tdiffbwgr5 , beta
}