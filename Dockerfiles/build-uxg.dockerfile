FROM ubuntu:18.04

RUN apt-get update && apt-get install -y curl libicu60 libusb-1.0-0 libcurl3-gnutls git cmake g++ nodejs npm nano

# Download and unpackage EOSIO.CDT 1.6.3
RUN curl -o /eosio.cdt/eosio.cdt_1.6.3-1-ubuntu-18.04_amd64.deb --create-dirs -L https://github.com/EOSIO/eosio.cdt/releases/download/v1.6.3/eosio.cdt_1.6.3-1-ubuntu-18.04_amd64.deb \
    && dpkg-deb -x /eosio.cdt/eosio.cdt_1.6.3-1-ubuntu-18.04_amd64.deb /eosio.cdt/v1.6.3

# Download and unpackage EOSIO.CDT 1.7.0
 RUN curl -o /eosio.cdt/eosio.cdt_1.7.0-1-ubuntu-18.04_amd64.deb --create-dirs -L https://github.com/EOSIO/eosio.cdt/releases/download/v1.7.0/eosio.cdt_1.7.0-1-ubuntu-18.04_amd64.deb \
    && dpkg-deb -x /eosio.cdt/eosio.cdt_1.7.0-1-ubuntu-18.04_amd64.deb /eosio.cdt/v1.7.0

# Activate EOSIO.CDT 1.6.3
RUN cp -rf /eosio.cdt/v1.6.3/usr/* /usr/

# Download EOSIO.Contracts
RUN curl -LO https://github.com/EOSIO/eosio.contracts/archive/v1.8.3.tar.gz && tar -xzvf v1.8.3.tar.gz --one-top-level=eosio.contracts --strip-components 1

COPY /eosiofiles/eosio.system.hpp /eosio.contracts/contracts/eosio.system/include/eosio.system/eosio.system.hpp

# Build eosio.contracts
RUN cd /eosio.contracts/ && mkdir build && cd build && cmake .. && make all

# Activate EOSIO.CDT 1.7.0
RUN cp -rf /eosio.cdt/v1.7.0/usr/* /usr/

COPY /eosiofiles/nodeos /usr/bin/nodeos
COPY /eosiofiles/cleos /usr/bin/cleos
COPY /eosiofiles/eosio-blocklog /usr/bin/eosio-blocklog
COPY /eosiofiles/keosd /usr/bin/keosd
COPY /eosiofiles/trace_api_util /usr/bin/trace_api_util
