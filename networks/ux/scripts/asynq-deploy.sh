#!/bin/bash

WALLET="http://ux-wallet:8901"
HOST="http://127.0.0.1:8888"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

for action in $@
do
	case $action in
		clone)

			echo "Clone asynq contract repository"
			git clone https://github.com/CryptoMechanics/asynq-contract $DIR/../contracts/asynq
			docker exec ux-main bash -c "mkdir /root/contracts/asynq/build"

			;;
		build)
			
			echo "Build asynq using EOSIO.CDT v1.7.0"
			docker exec ux-main bash -c "cd /root/contracts/asynq/build && cmake .. && make"

			;;
		deploy)
			echo "Deploy asynq contract"
			docker exec -it ux-main cleos --url $HOST --wallet-url $WALLET set contract asynqverify1 /root/contracts/asynq/build/asynq/ asynq.wasm asynq.abi -p asynqverify1@active

			;;
		addtestdata)
			echo "Add testing data for asynq contract"
			docker exec -it ux-main cleos --url $HOST --wallet-url $WALLET push action eosio.info adduserver '{"kyc_account":"asynqverify1", "user":"bp1", "verification_key":"passv"}' -p asynqverify1@active
			docker exec -it ux-main cleos --url $HOST --wallet-url $WALLET push action eosio.info deluserver '{"kyc_account":"asynqverify1", "user":"bp1", "verification_key":"passv"}' -p asynqverify1@active
			docker exec -it ux-main cleos --url $HOST --wallet-url $WALLET push action eosio.info adduserver '{"kyc_account":"asynqverify1", "user":"bp1", "verification_key":"passv"}' -p asynqverify1@active
			docker exec -it ux-main cleos --url $HOST --wallet-url $WALLET push action eosio.info adduserver '{"kyc_account":"asynqverify1", "user":"bp1", "verification_key":"utbiv"}' -p asynqverify1@active
			docker exec -it ux-main cleos --url $HOST --wallet-url $WALLET push action eosio.info adduserver '{"kyc_account":"asynqverify1", "user":"bp2", "verification_key":"passv"}' -p asynqverify1@active
			docker exec -it ux-main cleos --url $HOST --wallet-url $WALLET push action eosio.info adduserver '{"kyc_account":"asynqverify1", "user":"bp2", "verification_key":"utbiv"}' -p asynqverify1@active
			docker exec -it ux-main cleos --url $HOST --wallet-url $WALLET push action eosio.info adduserver '{"kyc_account":"asynqverify1", "user":"bp3", "verification_key":"passv"}' -p asynqverify1@active
			docker exec -it ux-main cleos --url $HOST --wallet-url $WALLET push action eosio.info adduserver '{"kyc_account":"asynqverify1", "user":"bp4", "verification_key":"drliv"}' -p asynqverify1@active
			docker exec -it ux-main cleos --url $HOST --wallet-url $WALLET push action eosio.info adduserver '{"kyc_account":"asynqverify1", "user":"bp4", "verification_key":"utbiv"}' -p asynqverify1@active
			docker exec -it ux-main cleos --url $HOST --wallet-url $WALLET push action eosio.info adduserver '{"kyc_account":"asynqverify1", "user":"bp5", "verification_key":"drliv"}' -p asynqverify1@active
			docker exec -it ux-main cleos --url $HOST --wallet-url $WALLET push action eosio.info adduserver '{"kyc_account":"asynqverify1", "user":"bp5", "verification_key":"utbiv"}' -p asynqverify1@active

			;;
		reindex)
			echo "Reindex testing existing data for asynq contract"
			docker exec -it ux-main cleos --url $HOST --wallet-url $WALLET push action asynqverify1 reindexlock '{"aggregation": "aggtest"}' -p asynqverify1@active
			docker exec -it ux-main cleos --url $HOST --wallet-url $WALLET push action asynqverify1 reindex '{"aggregation": "aggtest", "batch_size": 100}' -p asynqverify1@active

			;;
		printaggregations)
			echo "Print Aggregations"
			docker exec -it ux-main cleos --url $HOST --wallet-url $WALLET get table asynqverify1 aggtest aggregations

			;;
		*)
			echo "AsynqDeploy: Action was not understood"
			;;
	esac
done
