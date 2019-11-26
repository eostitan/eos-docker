#!/bin/bash

echo "Build delphioracle oracle"
docker exec nodeos bash -c "cd /root/contracts/delphioracle && make -p build && cd build && cmake .. && make"

echo "Create delphioracle user"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 system newaccount eosio delphioracle EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "100.0000 EOS" --stake-cpu "100.0000 EOS" --buy-ram "100.0000 EOS"

echo "Add eosio.code permission to delphioracle"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 set account permission delphioracle active --add-code

echo "Deploy delphioracle contract"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 set contract delphioracle /root/contracts/delphioracle/build/delphioracle delphioracle.wasm delphioracle.abi -p delphioracle@active

echo "Listing delphioracle code hash"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 get code delphioracle

echo "Configure delphioracle"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 push action delphioracle configure  "$(cat configure.json)" -p delphioracle
