{smcl}
{* *! version 1.0 30JUN2023}{...}
{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{cmd:represent} {hline 2}}Analysis of effective regression weights.  {p_end}
{p2colreset}{...}

{marker syntax}{...}
{title:Syntax}

{p 8 15 2} {cmd:represent:}
{cmd: {ul:reg}ress} {depvar} {indepvars} {cmd:,} group(varname) [{opt TABle} {opth weights(varname)} {opth absorb(varlist)}  {opth cluster(varname)} {opt LORenz} {opt DIAGnostics} {opt BYGroup} {opt CLOROpeth(string)} {opt ID_cloropeth(string)}] {p_end}

{marker opt_summary}{...}
{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt group(varname)}} group variable for performing diagnostics and performing distributional analysis of effective regression weights. In Aronow and Samii (2016) this variable is the country. {p_end}
	
{syntab:Optional}
{synopt :{opt TABle}} displays the results from the specified regression.{p_end}
{synopt :{opt weights(varname)}} runs the regression using the specified analytic weights, and computes diagnostics and distributional statistics using these weights.{p_end}
{synopt :{opt absorb(varlist)}} categorical variables that identify the fixed effects to be absorbed. This option implements {browse "https://github.com/sergiocorreia/reghdfe": reghdfe}.{p_end} 
{synopt :{opt cluster(varname)}} clusters to compute cluster-robust standard errors in the specified regressions.{p_end}
{synopt :{opt LORenz}} computes and plots Lorenz curves. {p_end}
{synopt :{opt DIAGnostics}} computes distributional statistics for the effective regression weights. {p_end}
{synopt :{opt BYGroup}} performs an analysis of the distributional statistics of the effective regression weights using the variable in {opth group(varname)}.{p_end}
{synopt :{opt CLOROpeth}} path to and name of the shapefile to create a cloropeth map for the effective regression weights. {p_end}
{synopt :{opt ID_cloropeth}} variable name that identifies a unique observation the shape file. (This variable needs to be provided if a shapefile is provided.) {p_end}

{marker description}{...}
{title:Description}

{pstd}
{cmd:represent} uses the methodology developed in {browse "https://onlinelibrary.wiley.com/doi/abs/10.1111/ajps.12185":Aronow and Samii (2016)} to compute effective regression weights. With conventional estimation practices for observational studies the estimate of a causal effect of a treatment may fail to characterize how effects operate in the population of interest. Causal effects estimated via multiple regression differentially weight each unit's contribution. The "effective sample" that regression uses to generate the estimate may bear little resemblance to the population of interest, and the results may be non-representative in a manner similar to what quasi-experimental methods or experiments with convenience samples produce. This program estimates the ``multiple regression weights'', and provides diagnostics using distributional statistics, Lorenz curves, and cloropeth maps. These diagnostics allow one to study the effective sample, and help to determine if a group of observations (for example a country) , is driving the effect of the treatment. The first independent variable input into the code is assumed to be the treatment. {p_end}

{hline}
{marker examples}{...}
{title:Example}

{pstd}A full example is available in the {browse "https://github.com/cfbalcazar/represent/tree/main/represent": github repository}: {p_end}

{pstd} Example for using diagnostics on the covariate gender: {p_end}

{phang2}{cmd: represent: reg y D gender, group(gender) absorb(municipality) diagnostics}{p_end}

{pstd} Example for using Lorenz curves on the covariate affiliation: {p_end}

{phang2}{cmd: represent: reg y D gender affiliation, group(affiliation) absorb(municipality) Lorenz}{p_end}

{pstd} Example for  using cloropeth map on the covariate municipality: {p_end}

{phang2}{cmd: represent: reg y D gender affiliation, group(municipality) absorb(municipality) cloro("gadm_shapefile") id("NAME_1")}{p_end}


{hline}

{marker contact}{...}
{title:Author}

{pstd}Felipe Balcazar{break}
New York University, Wilf Department of Politics.{break}
Email: {browse "mailto:cfbalcazar@nyu.edu ":cfbalcazar@nyu.edu } {break}
{p_end}


{marker updates}{...}
{title:Updates}

{phang2}For updating the package please use: {p_end}

{phang2}{cmd: net install represent, from (https://raw.githubusercontent.com/cfbalcazar/represent/main/represent/) replace force all}

{marker references}{...}
{title:References}

{p 0 0 2}
{phang}
Aronow, Peter M. And Cyrus Samii. 
"Does Regression Produce Representative Estimates of Causal Effects?." 
{it:American Journal of Political Science 60 (1):250-267.}
{browse "https://onlinelibrary.wiley.com/doi/abs/10.1111/ajps.12185":[link]}{browse "https://onlinelibrary.wiley.com/doi/10.1111/ajps.12292":[erratum]}

