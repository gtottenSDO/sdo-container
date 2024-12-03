FROM ghcr.io/ublue-os/fedora-toolbox:latest

LABEL com.github.containers.toolbox="true" \
      usage="This image contains setup for various applications for SDO" \
      summary="SDO setup container" \
      maintainer="greg.totten@state.co.us"

RUN sudo dnf copr enable iucar/cran -y && \
      sudo dnf install R R-CoprManager -y && \
      sudo dnf install R-CRAN-tidyverse R-CRAN-languageserver R-CRAN-vroom R-CRAN-httpgd R-CRAN-quarto R-CRAN-duckdb R-CRAN-duckplyr R-CRAN-DBI R-CRAN-odbc -y
     
RUN sudo dnf copr enable iucar/rstudio -y && \
      sudo dnf install rstudio-desktop -y && \
      sudo dnf install rstudio-server -y
