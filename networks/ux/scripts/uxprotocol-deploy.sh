#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

for action in $@
do
	case $action in
		clone)
			echo "Clone ux contracts repository"
			git clone https://github.com/CryptoMechanics/ux.contracts $DIR/../ux.contracts
#			git clone git@github.com:CryptoMechanics/ux.contracts $DIR/../ux.contracts
			;;
		build)
			echo "Build ux system contracts using EOSIO.CDT v1.6.3"
			docker exec ux-main bash -c "cd /root/eosio.contracts && mkdir -p build && ./build.sh -e /usr/opt/eosio/1.8.9/ -c /eosio.cdt/v1.7.0/usr/"
			;;
		deploy)
			docker exec -it ux-main curl -X POST http://127.0.0.1:8888/v1/producer/schedule_protocol_feature_activations -d '{"protocol_features_to_activate": ["0ec7e080177b2c02b278d5088611686b49d739925a92d9bfcacd7fc6b74053bd"]}' | jq

			echo "Deploy OLD eosio.system contract"
			docker exec -it ux-main cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 set contract eosio /eosio.contracts.old/build/contracts/eosio.system/ eosio.system.wasm eosio.system.abi -p eosio@active

			# Active EOSIO network features
			docker exec -it ux-main cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action eosio activate '["f0af56d2c5a48d60a4a5b5c903edfb7db3a736a94ed589d0b797df33ff9d3e1d"]' -p eosio # GET_SENDER
			docker exec -it ux-main cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action eosio activate '["2652f5f96006294109b3dd0bbde63693f55324af452b799ee137a81a905eed25"]' -p eosio # FORWARD_SETCODE
			docker exec -it ux-main cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action eosio activate '["8ba52fe7a3956c5cd3a656a3174b931d3bb2abb45578befc59f283ecd816a405"]' -p eosio # ONLY_BILL_FIRST_AUTHORIZER
			docker exec -it ux-main cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action eosio activate '["ad9e3d8f650687709fd68f4b90b41f7d825a365b02c23a636cef88ac2ac00c43"]' -p eosio # RESTRICT_ACTION_TO_SELF
			docker exec -it ux-main cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action eosio activate '["68dcaa34c0517d19666e6b33add67351d8c5f69e999ca1e37931bc410a297428"]' -p eosio # DISALLOW_EMPTY_PRODUCER_SCHEDULE
			docker exec -it ux-main cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action eosio activate '["e0fb64b1085cc5538970158d05a009c24e276fb94e1a0bf6a528b48fbc4ff526"]' -p eosio # FIX_LINKAUTH_RESTRICTION
			docker exec -it ux-main cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action eosio activate '["ef43112c6543b88db2283a2e077278c315ae2c84719a8b25f25cc88565fbea99"]' -p eosio # REPLACE_DEFERRED
			docker exec -it ux-main cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action eosio activate '["4a90c00d55454dc5b059055ca213579c6ea856967712a56017487886a4d4cc0f"]' -p eosio # NO_DUPLICATE_DEFERRED_ID
			docker exec -it ux-main cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action eosio activate '["1a99a59d87e06e09ec5b028a9cbb7749b4a5ad8819004365d02dc4379a8b7241"]' -p eosio # ONLY_LINK_TO_EXISTING_PERMISSION
			docker exec -it ux-main cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action eosio activate '["4e7bf348da00a945489b2a681749eb56f5de00b900014e137ddae39f48f69d67"]' -p eosio # RAM_RESTRICTIONS
			docker exec -it ux-main cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action eosio activate '["4fca8bd82bbd181e714e283f83e1b45d95ca5af40fb89ad3977b653c448f78c2"]' -p eosio # WEBAUTHN_KEY
			docker exec -it ux-main cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 push action eosio activate '["299dcb6af692324b899b39f16d5a530a33062804e41f09dc97e9f156b4476707"]' -p eosio # WTMSIG_BLOCK_SIGNATURES

			# Deploy blockchain smart contracts
			echo "Deploy eosio.bios contract"
			docker exec -it ux-main cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 set contract eosio /eosio.contracts/build/contracts/eosio.bios/ eosio.bios.wasm eosio.bios.abi -p eosio@active

			echo "Deploy NEW eosio.system contract"
			docker exec -it ux-main cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 set contract eosio /eosio.contracts/build/contracts/eosio.system/ eosio.system.wasm eosio.system.abi -p eosio@active

			# echo "Deploy eosio.token contract"
			# docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 set contract eosio.token /eosio.contracts/build/contracts/eosio.token/ eosio.token.wasm eosio.token.abi -p eosio.token@active

			# echo "Deploy eosio.msig contract"
			# docker exec -it $CONTAINER cleos --url http://127.0.0.1:8888 --wallet-url http://ux-wallet:8901 set contract eosio.msig /eosio.contracts/build/contracts/eosio.msig/ eosio.msig.wasm eosio.msig.abi -p eosio.msig@active
			;;
		*)
			echo "UXDeploy: Action was not understood"
			;;
	esac
done
