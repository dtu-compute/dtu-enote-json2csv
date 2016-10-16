FROM fedora:24

RUN dnf -y update && dnf clean all
RUN dnf -y install R
RUN R -e 'install.packages("jsonlite", repos="http://cran.rstudio.com/")'
RUN R -e 'install.packages("lubridate", repos="http://cran.rstudio.com/")'
RUN mkdir /output
COPY json2csv.R /
CMD R < /json2csv.R --no-save

