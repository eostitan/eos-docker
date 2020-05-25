#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

CONTAINER="worbli-main"
WALLETNAME="development"
DATADIR="data"

if [ `docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 wallet list |grep $WALLETNAME|wc -l` -lt 1 ]
then
  echo "WORBLI: Create development wallet"
  docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 wallet create -n $WALLETNAME -f /worbli-data/walletpw.txt

  echo "WORBLI: Unlock development wallet"
  docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 wallet open -n $WALLETNAME
  docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 wallet unlock -n $WALLETNAME --password $(cat ${DIR}/../$DATADIR/walletpw.txt)

  echo "WORBLI: Import development keys to wallet"
  docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 wallet import -n $WALLETNAME --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3
  docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 wallet import -n $WALLETNAME --private-key 5JUzsJi7rARZy2rT5eHhcdUKTyVPvaksnEKtNWzyiBbifJA1dUW
else
  echo "WORBLI: Unlock development wallet"
  docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 wallet open -n $WALLETNAME
  docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 wallet unlock -n $WALLETNAME --password $(cat ${DIR}/../$DATADIR/walletpw.txt)
fi

# Create WORBLI system accounts
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 create account eosio eosio.ppay EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 create account eosio eosio.msig EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 create account eosio eosio.saving EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 create account eosio eosio.stake EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 create account eosio eosio.token EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 create account eosio eosio.usage EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 create account eosio eosio.sudo EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 create account eosio eosio.rex EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 create account eosio worbli.admin EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

docker exec -it $CONTAINER curl -X POST http://127.0.0.1:8888/v1/producer/schedule_protocol_feature_activations -d '{"protocol_features_to_activate": ["0ec7e080177b2c02b278d5088611686b49d739925a92d9bfcacd7fc6b74053bd"]}' | jq

# set system contracts
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 set contract eosio /root/contracts/eosio.contracts/build/contracts/eosio.system/ eosio.system.wasm eosio.system.abi -p eosio@active
# set token contracts
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 set contract eosio.token /root/contracts/eosio.contracts/build/contracts/eosio.token/ eosio.token.wasm eosio.token.abi -p eosio.token@active
# set the msig contracts
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 set contract eosio.msig /root/contracts/eosio.contracts/build/contracts/eosio.msig/ eosio.msig.wasm eosio.msig.abi -p eosio.msig@active

# Initialize testnet chain
echo "WORBLI: Creating WBI Token"
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio.token create '[ "eosio", "25000000000.0000 WBI"]' -p eosio.token@active

echo "WORBLI: Issuing WBI Token to eosio"
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio.token issue '[ "eosio", "1704465939.3675 WBI", "m" ]' -p eosio@active

echo "WORBLI: Listing eosio balance"
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 get currency balance eosio.token eosio

echo "WORBLI: Transfer balance to wobli.admin"
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 transfer eosio worbli.admin "1704465939.3675 WBI" ""

# set the sudo contracts
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 set contract eosio.sudo /root/contracts/eosio.contracts/build/contracts/eosio.wrap/ eosio.wrap.wasm eosio.wrap.abi -p eosio.sudo@active

# push action setpriv - msig,sudo
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio setpriv '[ "eosio.msig", "1"]' -p eosio@active
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio setpriv '[ "eosio.sudo", "1"]' -p eosio@active

echo "WORBLI: Init eosio.system Contract"
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio init '[0, "4,WBI"]' -p eosio@active

echo "WORBLI: Creating producer accounts"
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system newaccount worbli.admin producer1 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "100.0000 WBI" --stake-cpu "100.0000 WBI" --buy-ram-kbytes 4
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system newaccount worbli.admin producer2 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "3.0000 WBI" --stake-cpu "20.0000 WBI" --buy-ram-kbytes 4
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system newaccount worbli.admin producer3 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "1.0000 WBI" --stake-cpu "1.0000 WBI" --buy-ram-kbytes 4
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system newaccount worbli.admin producer4 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "1.0000 WBI" --stake-cpu "1.0000 WBI" --buy-ram-kbytes 4
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system newaccount worbli.admin producer5 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "1.0000 WBI" --stake-cpu "1.0000 WBI" --buy-ram-kbytes 4
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system newaccount worbli.admin producer11 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "1.0000 WBI" --stake-cpu "1.0000 WBI" --buy-ram-kbytes 4
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system newaccount worbli.admin producer12 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "1.0000 WBI" --stake-cpu "1.0000 WBI" --buy-ram-kbytes 4
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system newaccount worbli.admin producer13 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "1.0000 WBI" --stake-cpu "1.0000 WBI" --buy-ram-kbytes 4
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system newaccount worbli.admin producer14 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "1.0000 WBI" --stake-cpu "1.0000 WBI" --buy-ram-kbytes 4
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system newaccount worbli.admin producer15 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "1.0000 WBI" --stake-cpu "1.0000 WBI" --buy-ram-kbytes 4
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system newaccount worbli.admin producer21 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "1.0000 WBI" --stake-cpu "1.0000 WBI" --buy-ram-kbytes 4
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system newaccount worbli.admin producer22 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "1.0000 WBI" --stake-cpu "1.0000 WBI" --buy-ram-kbytes 4
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system newaccount worbli.admin producer23 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "1.0000 WBI" --stake-cpu "1.0000 WBI" --buy-ram-kbytes 4
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system newaccount worbli.admin producer24 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "1.0000 WBI" --stake-cpu "1.0000 WBI" --buy-ram-kbytes 4
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system newaccount worbli.admin producer25 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "1.0000 WBI" --stake-cpu "1.0000 WBI" --buy-ram-kbytes 4
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system newaccount worbli.admin producer31 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "1.0000 WBI" --stake-cpu "1.0000 WBI" --buy-ram-kbytes 4
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system newaccount worbli.admin producer32 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "1.0000 WBI" --stake-cpu "1.0000 WBI" --buy-ram-kbytes 4
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system newaccount worbli.admin producer33 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "1.0000 WBI" --stake-cpu "1.0000 WBI" --buy-ram-kbytes 4
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system newaccount worbli.admin producer34 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "1.0000 WBI" --stake-cpu "1.0000 WBI" --buy-ram-kbytes 4
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system newaccount worbli.admin producer35 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "1.0000 WBI" --stake-cpu "1.0000 WBI" --buy-ram-kbytes 4
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system newaccount worbli.admin producer41 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "1.0000 WBI" --stake-cpu "1.0000 WBI" --buy-ram-kbytes 4
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system newaccount worbli.admin producer42 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "1.0000 WBI" --stake-cpu "1.0000 WBI" --buy-ram-kbytes 4
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system newaccount worbli.admin producer43 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "1.0000 WBI" --stake-cpu "1.0000 WBI" --buy-ram-kbytes 4
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system newaccount worbli.admin producer44 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "1.0000 WBI" --stake-cpu "1.0000 WBI" --buy-ram-kbytes 4
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system newaccount worbli.admin producer45 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "1.0000 WBI" --stake-cpu "1.0000 WBI" --buy-ram-kbytes 4
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system newaccount worbli.admin producer51 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "1.0000 WBI" --stake-cpu "1.0000 WBI" --buy-ram-kbytes 4

