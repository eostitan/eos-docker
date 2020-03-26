#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

for action in $@
do
	case $action in
		clone)
			echo "Clone ore-protocol repository"
			git clone https://github.com/CryptoMechanics/aikon-system-contract $DIR/../contracts/aikon-system-contract
			git clone https://github.com/CryptoMechanics/aikon-ore-protocol $DIR/../contracts/aikon-ore-protocol
#			git clone git@github.com:CryptoMechanics/aikon-system-contract $DIR/../contracts/aikon-system-contract
#			git clone git@github.com:CryptoMechanics/aikon-ore-protocol $DIR/../contracts/aikon-ore-protocol
			;;
		build)
			echo "Build ore system contracts using EOSIO.CDT v1.6.3"
			docker exec ore-main bash -c "cd /root/contracts/aikon-system-contract && mkdir -p build && ./build.sh -e /usr/opt/eosio/1.8.9/ -c /eosio.cdt/v1.6.3/usr/"
			echo "Build ore protocol contract using EOSIO.CDT v1.6.3"
			docker exec ore-main bash -c "cd /root/contracts/aikon-ore-protocol/contracts && mkdir -p build && ./build.sh"
			;;
		deploy)
			echo "Create system.ore user"
			docker exec -it ore-main cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 system newaccount eosio system.ore EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "100.0000 SYS" --stake-cpu "100.0000 SYS" --buy-ram "100.0000 SYS"

			echo "Create lock.ore user"
			docker exec -it ore-main cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 system newaccount eosio lock.ore EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy --stake-net "100.0000 SYS" --stake-cpu "100.0000 SYS" --buy-ram "100.0000 SYS"

			echo "Add eosio.code permission to system.ore"
			docker exec -it ore-main cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 set account permission system.ore active --add-code

			echo "Add eosio.code permission to lock.ore"
			docker exec -it ore-main cleos --url http://127.0.0.1:8888 --wallet-url http://keosd:8901 set account permission lock.ore active --add-code
			;;
		*)
			echo "OreProtocolDeploy: Action was not understood"
			;;
	esac
done
