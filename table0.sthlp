{smcl}
{* *! version 1.3  28april2023}{...}
{hline}
help for {cmd:table0}{right:Version 1.3, 10 April 2023}
{hline}

{title:Title}

{p2colset 5 14 21 2}{...}
{p2col: {bf:table0}}{hline 2} Create "table 0" of sample selection for a manuscript without any actual changes in the datasets

{title:Syntax}

{p 8 18 2}
{opt table0} {ifin}, {opt conditions(cond)} {opt save(filename)} [{it:options}]

{phang}{it:cond} = [... , {it:command} , ...]

{phang}Supported commands in {bf:conditions} option:{p_end}
{tab}drop  - drop a subsample
{tab}keep  - keep a subsample
{tab}other - commands that could select a sample
{tab}notes - selection on string variable not allowed

{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Group options}
{synopt:{opt by(varname)}}group observations by numerical {it:varname}{p_end}

{syntab:Output options}
{synopt:{opt save(filename)}}save table to Excel file, supporting csv and xlsx format but xlsx format prefered{p_end}
{synopt:{opt clear}}replace the dataset in memory with the table{p_end}


{title:Description}

{pstd}
{opt table0} generates a "table 0" of sample selection for a manuscript. Such a table generally 
includes a series of commands that are used to select a sample, the observation dropped 
following each command, and the observation remained.{p_end}

{pstd}The {bf:conditions} option is required and and contains a list of the commands.{p_end}

{pstd}The list of commands in the {bf:conditions} option is delimited using a comma(,).{p_end}

{pstd}The resulting table may be saved to an Excel file using the {bf:save()} option.{p_end}


{title:Example}

{phang}{cmd:. sysuse auto, clear}{p_end}
{phang}{cmd:. table0, conditions(drop if price == ., keep if weight != .) save(table0_auto.xlsx)}{p_end}
{phang}{cmd:. table0, conditions(drop if price == ., keep if weight != .) by(foreign) save(table0_auto.xlsx)}{p_end}
{phang}{cmd:. table0 if foreign == 1, conditions(drop if price == ., keep if weight != .) save(table0_auto.xlsx)}{p_end}


{title:Author}

{p 4 4 2}
Quan Zhang, National School of Development, Peking University, quan_zhang@pku.edu.cn

