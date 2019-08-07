# EOS Docker Scripts

---

### Building
- Clone this repo
	- `git clone https://github.com/netuoso/eos-docker`
	- `git submodule update --init --recursive`
- Build docker image
	- `docker build --tag eostestnet -f build-testnet.dockerfile .`
- Prepare config file and default wallet
	- place `default.wallet` in `eos-docker` root directory
- Start docker services
	- `docker-compose up -d`
- View logs of running nodeos container
	- `docker-compose logs -f`
