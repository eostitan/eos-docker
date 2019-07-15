#!/bin/bash

echo "Unlocking default wallet"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 wallet open -n default
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 wallet unlock

echo "Create eosio.token user"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 create account eosio eosio.token EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

echo "Create eosio.bios user"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 create account eosio eosio.bios EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

echo "Create eosio.msig user"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 create account eosio eosio.msig EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

echo "Create eosio.bpay user"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 create account eosio eosio.bpay EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

echo "Create eosio.names user"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 create account eosio eosio.names EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

echo "Create eosio.ram user"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 create account eosio eosio.ram EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

echo "Create eosio.ramfee user"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 create account eosio eosio.ramfee EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

echo "Create eosio.saving user"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 create account eosio eosio.saving EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

echo "Create eosio.stake user"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 create account eosio eosio.stake EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

echo "Create eosio.vpay user"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 create account eosio eosio.vpay EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

echo "Create eosio.rex user"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 create account eosio eosio.rex EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

echo "Deploy eosio.token contract"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 set contract eosio.token /eosio.contracts/build/contracts/eosio.token/ eosio.token.wasm eosio.token.abi -p eosio.token@active

echo "Deploy eosio.bios contract"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 set contract eosio.bios /eosio.contracts/build/contracts/eosio.bios/ eosio.bios.wasm eosio.bios.abi -p eosio.bios@active

echo "Deploy eosio.msig contract"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 set contract eosio.msig /eosio.contracts/build/contracts/eosio.msig/ eosio.msig.wasm eosio.msig.abi -p eosio.msig@active

echo "Deploy eosio.system contract"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 set contract eosio /eosio.contracts/build/contracts/eosio.system/ eosio.system.wasm eosio.system.abi -p eosio@active

echo "Creating EOS Token"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 push action eosio.token create '[ "eosio", "1000000000.0000 EOS"]' -p eosio.token@active

echo "Issuing EOS Token to eosio"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 push action eosio.token issue '[ "eosio", "100000.0000 EOS", "m" ]' -p eosio@active

echo "Listing eosio balance"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 get currency balance eosio.token eosio

echo "Init eosio.system Contract"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 push action eosio init '[0, "4,EOS"]' -p eosio@active

echo "Creating testuser account"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 system newaccount eosio testuser EOS7UCtmjUzkS8hUuRdrFoPqyg4U3CK9gQ5rGpuAoaXuVz4rfrian EOS7UCtmjUzkS8hUuRdrFoPqyg4U3CK9gQ5rGpuAoaXuVz4rfrian --stake-net "100.0000 EOS" --stake-cpu "100.0000 EOS" --buy-ram "100.0000 EOS"

echo "Transferring tokens to testuser"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 transfer eosio testuser "10000.0000 EOS"

echo "Listing testuser balance"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 get currency balance eosio.token testuser

echo "Buy RAM for eosio"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 system buyram eosio eosio "100.0000 EOS"

echo "Stake EOS for eosio"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 system delegatebw eosio eosio "100.0000 EOS" "100.0000 EOS"

echo "Register eosio as producer"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 system regproducer eosio EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

echo "Vote eosio as producer"
docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 system voteproducer approve eosio eosio
