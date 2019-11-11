# EOS Docker Scripts

---

### Building
- Clone this repo
	- `git clone https://github.com/netuoso/eos-docker`
	- `git submodule update --init --recursive`
- Build docker image
	- `docker build --tag eostestnet -f build-testnet.dockerfile .`
- Start docker services
	- `cd scripts`
	- `docker-compose up -d && ./bootstrap.sh`
- View logs of running nodeos container
	- `docker-compose logs -f`

### EOSIO Development KeyPairs *(DO NOT USE THESE KEYS IN PRODUCTION)*
- System Accounts: `eosio`, `eosio.token`, `eosio.msig`, `eosio.bpay`, `eosio.names`, `eosio.ram`, `eosio.ramfree`, `eosio.saving`, `eosio.stake`, `eosio.vpay`, `eosio.rex`
	- Private key: 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3
	- Public key: EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
- Development Accounts: `testuser`, `producer1`, `producer2`, `delphioracle`
	- Private key: 5JUzsJi7rARZy2rT5eHhcdUKTyVPvaksnEKtNWzyiBbifJA1dUW
	- Public key: EOS6CRG7tXc9u2ySGqkH69JrwG4yXojkZBVUMLgUnKfM6uJpDUtKy
