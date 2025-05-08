TAPR_Grazing.Rmd instructions

written by S. Mead 2025
************************************************

1. Make a copy of the entire Grazing_Analysis folder and move it to your desired location to perform analysis (i.e. analysis folder on N drive). This folder is located
N:\HTLN\Program documents\RScripts\grazing\Grazing_Analysis. 

2. Rename your folder with the current year [i.e. Grazing_Analysis2024]

3. Export the following tables from the MultiGrazingStocking1.33 database as csv files and copy them into the "data" subfolder of your newly made folder. (Note: If exporting as a csv from Access Click External Data > Text File to save as a csv and be sure to check the "Include Field Names on First Row" box from the third screen of Export Text Wizard.)
	a. tbl_MultiGrazing.csv
	b. tbl_MultiGrazing_LandManUnit.csv
	c. tlu_LandManagementUnit.csv

4. Save a copy of Grazing_calculations_final_RHCR_corr.csv (corrected pre-2024 data and calculations) in your "data" subfolder. This table was made for pre-2024 data using a mix of R code and excel edits due to caveats in the data. This file is posted on the server here: "N:\HTLN\Projects\Grazing\Data\Archive\Grazing_calculations_final_RHCr_corr.xlsx"

**NOTE** Do not change any file names in your "data" subfolder. If you change a file name, you will have to edit the file name in the R Markdown document in order to load that data in. 

5. Click on Grazing.Rproj to open your R project in R studio. Close any objects that may have already opened. 

6. When RStudio opens, open the most recent version of TAPR_grazing.Rmd from the "files" tab. 

7. Click Ctlr+Alt+R or Naviate to Run>Run All to run the entire Rmarkdown script.

8. If the script runs without errors, the Graphs and Tables in your folder will be populated with your exports

**************************************************