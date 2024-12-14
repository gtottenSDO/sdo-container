FROM registry.fedoraproject.org/fedora-toolbox:41 AS fedora-toolbox

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="A cloud-native terminal experience powered by Fedora, this is based off the fedora-toolbox containerfile by Universal Blue https://github.com/ublue-os/toolboxes" 

RUN dnf -y upgrade

# Set up dependencies
RUN git clone https://github.com/89luca89/distrobox.git --single-branch /tmp/distrobox && \
    cp /tmp/distrobox/distrobox-host-exec /usr/bin/distrobox-host-exec && \
    wget https://github.com/1player/host-spawn/releases/download/$(cat /tmp/distrobox/distrobox-host-exec | grep host_spawn_version= | cut -d "\"" -f 2)/host-spawn-$(uname -m) -O /usr/bin/host-spawn && \
    chmod +x /usr/bin/host-spawn && \
    rm -drf /tmp/distrobox && \
    dnf install -y 'dnf-command(copr)' && \
    dnf clean all

# Enable R coprmanager and install R
RUN sudo dnf copr enable iucar/cran -y && \
      sudo dnf install R R-CoprManager -y && \
      sudo dnf install R-CRAN-tidyverse R-CRAN-languageserver R-CRAN-vroom R-CRAN-httpgd R-CRAN-quarto R-CRAN-duckdb R-CRAN-duckplyr R-CRAN-DBI R-CRAN-odbc -y && \
    dnf clean all

# Enable rstudio copr and install both rstudio desktop and rstudio server
RUN sudo dnf copr enable iucar/rstudio -y && \
      sudo dnf install rstudio-desktop -y && \
      sudo dnf install rstudio-server -y && \
    dnf clean all

# Get latest positron version file and install using dnf
RUN LATEST_RPM=$(curl -L \
      -H "Accept: application/vnd.github+json" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      "https://api.github.com/repos/posit-dev/positron/releases" | \
      grep "browser_download_url.*\.rpm\"" | \
      head -n 1 | \
      cut -d : -f 2,3 | \
      tr -d \") && \
      sudo dnf install -y $LATEST_RPM && \
    dnf clean all

# install dbeaver
RUN sudo dnf install https://dbeaver.io/files/dbeaver-ce-latest-stable.x86_64.rpm -y

# download duckdb and copy to /usr/bin
RUN wget https://github.com/duckdb/duckdb/releases/download/v1.1.3/duckdb_cli-linux-amd64.zip -O /tmp/duckdb/ddb.zip && \
      unzip /tmp/duckdb/ddb.zip && \
      sudo mv duckdb /usr/bin/duckdb && \
      rm -drf /tmp/duckdb

# Cleanup
# RUN rm -rf /tmp/*