echo "WORBLI: Adding producer accounts"
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio addprod '["producer1"]' -p worbli.admin
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio addprod '["producer2"]' -p worbli.admin
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio addprod '["producer3"]' -p worbli.admin
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio addprod '["producer4"]' -p worbli.admin
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio addprod '["producer5"]' -p worbli.admin
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio addprod '["producer11"]' -p worbli.admin
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio addprod '["producer12"]' -p worbli.admin
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio addprod '["producer13"]' -p worbli.admin
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio addprod '["producer14"]' -p worbli.admin
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio addprod '["producer15"]' -p worbli.admin
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio addprod '["producer21"]' -p worbli.admin
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio addprod '["producer22"]' -p worbli.admin
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio addprod '["producer23"]' -p worbli.admin
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio addprod '["producer24"]' -p worbli.admin
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio addprod '["producer25"]' -p worbli.admin

echo "WORBLI: Promoting producer accounts"
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio promoteprod '["producer1"]' -p worbli.admin
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio promoteprod '["producer2"]' -p worbli.admin
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio promoteprod '["producer3"]' -p worbli.admin
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio promoteprod '["producer4"]' -p worbli.admin
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio promoteprod '["producer5"]' -p worbli.admin
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio promoteprod '["producer11"]' -p worbli.admin
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio promoteprod '["producer12"]' -p worbli.admin
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio promoteprod '["producer13"]' -p worbli.admin
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio promoteprod '["producer14"]' -p worbli.admin
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio promoteprod '["producer15"]' -p worbli.admin
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio promoteprod '["producer21"]' -p worbli.admin
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio promoteprod '["producer22"]' -p worbli.admin
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio promoteprod '["producer23"]' -p worbli.admin
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio promoteprod '["producer24"]' -p worbli.admin
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio promoteprod '["producer25"]' -p worbli.admin

echo "WORBLI: Registering producer accounts"
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system regproducer producer1 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy "http://prod1.io"
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system regproducer producer2 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy "http://prod2.io"
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system regproducer producer3 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy "http://prod3.io"
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system regproducer producer4 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy "http://prod4.io"
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 system regproducer producer5 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy "http://prod5.io"
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio togglesched '["1"]' -p eosio

echo "WORBLI: Activate EOSIO features"
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio activate '["f0af56d2c5a48d60a4a5b5c903edfb7db3a736a94ed589d0b797df33ff9d3e1d"]' -p eosio # GET_SENDER
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio activate '["2652f5f96006294109b3dd0bbde63693f55324af452b799ee137a81a905eed25"]' -p eosio # FORWARD_SETCODE
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio activate '["8ba52fe7a3956c5cd3a656a3174b931d3bb2abb45578befc59f283ecd816a405"]' -p eosio # ONLY_BILL_FIRST_AUTHORIZER
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio activate '["ad9e3d8f650687709fd68f4b90b41f7d825a365b02c23a636cef88ac2ac00c43"]' -p eosio # RESTRICT_ACTION_TO_SELF
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio activate '["68dcaa34c0517d19666e6b33add67351d8c5f69e999ca1e37931bc410a297428"]' -p eosio # DISALLOW_EMPTY_PRODUCER_SCHEDULE
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio activate '["e0fb64b1085cc5538970158d05a009c24e276fb94e1a0bf6a528b48fbc4ff526"]' -p eosio # FIX_LINKAUTH_RESTRICTION
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio activate '["ef43112c6543b88db2283a2e077278c315ae2c84719a8b25f25cc88565fbea99"]' -p eosio # REPLACE_DEFERRED
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio activate '["4a90c00d55454dc5b059055ca213579c6ea856967712a56017487886a4d4cc0f"]' -p eosio # NO_DUPLICATE_DEFERRED_ID
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio activate '["1a99a59d87e06e09ec5b028a9cbb7749b4a5ad8819004365d02dc4379a8b7241"]' -p eosio # ONLY_LINK_TO_EXISTING_PERMISSION
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://worbli-wallet:8901 push action eosio activate '["4e7bf348da00a945489b2a681749eb56f5de00b900014e137ddae39f48f69d67"]' -p eosio # RAM_RESTRICTIONS
