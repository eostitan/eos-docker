# EOS Docker Scripts

---

### Description
Building and configuring an EOSIO testnet requires one to take several steps in order to prepare the network to mimic that of the EOSIO mainnet. These actions consist of creating the system level accounts, building and deploying the system contracts (https://github.com/eosio/eosio.contracts : `eosio.bios`, `eosio.msig`, `eosio.system`, `eosio.token`, `eosio.wrap`), creating and issuing the EOS token, and staking enough of the token to activate the network.

This repository also includes the initial setup required for DelphiOracle testing and development such as creating the `delphioracle` account, cloning the DelphiOracle repository (https://github.com/eostitan/delphioracle), building and deploying the contract, and finally configuring the contract for usage.

Finally, this setup will run a default pricefeed and writehash script for properly testing the DelphiOracle. Enjoy.

### Building
- Clone this repo
	- `git clone https://github.com/netuoso/eos-docker`
- Start docker services (will build all images)
	- `cd scripts`
	- `docker-compose up -d && ./bootstrap.sh`
- View logs of running containers
	- `docker-compose logs -f`

### EOSIO Development KeyPairs *(DO NOT USE THESE KEYS IN PRODUCTION)*
- System Accounts: `eosio`, `eosio.token`, `eosio.msig`, `eosio.bpay`, `eosio.names`, `eosio.ram`, `eosio.ramfree`, `eosio.saving`, `eosio.stake`, `eosio.vpay`, `eosio.rex`
	- Private key: 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3
	- Public key: EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
- Development Accounts: `testuser`, `producer1`, `producer2`, `delphioracle`
	- Private key: 5JUzsJi7rARZy2rT5eHhcdUKTyVPvaksnEKtNWzyiBbifJA1dUW
	- Public key: EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy

### Warning
This software is provided as-is and with no warranty. Please use at your own risk and never use production EOSIO keypairs in development or vice versa. The provided keypairs in this repository are for development purposes only, and using them in the EOSIO mainnet can result in lost or stolen tokens. The author of this repository assumes no responsiblity for your inability to follow these instructions.
