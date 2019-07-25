FROM ubuntu:18.04

RUN apt-get update && apt-get install -y curl libicu60 libusb-1.0-0 libcurl3-gnutls git cmake g++

RUN curl -LO https://github.com/EOSIO/eos/releases/download/v1.7.0/eosio_1.7.0-1-ubuntu-18.04_amd64.deb \
    && dpkg -i eosio_1.7.0-1-ubuntu-18.04_amd64.deb

RUN curl -LO https://github.com/EOSIO/eosio.cdt/releases/download/v1.6.1/eosio.cdt_1.6.1-1_amd64.deb \
    && dpkg -i eosio.cdt_1.6.1-1_amd64.deb

RUN curl -LO https://github.com/EOSIO/eosio.cdt/archive/v1.6.1.tar.gz && tar -xvzf v1.6.1.tar.gz --one-top-level=eosio.cdt --strip-components 1

RUN git clone https://github.com/eosio/eosio.contracts /eosio.contracts

RUN cd /eosio.contracts/ && git checkout v1.7 && mkdir build && cd build && cmake .. && make contracts_project --debug=j
