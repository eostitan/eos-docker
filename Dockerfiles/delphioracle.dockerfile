FROM node:10

RUN git clone https://github.com/eostitan/delphioracle /delphioracle
RUN git clone https://github.com/eostitan/delphioracle-rng-script /delphioracle-rng-script

ENV EOS_PROTOCOL http
ENV EOS_HOST nodeos
ENV EOS_PORT 8888
ENV EOS_CHAIN 83ce967e4a9876d2c050f859e710a58bb06f2d556843391ff28b0c1a95396402
ENV EOS_KEY 5JUzsJi7rARZy2rT5eHhcdUKTyVPvaksnEKtNWzyiBbifJA1dUW
ENV EOSIO_PRIV_KEY 5JUzsJi7rARZy2rT5eHhcdUKTyVPvaksnEKtNWzyiBbifJA1dUW
ENV CONTRACT delphioracle
ENV ORACLE producer2
ENV ORACLE_PERMISSION active
ENV FREQ 15000

ENV ORACLE_CONTRACT delphioracle
ENV ORACLE_NAME producer2
ENV MINIMUM_CPU_PERCENT 20

RUN cd /delphioracle && git pull && cd /delphioracle/scripts/ && npm install -g

RUN cd /delphioracle-rng-script/ && git pull && npm install -g
