FROM node:10

RUN git clone https://github.com/eostitan/delphioracle-rng-script /delphioracle-rng-script

ENV EOSIO_PROTOCOL http
ENV EOSIO_HOST nodeos
ENV EOSIO_PORT 8888
ENV EOSIO_CHAIN 83ce967e4a9876d2c050f859e710a58bb06f2d556843391ff28b0c1a95396402
ENV EOSIO_PRIV_KEY 5JUzsJi7rARZy2rT5eHhcdUKTyVPvaksnEKtNWzyiBbifJA1dUW
ENV ORACLE_PERMISSION active
ENV ORACLE_CONTRACT delphioracle
ENV ORACLE_NAME producer2
ENV MINIMUM_CPU_PERCENT 20

RUN cd /delphioracle-rng-script/ && git pull

RUN cd /delphioracle-rng-script/ && npm install -g
