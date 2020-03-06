FROM node:10

RUN git clone https://github.com/eostitan/delphioracle /delphioracle
RUN cd /delphioracle && git pull && cd /delphioracle/scripts/ && npm install -g

RUN git clone https://github.com/eostitan/delphioracle-rng-script /delphioracle-rng-script
RUN cd /delphioracle-rng-script/ && git pull && npm install -g
