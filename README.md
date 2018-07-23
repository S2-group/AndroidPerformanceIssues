# AndroidPerformanceIssues
Replication package of the scientific paper titled  "Characterizing the evolution of statically-detectable performance issues of Android apps" submitted to the Empirical Software Engineering journal

It contains all the material required to replicate our analysis, including (i) the raw input data (ii) the data extraction and context selection scripts (iii) the statistical analysis scripts, and (iv) the analysis results in form of data, plots, etc. Some additional analyses and results, not included in the paper due to space limitations, are also provided.


Analysis replication
---------------
The totality of the statistical analysis scripts utilized for the study are available [here]
(https://github.com/S2-group/AndroidPerformanceIssues/tree/master/analysis)
In order to replicate the analysis of the study (i) clone the repository (`git clone https://github.com/S2-group/AndroidPerformanceIssues`) and (ii) execute the analysis scripts in the following order.

1. [RQ0_analysis.R](https://github.com/S2-group/AndroidPerformanceIssues/blob/master/analysis/RQ0_analysis.R) - Perform all analysis and plotting processes related to RQ0 
2. [RQ1_analysis.R](https://github.com/S2-group/AndroidPerformanceIssues/blob/master/analysis/RQ1_analysis.R) - Perform all analysis and plotting processes related to RQ1 
3. [RQ2_analysis.R](https://github.com/S2-group/AndroidPerformanceIssues/blob/master/analysis/RQ2_analysis.R) - Perform all analysis and plotting processes related to RQ2 
4. [RQ3_analysis.R](https://github.com/S2-group/AndroidPerformanceIssues/blob/master/analysis/RQ3_analysis.R) - Perform all analysis and plotting processes related to RQ3
5. [RQ4_analysis.R](https://github.com/S2-group/AndroidPerformanceIssues/blob/master/analysis/RQ4_analysis.R) - Perform all analysis and plotting processes related to RQ4


Results and plots
---------------
The results produced in order to answer our research question are provided [here](https://github.com/S2-group/AndroidPerformanceIssues/tree/master/analysis/results).
The totality of the plots generated during the analysis processes are instead provided [here](https://github.com/S2-group/AndroidPerformanceIssues/tree/master/analysis/plots). This includes also diagrams which, due to space limitations, were not included in the paper.

Directory Structure Overview
---------------
This reposisory is structured as follows:

    ReplicationPackage2018
     .
     |
     |--- analysis/         Input of the algorithms, i.e. fault matrix, coverage information, and BB representation of subjects.
     |      |
     |      |
     |      |--- plots/     Plots generated for the analysis processes. 
     |      |
     |      |--- results/   Raw output data generated from the analysis.
     |
     |
     |--- data/             Raw input data of the analysis processes.
     |
     |--- labelledData/     Evolution categories labelled according to the manual labelling process and Cohen Kappa Values for the level of agreement between these categories.
     
