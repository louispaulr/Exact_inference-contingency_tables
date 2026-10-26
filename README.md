# Exact_inference-contingency_tables
This site gives, in file RTT_Sect5_3.R, the R code for calculating the exact p-value, using the cube algorithm, of the conditional independance test for the contingency table in Section 5.3 of "Null models and exact inference for multi-way contingency tables using the cube method" by Rivest, Talovic and Tille which has been submitted for publication. The numerical results of Section 5.3 can be reproduced by executing this R-file.

The code, in file RTT_Sect5_3.R, can used to calculate the exact p-value of a goodness of fit test for any contingency table.  It suffices to replace the first 25 lines of the R-script by a script for the construction of data table followed by a script for the fit of a Poisson regression to the new data table.
