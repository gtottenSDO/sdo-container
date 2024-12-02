FROM ghcr.io/ublue-os/fedora-toolbox:latest

LABEL com.github.containers.toolbox="true" \
      usage="This image contains setup for various applications for SDO" \
      summary="SDO setup container" \
      maintainer="greg.totten@state.co.us"

RUN sudo dnf update

RUN sudo dnf copr enable iucar/cran
RUN sudo dnf install R-CoprManager -y
