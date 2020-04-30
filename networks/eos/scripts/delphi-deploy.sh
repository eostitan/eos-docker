#!/bin/bash

for action in $@
do
	case $action in
		clone)
			echo "Clone delphioracle repository"
			docker exec eos-main bash -c "git clone https://github.com/eostitan/delphioracle /root/contracts/delphioracle"
			;;
		build)
			echo "Build delphioracle oracle"
			docker exec eos-main bash -c "cd /root/contracts/delphioracle && make -p build && cd build && cmake .. && make"
			;;
		deploy)
			echo "Create delphioracle user"
			docker exec -it eos-main cleos --url http://127.0.0.1:8888 --wallet-url http://eos-wallet:8901 system newaccount eosio delphioracle EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "100.0000 EOS" --stake-cpu "100.0000 EOS" --buy-ram "100.0000 EOS"

			echo "Add eosio.code permission to delphioracle"
			docker exec -it eos-main cleos --url http://127.0.0.1:8888 --wallet-url http://eos-wallet:8901 set account permission delphioracle active --add-code

			echo "Deploy delphioracle contract"
			docker exec -it eos-main cleos --url http://127.0.0.1:8888 --wallet-url http://eos-wallet:8901 set contract delphioracle /root/contracts/delphioracle/build/delphioracle delphioracle.wasm delphioracle.abi -p delphioracle@active

			echo "Listing delphioracle code hash"
			docker exec -it eos-main cleos --url http://127.0.0.1:8888 --wallet-url http://eos-wallet:8901 get code delphioracle
			;;
		configure)
			echo "Configure delphioracle"
			docker exec -it eos-main cleos --url http://127.0.0.1:8888 --wallet-url http://eos-wallet:8901 push action delphioracle configure  '{"g":{"datapoints_per_instrument":21,"bars_per_instrument":30,"vote_interval":10000,"write_cooldown":55000000,"approver_threshold":1,"approving_oracles_threshold":2,"approving_custodians_threshold":1,"minimum_rank":105,"paid":21,"min_bounty_delay":604800,"new_bounty_delay":259200}}' -p delphioracle
			;;
		*)
			echo "DelphiDeploy: Action was not understood"
			;;
	esac
done
