#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

CONTAINER="ux-main"
WALLETNAME="development"
DATADIR="data"

echo $CONTAINER

if [ `docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 wallet list |grep $WALLETNAME|wc -l` -lt 1 ]
then
  echo "Create development wallet"
  docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 wallet create -n $WALLETNAME -f /ux-data/walletpw.txt

  echo "Unlock development wallet"
  docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 wallet open -n $WALLETNAME
  docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 wallet unlock -n $WALLETNAME --password $(cat ${DIR}/../$DATADIR/walletpw.txt)

  echo "Import development keys to wallet"
  docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 wallet import -n $WALLETNAME --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3
  docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 wallet import -n $WALLETNAME --private-key 5JUzsJi7rARZy2rT5eHhcdUKTyVPvaksnEKtNWzyiBbifJA1dUW
else
  echo "Unlock development wallet"
  docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 wallet open -n $WALLETNAME
  docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 wallet unlock -n $WALLETNAME --password $(cat ${DIR}/../$DATADIR/walletpw.txt)
fi

########### Create blockchain accounts
echo "Create eosio.token user"
docker exec -it ux-main cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 create account eosio eosio.token EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

echo "Create eosio.msig user"
docker exec -it ux-main cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 create account eosio eosio.msig EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

echo "Create eosio.bpay user"
docker exec -it ux-main cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 create account eosio eosio.bpay EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

echo "Create eosio.names user"
docker exec -it ux-main cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 create account eosio eosio.names EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

echo "Create eosio.ram user"
docker exec -it ux-main cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 create account eosio eosio.ram EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

echo "Create eosio.ramfee user"
docker exec -it ux-main cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 create account eosio eosio.ramfee EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

echo "Create eosio.saving user"
docker exec -it ux-main cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 create account eosio eosio.saving EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

echo "Create eosio.stake user"
docker exec -it ux-main cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 create account eosio eosio.stake EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

echo "Create eosio.vpay user"
docker exec -it ux-main cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 create account eosio eosio.vpay EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

echo "Create eosio.rex user"
docker exec -it ux-main cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 create account eosio eosio.rex EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

# bash $DIR/uxprotocol-deploy.sh clone build deploy
bash $DIR/uxprotocol-deploy.sh deploy

########### Initialize testnet chain
# echo "Creating UTX Token"
# docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action eosio.token create '[ "eosio", "200000000.0000 UTX"]' -p eosio.token@active

# echo "Issuing UTX Token to eosio"
# docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action eosio.token issue '[ "eosio", "190000000.0000 UTX", "m" ]' -p eosio@active

# echo "Listing eosio balance"
# docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 get currency balance eosio.token eosio

# echo "Init eosio.system Contract"
# docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action eosio init '[0, "4,UTX"]' -p eosio@active

# echo "Creating testuser account"
# docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 system newaccount eosio testuser EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "100.0000 UTX" --stake-cpu "100.0000 UTX" --buy-ram "100.0000 UTX"

# echo "Issuing UTX Token to eosio"
# docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action eosio.token issue '[ "eosio", "10000000.0000 UTX", "m" ]' -p eosio@active

# echo "Listing eosio balance"
# docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 get currency balance eosio.token eosio

# echo "Buy RAM for eosio"
# docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 system buyram eosio eosio "100.0000 UTX"

# echo "Stake UTX for eosio" # We must stake enough of the EOS token to initialize the network
# docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 system delegatebw eosio eosio "90000000.0000 UTX" "90000000.0000 UTX"

########### Setup contact accounts

# echo "Create vpow.token user"
# docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 system newaccount eosio vpow.token EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "100.0000 UTX" --stake-cpu "100.0000 UTX" --buy-ram "100.0000 UTX"

# echo "Create ux.exchange user"
# docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 system newaccount eosio ux.exchange EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "100.0000 UTX" --stake-cpu "100.0000 UTX" --buy-ram "100.0000 UTX"

# echo "Create ict user"
# docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 system newaccount eosio ict EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "100.0000 UTX" --stake-cpu "100.0000 UTX" --buy-ram "100.0000 UTX"

# echo "Set vpow.token eosio.code permission"
# docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 set account permission vpow.token active --add-code

# echo "Set ux.exchange eosio.code permission"
# docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 set account permission ux.exchange active --add-code

# echo "Set ict eosio.code permission"
# docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 set account permission ict active --add-code

########### Setup extra producers

# echo "Creating producer1 account"
# docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 system newaccount eosio producer1 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "100.0000 UTX" --stake-cpu "100.0000 UTX" --buy-ram "100.0000 UTX"

# echo "Give producer1 a balance"
# docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 transfer eosio producer1 "1000.0000 UTX" ""

# echo "Register producer1 as producer"
# docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 system regproducer producer1 EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

# echo "Vote producer1 as producer"
# docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 system voteproducer approve eosio producer1

# echo "Creating producer2 account"
# docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 system newaccount eosio producer2 EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "100.0000 UTX" --stake-cpu "100.0000 UTX" --buy-ram "100.0000 UTX"

# echo "Give producer2 a balance"
# docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 transfer eosio producer2 "1000.0000 UTX" ""

# echo "Register producer2 as producer"
# docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 system regproducer producer2 EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

# echo "Vote producer2 as producer"
# docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 system voteproducer approve eosio producer2

# echo "Creating UTX Token"
# docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action vpow.token create '{"issuer":"satoshighost","maximum_supply":"21000000.0000 UTX"}' -p vpow.token@active
