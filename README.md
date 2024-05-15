# A-highly-comparative-approach-to-the-analysis-of-resting-state-fMRI-functional-connectivity
This GitHub repository contains the scripts used during Jose Maria Casanova Master's Thesis project.

Author: Jose Maria Casanova Blázquez (jose.casanova@estudiante.uam.es)
Director: Fabiano Baroni (fabiano.baroni@uam.es)
#
Data were provided by the Human Connectome Project, WU-Minn Consortium (Principal Investigators: David Van Essen and Kamil Ugurbil; 1U54MH091657) funded by the 16 NIH Institutes and Centers that support the NIH Blueprint for Neuroscience Research;and by the McDonnell Center for Systems Neuroscience at Washington University.
#
# Scripts
-script_distribute_xFC_erg.m :creates every possible combination of measure, then it calls multi_range_qsub in order to create the .m files and the jobs that will be launched with the cluster.
-script_distribute_xFC_missing_subjects.m : creates every possible combination of measure, then it calls multi_range_qsub in order to create the .m files and the jobs that will be launched with the cluster but just the missing subjects.

The scripts were provided by Fabiano Baroni and edited and launched by Jose Maria Casanova.
