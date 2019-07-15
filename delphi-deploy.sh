#!/bin/bash

echo "Unlocking default wallet"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 wallet open -n default
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 wallet unlock

echo "Create delphioracle user"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 system newaccount eosio delphioracle EOS7UCtmjUzkS8hUuRdrFoPqyg4U3CK9gQ5rGpuAoaXuVz4rfrian EOS7UCtmjUzkS8hUuRdrFoPqyg4U3CK9gQ5rGpuAoaXuVz4rfrian --stake-net "100.0000 EOS" --stake-cpu "100.0000 EOS" --buy-ram "100.0000 EOS"

echo "Add eosio.code permission to delphioracle"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 set account permission delphioracle active --add-code

echo "Deploy delphioracle contract"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 set contract delphioracle /root/contracts/delphioracle/contract/build delphioracle.wasm delphioracle.abi -p delphioracle@active

echo "Listing delphioracle code hash"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 get code delphioracle
