* Purpose: produces a "table 0" for appendix, describing sample selection
* Users: Students studying with Yaohui Zhao
* Quan Zhang, quan_zhang@pku.edu.cn


* version history
* 2011-03-29	v1.3	Added output written
* 2011-03-28	v1.2	Added if
*                       Added by(groupvar)			
* 2023-03-27	v1.1	Initial version


program table0
	version 16
	syntax [if] [in],              /// optional if condition
	       [BY(string)]           /// optional by group variable
		   CONDITIONS(string)     /// sample selection conditions, seperated with comma
		   SAVE(string)           /// save Table 0
		   [clear]
		   
		   
		   
	/***************************creat the table and title***********************/
	quietly putexcel set "`save'", sheet("sheet1") replace //creat a resutls table 
	
	if "`by'"!="" {	
		putexcel A1=("Table 0. Sample Selection by `by' `if' ") //title
	}
	else {
		putexcel A1=("Table 0. Sample Selection `if' ")  //title
	}

	
	
	/****************************how many restrictions**************************/
	local num = length("`conditions'") - length(subinstr("`conditions'",",","",.)) + 1
	
	
	
	/**************************first: sample for all***************************/
	preserve
	//if option 
	if "`if'"!="" quietly keep `if' //using the if option
	
	
	//for all respondents without considering the by group
	quietly putexcel B2=("ALL") B3=("Deleted") C3=("Remain")
	quietly count
	quietly scalar remobs = r(N) 
	quietly putexcel A4=("Original") C4=(remobs)

	/*loop through the input conditions and execute the commands*/
	tokenize "`conditions'",parse(",")

	local count = 4 //filling the conditions and observation changes, the first four rows are taken
	foreach i of numlist 1/`num' {
		local j = 2*`i' - 1 //loop over tokens without comma
		/**execute the command and record the results**/
		quietly ``j'' //restriction
		quietly scalar delobs = r(N_drop)  //number dropped
		quietly count //describe
		quietly scalar remobs = r(N) //number remained
		/**extract the results and output to an Excel file**/
		local count = `count' + 1
		quietly putexcel A`count' = ("``j''") B`count' = (delobs) C`count' = (remobs) //record in excel
	}
    restore
	
	
	
	/**************second: sample for subgroup when there is********************/
	if "`by'"!="" {	
		local cols "D E F G H I J K L M N O P Q R S T U V W X Y Z" //column for differnt group
		local column_index 1
		quietly levelsof `by', local(levels)  //how many unique value of the by variable
		
		foreach value of local levels {
			preserve
	        //if and by option  to keep sample
			if "`if'"!="" quietly keep `if' //using the if option
			quietly keep if `by' == `value' //restrict to the subsample of by option

			
			//locate column by groupvar
			local col: word `column_index' of `cols' //get which column to put deleted
			local column_index_1 = `column_index' + 1
			local col_1: word `column_index_1' of `cols' //get which column to put remained

			quietly putexcel `col'2=("`by' = `value'") `col'3=("Deleted") `col_1'3=("Remain") //label
			quietly count
			quietly scalar remobs = r(N) 
			quietly putexcel `col_1'4=(remobs) //original respondent by group
		
			/*loop through the input conditions and execute the commands*/
			tokenize "`conditions'",parse(",")
			
			local count = 4
			foreach i of numlist 1/`num' {
				local j = 2*`i' - 1
				/**execute the command and record the results**/
				 quietly ``j'' 
				 quietly scalar delobs = r(N_drop) 
				 quietly count 
				 quietly scalar remobs = r(N)
				/**extract the results and output to an Excel file**/
				local count = `count' + 1
				quietly putexcel `col'`count' = (delobs) `col_1'`count' = (remobs)
			}
			local column_index = `column_index' + 2
			restore
		}
		putexcel close
	}
	
	
	
	/**************second: sample for subgroup when there is no*****************/
	else {
		putexcel close
	}
	
	//open excel
	di as txt `"(output written to {browse "`save'"})"'
	
	`clear'

end
