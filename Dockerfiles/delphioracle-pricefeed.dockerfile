FROM node:10

RUN git clone https://github.com/eostitan/delphioracle /delphioracle
RUN cd /delphioracle && git checkout updatestats

ENV EOS_PROTOCOL http
ENV EOS_HOST nodeos
ENV EOS_PORT 8888
ENV EOS_CHAIN 83ce967e4a9876d2c050f859e710a58bb06f2d556843391ff28b0c1a95396402
ENV EOS_KEY 5JUzsJi7rARZy2rT5eHhcdUKTyVPvaksnEKtNWzyiBbifJA1dUW
ENV CONTRACT delphioracle
ENV ORACLE producer2
ENV ORACLE_PERMISSION active
ENV FREQ 15000

RUN cd /delphioracle && git pull

RUN cd /delphioracle/scripts/ && npm install -g
