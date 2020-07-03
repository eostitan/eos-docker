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

echo "Create eosio.bpay user"
docker exec -it ux-main cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 create account eosio eosio.bpay EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

echo "Create eosio.upay user"
docker exec -it ux-main cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 create account eosio eosio.upay EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

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

echo "Create eosio.rex user"
docker exec -it ux-main cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 create account eosio eosio.rex EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

bash $DIR/uxprotocol-deploy.sh clone build deploy

#bash $DIR/uxprotocol-deploy.sh clone
#bash $DIR/uxprotocol-deploy.sh clone build deploy
#bash $DIR/uxprotocol-deploy.sh build deploy
#bash $DIR/uxprotocol-deploy.sh deploy

########### Initialize testnet chain
echo ""
echo "Creating UTX / UTXRAM Tokens"
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action eosio.token create '[ "eosio", "2500000000.0000 UTX"]' -p eosio.token@active
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action eosio.token create '[ "eosio", "8388608.0000 UTXRAM"]' -p eosio.token@active

echo ""
echo "Issuing UTX Token to eosio"
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action eosio.token issue '[ "eosio", "180000000.0000 UTX", "eosio" ]' -p eosio@active

echo ""
echo "Init eosio.system Contract"
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action eosio init '[0, "4,UTX"]' -p eosio@active

echo ""
echo "Setting global params"
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action eosio setparams '{"params":{"max_block_net_usage": 1048576, "target_block_net_usage_pct": 1000, "max_transaction_net_usage": 524288, "base_per_transaction_net_usage": 12, "net_usage_leeway": 500, "context_free_discount_net_usage_num": 20, "context_free_discount_net_usage_den": 100, "max_block_cpu_usage": 1500000, "target_block_cpu_usage_pct": 1000, "max_transaction_cpu_usage": 1450000, "min_transaction_cpu_usage": 100, "max_transaction_lifetime": 3600, "deferred_trx_expiration_window": 600, "max_transaction_delay": 3888000, "max_inline_action_size": 4096, "max_inline_action_depth": 6, "max_authority_depth": 6}}' -p eosio@active

echo ""
echo "Creating testuser1 account"
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 system newaccount eosio testuser1 EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV --stake-net "1.0000 UTX" --stake-cpu "1.0000 UTX" --buy-ram "1.0000 UTX" --transfer

echo ""
echo "Transfering tokens to testuser1"
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action eosio.token transfer '["eosio", "testuser1", "160000000.0000 UTX",  ""]' -p eosio@active

echo ""
echo "attempt to register without sufficient stake (should fail)"
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action eosio regproducer '["testuser1", "EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV", "https://eostitan.com", 124]' -p testuser1@active

echo ""
echo "stake 10 million tokens"
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action eosio delegatebw '{"from":"testuser1", "receiver":"testuser1", "stake_net_quantity":"5000000.0000 UTX", "stake_cpu_quantity":"5000000.0000 UTX", "transfer":0}' -p testuser1@active

echo ""
echo "register with sufficient stake (should work)"
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action eosio regproducer '["testuser1", "EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV", "https://eostitan.com", 124]' -p testuser1@active

echo ""
echo "stake 140 million tokens (required for network activation)" 
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action eosio delegatebw '{"from":"testuser1", "receiver":"testuser1", "stake_net_quantity":"70000000.0000 UTX", "stake_cpu_quantity":"70000000.0000 UTX", "transfer":0}' -p testuser1@active

echo ""
echo "vote producer"
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action eosio voteproducer '{"voter":"testuser1", "proxy":"", "producers":["testuser1"]}' -p testuser1@active

echo ""
echo "attempt to unstake without unregproducer (should fail)"
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 --verbose push action eosio undelegatebw '{"from":"testuser1", "receiver":"testuser1", "unstake_net_quantity":"75000000.0000 UTX", "unstake_cpu_quantity":"74000000.0000 UTX"}' -p testuser1@active

echo ""
echo "unregister"
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action eosio unregprod '["testuser1"]' -p testuser1@active

echo ""
echo "unstake tokens (should work)"
docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action eosio undelegatebw '{"from":"testuser1", "receiver":"testuser1", "unstake_net_quantity":"75000000.0000 UTX", "unstake_cpu_quantity":"74000000.0000 UTX"}' -p testuser1@active
