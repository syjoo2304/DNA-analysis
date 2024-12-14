# Installation guide for cocoRV using conda.
conda install -c conda-forge r-base=4.0.0 
conda install -c conda-forge r-spatstat
conda install -c conda-forge  r-leaflet
conda install -c conda-forge r-devtools
conda install -c conda-forge r-markdown

# running R to continue the installation.
install.packages('usethis')
install.packages(c("DiscreteFDR", "Rcpp", "RcppArmadillo", "data.table", "nloptr", "igraph", "R.utils", "argparse"))
devtools::install_version('discreteMTP','0.1-2')

# finishing installation process according to the developer's guideline.
Rscript build.R
bash test.sh
pip install pyBigWig
