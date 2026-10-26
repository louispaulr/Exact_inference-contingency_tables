# Exact_inference-contingency_tables
This gives an R code for calculating the exact p-value, using the cube algorithm, of the conditional independance test for the contingency table in Section 5.3 of "Null models and exact inference for multi-way contingency tables using the cube method" by Rivest, Talovic and Tille which has been submitted for publication.

This code can used to calculate the exact p-value of a goodness of fit test for any contingency table.  It suffices to replace the first 25 lines of the R-script by the construction of data table followed by the fir of a Poisson regression on that new data table.
