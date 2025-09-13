
cap prog drop represent
prog def represent, eclass
	syntax [anything], group(varname) [BYGroup groupoff TABle DIAGnostics LORenz CLOROpeth(string) ID_cloropeth(string) clusters(varname) absorb(varlist) weight(varname)]
	* Obtain regresison equation
	gettoken subcmd 0 : 0
	gettoken equation 0 : 0, parse(",")
	* Define temporary variables
	if "`weight'"=="" {
		tempvar weights
		qui: gen `weights'=1 
	}
	if "`cluster'"=="" {
		tempvar clusters
		qui: gen `clusters'=_n 
	}
	* Obtain controls 
	tokenize `equation'
	local xvar="`3'"
	local controls= subinstr("`equation'","`1' `2' `3'","",1)
	local equation= subinstr("`equation'","`1'","",1)

	* Temporary residuals
	qui: tempvar x_resid
	qui: tempvar eweights
	if ("`table'"!="") {
		di in red "================================================="
		di in red "Regression results - treatment variable: `xvar'"
		di in red "================================================="
		di ""
		if ("`absorb'"=="") {
			* Residualize treatment 
			reghdfe `equation' [aw=`weights'], noabsorb vce(cluster `clusters')
		}
		else {
			* Residualize treatment 
			reghdfe `equation' [aw=`weights'], absorb(`absorb') vce(cluster `clusters')
		} 	
		di ""
		di ""
	}
	
	
	* Residualizing	
	qui {
		if ("`absorb'"=="") {
			* Residualize treatment 
			quietly reghdfe `xvar' `controls' [aw=`weights'], noabsorb vce(cluster `clusters') resid
			predict `x_resid', resid
		}
		else {
			* Residualize treatment 
			quietly reghdfe `xvar' `controls' [aw=`weights'], absorb(`absorb') vce(cluster `clusters') resid
			predict `x_resid', resid
		} 
		cap drop _reghdfe_resid
	}
	
	* Residuals squared
	qui: gen `eweights'=`x_resid'^2
	
	
	* Output when bygroup is on
	if ("`bygroup'"!="") {	
		di in red "================================================="
		di in red "Analysis over residualized treatment squared."
		di in red "Treatment variable: `xvar'"
		di in red "================================================="
		di ""
		
		* Inequality decomposition
		if ("`diagnostics'"!="") { 
			 ineqdeco `eweights' [aw=`weights'], by(`group') 

		}
		
		* Lorenz curve by group
		if ("`lorenz'"!="") { 
			lorenz estimate `eweights' [iw=`weights'], over(`group')
        		lorenz graph, aspectratio(1) overlay
				graphregion(color(white)) ///
				ytitle("Residuals - dependent variable", size(medlarge)) ///
				xtitle("Residuals - independent variable", size(medlarge))  ///
				legend(off)

		}	
		di ""
		di ""
	}

	
	* Output when group has been defined
	if ("`groupoff'"=="") {
		di in red "================================================="
		di in red "Diagnostics analysis over effective weights."
		di in red "Treatment variable: `xvar'"
		di in red "================================================="
		di ""
		tempfile _bridge 
		qui: save `_bridge'
		collapse (sum) `weights' (mean)`eweights' [aw=`weights'], by(`group')
	
		* Inequality
		if ("`diagnostics'"!="") { 
		 	ineqdeco `eweights' [aw=`weights']
		}
		* Lorenz curve
		if ("`lorenz'"!="") { 
			lorenz estimate `eweights' [iw=`weights']
        		lorenz graph, aspectratio(1) overlay ///
				graphregion(color(white)) legend(off)
 
		}
		* Cloropeth map
		if ("`cloropeth'"!="") { 
			* Weights are zero for those observations that have no weights
			qui: replace `eweights'=0 if `eweights'==.
			
			* Obtain unique group id for merging
			drop _all
			u `_bridge'
			collapse (sum) `weights' (mean)`eweights' [aw=`weights'], by(`group')
			cap decode `group', gen(__idcode)
			cap gen __idcode=`group'
			tempfile _bridge2
			save `_bridge2'
			
			* Obtain unique group id for merging
			import dbase "`cloropeth'.dbf", clear
			cap decode `id_cloropeth', gen(__idcode)
			cap gen __idcode=`id_cloropeth'
			cap duplicates drop __idcode, force
			* Merge
			merge 1:1 __idcode using `_bridge2', keep(match master) nogen replace update
			export dbase "`cloropeth'.dbf", replace

			* Convert shapefile to stata
			tempfile edbase
			tempfile ecoords
			shp2dta using `cloropeth', database(_edbase) ///
				coordinates(_ecoords) replace
			
			* Create map
			drop _all
			use _edbase
			encode __idcode, gen(_id)
			spmap `eweights' using _ecoords, id(_id) fcolor(Blues) ///
			graphregion(color(white)) legend(off)
			
			* Drop temporary files
			cap erase _ecoords
			cap erase _edbase
			
		}
		* Restoring data
		drop _all
		qui: u `_bridge'  
	}
	
	* Since the command is intended for diagnostics, results in memory are not provided
	_return drop _all

end




