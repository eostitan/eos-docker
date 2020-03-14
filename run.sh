#!/usr/bin/env bash
#
# EOS Docker node manager
# Released under MIT by @netuoso
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

BOLD="$(tput bold)"
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
MAGENTA="$(tput setaf 5)"
CYAN="$(tput setaf 6)"
WHITE="$(tput setaf 7)"
RESET="$(tput sgr0)"

# Placeholder for custom tag var CUST_TAG (shared between functions)
CUST_TAG="eosio"
# Placeholder for BUILD_VER shared between functions
BUILD_VER=""

: ${DOCKER_DIR="$DIR/Dockerfiles"}

# EOS Blockchain
: ${EOS_DATADIR="$DIR/networks/eos"}
: ${EOS_DK_TAG="eostitan/eosio:latest"}
: ${EOS_BC_FOLDER="$EOS_DATADIR/data"}
: ${EOS_EXAMPLE_CONF="$EOS_DATADIR/configs/config.ini.example"}
: ${EOS_EXAMPLE_GENESIS="$EOS_DATADIR/configs/genesis.json.example"}
: ${EOS_EXAMPLE_LOGGING="$EOS_DATADIR/configs/logging.json.example"}
: ${EOS_CONF_FILE="$EOS_DATADIR/data/config.ini"}
: ${EOS_GENESIS_FILE="$EOS_DATADIR/data/genesis.json"}
: ${EOS_LOGGING_FILE="$EOS_DATADIR/data/logging.json"}
# Git repository to use when building EOS - containing EOSIO code
: ${EOS_SOURCE="https://github.com/eosio/eos.git"}
: ${EOS_CONTRACTS_SOURCE="https://github.com/eosio/eosio.contracts.git"}

# ORE Blockchain
: ${ORE_DATADIR="$DIR/networks/ore"}
: ${ORE_DK_TAG="eostitan/ore:latest"}
: ${ORE_BC_FOLDER="$ORE_DATADIR/data"}
: ${ORE_EXAMPLE_CONF="$ORE_DATADIR/configs/config.ini.example"}
: ${ORE_EXAMPLE_GENESIS="$ORE_DATADIR/configs/genesis.json.example"}
: ${ORE_EXAMPLE_LOGGING="$ORE_DATADIR/configs/logging.json.example"}
: ${ORE_CONF_FILE="$ORE_DATADIR/data/config.ini"}
: ${ORE_GENESIS_FILE="$ORE_DATADIR/data/genesis.json"}
: ${ORE_LOGGING_FILE="$ORE_DATADIR/data/logging.json"}
# Git repository to use when building ORE - containing ORE code
: ${ORE_SOURCE="https://github.com/API-market/ore-protocol.git"}
: ${ORE_CONTRACTS_SOURCE="https://github.com/API-market/eosio.contracts.git"}

# Steem Blockchain
: ${STEEM_DATADIR="$DIR/networks/steem"}
: ${STEEM_DK_TAG="steemit/steem:latest"}
: ${STEEM_BC_FOLDER="$STEEM_DATADIR/data"}
: ${STEEM_EXAMPLE_CONF="$STEEM_DATADIR/configs/config.ini.example"}
: ${STEEM_EXAMPLE_WALLET="$STEEM_DATADIR/configs/wallet.json.example"}
: ${STEEM_CONF_FILE="$STEEM_DATADIR/data/config.ini"}
: ${STEEM_WALLET_FILE="$STEEM_DATADIR/data/wallet.json"}
# Git repository to use when building Steem - containing steemd code
: ${STEEM_SOURCE="https://github.com/steemit/steem.git"}

# if the eos config file doesn't exist, try copying the example config
if [[ ! -f "$EOS_CONF_FILE" ]]; then
  if [[ -f "$EOS_EXAMPLE_CONF" ]]; then
    echo "${YELLOW}EOS: File config.ini not found. copying example${RESET}"
    cp -vi "$EOS_EXAMPLE_CONF" "$EOS_CONF_FILE" 
    echo "${GREEN} > Successfully installed example config for eos node.${RESET}"
    echo " > You may want to adjust this if you're running a witness"
  else
    echo "${YELLOW}WARNING: You don't seem to have a config file and the example config couldn't be found...${RESET}"
    echo "Example Config: $EOS_EXAMPLE_CONF"
    echo "Main Config: $EOS_CONF_FILE"
  fi
fi

# if the eos genesis file doesn't exist, try copying the example genesis file
if [[ ! -f "$EOS_GENESIS_FILE" ]]; then
  if [[ -f "$EOS_EXAMPLE_GENESIS" ]]; then
    echo "${YELLOW}EOS: File genesis.json not found. copying example${RESET}"
    cp -vi "$EOS_EXAMPLE_GENESIS" "$EOS_GENESIS_FILE" 
    echo "${GREEN} > Successfully installed example genesis file for eos node.${RESET}"
  else
    echo "${YELLOW}WARNING: You don't seem to have a genesis file and the example genesis couldn't be found...${RESET}"
    echo "Example Config: $EOS_EXAMPLE_GENESIS"
    echo "Main Config: $EOS_GENESIS_FILE"
  fi
fi

# if the eos logging file doesn't exist, try copying the example logging config
if [[ ! -f "$EOS_LOGGING_FILE" ]]; then
  if [[ -f "$EOS_EXAMPLE_LOGGING" ]]; then
    echo "${YELLOW}EOS: File logging.json not found. copying example${RESET}"
    cp -vi "$EOS_EXAMPLE_LOGGING" "$EOS_LOGGING_FILE" 
    echo "${GREEN} > Successfully installed example logging config for eos node.${RESET}"
  else
    echo "${YELLOW}WARNING: You don't seem to have a logging config file and the example config couldn't be found...${RESET}"
    echo "Example Config: $EOS_EXAMPLE_LOGGING"
    echo "Main Config: $EOS_LOGGING_FILE"
  fi
fi

# if the ore config file doesn't exist, try copying the example config
if [[ ! -f "$ORE_CONF_FILE" ]]; then
  if [[ -f "$ORE_EXAMPLE_CONF" ]]; then
    echo "${YELLOW}ORE: File config.ini not found. copying example${RESET}"
    cp -vi "$ORE_EXAMPLE_CONF" "$ORE_CONF_FILE" 
    echo "${GREEN} > Successfully installed example config for ore node.${RESET}"
    echo " > You may want to adjust this if you're running a witness"
  else
    echo "${YELLOW}WARNING: You don't seem to have a config file and the example config couldn't be found...${RESET}"
    echo "Example Config: $ORE_EXAMPLE_CONF"
    echo "Main Config: $ORE_CONF_FILE"
  fi
fi

# if the ore genesis file doesn't exist, try copying the example genesis file
if [[ ! -f "$ORE_GENESIS_FILE" ]]; then
  if [[ -f "$ORE_EXAMPLE_GENESIS" ]]; then
    echo "${YELLOW}ORE: File genesis.json not found. copying example${RESET}"
    cp -vi "$ORE_EXAMPLE_GENESIS" "$ORE_GENESIS_FILE" 
    echo "${GREEN} > Successfully installed example genesis file for ore node.${RESET}"
  else
    echo "${YELLOW}WARNING: You don't seem to have a genesis file and the example genesis couldn't be found...${RESET}"
    echo "Example Config: $ORE_EXAMPLE_GENESIS"
    echo "Main Config: $ORE_GENESIS_FILE"
  fi
fi

# if the ore logging file doesn't exist, try copying the example logging config
if [[ ! -f "$ORE_LOGGING_FILE" ]]; then
  if [[ -f "$ORE_EXAMPLE_LOGGING" ]]; then
    echo "${YELLOW}ORE: File logging.json not found. copying example${RESET}"
    cp -vi "$ORE_EXAMPLE_LOGGING" "$ORE_LOGGING_FILE" 
    echo "${GREEN} > Successfully installed example logging config for ore node.${RESET}"
  else
    echo "${YELLOW}WARNING: You don't seem to have a logging config file and the example config couldn't be found...${RESET}"
    echo "Example Config: $ORE_EXAMPLE_LOGGING"
    echo "Main Config: $ORE_LOGGING_FILE"
  fi
fi

# if the steem config file doesn't exist, try copying the example config
if [[ ! -f "$STEEM_CONF_FILE" ]]; then
  if [[ -f "$STEEM_EXAMPLE_CONF" ]]; then
    echo "${YELLOW}STEEM: File config.ini not found. copying example${RESET}"
    cp -vi "$STEEM_EXAMPLE_CONF" "$STEEM_CONF_FILE" 
    echo "${GREEN} > Successfully installed example config for steem node.${RESET}"
    echo " > You may want to adjust this if you're running a witness"
  else
    echo "${YELLOW}WARNING: You don't seem to have a config file and the example config couldn't be found...${RESET}"
    echo "${YELLOW}${BOLD}You may want to check these files exist, or you won't be able to launch Steem${RESET}"
    echo "Example Config: $STEEM_EXAMPLE_CONF"
    echo "Main Config: $STEEM_CONF_FILE"
  fi
fi

# if the steem wallet file doesn't exist, try copying the example wallet
if [[ ! -f "$STEEM_WALLET_FILE" ]]; then
  if [[ -f "$STEEM_EXAMPLE_WALLET" ]]; then
    echo "${YELLOW}STEEM: File wallet.json not found. copying example${RESET}"
    cp -vi "$STEEM_EXAMPLE_WALLET" "$STEEM_WALLET_FILE" 
    echo "${GREEN} > Successfully installed example wallet for steem node.${RESET}"
  else
    echo "${YELLOW}WARNING: You don't seem to have a wallet file and the example wallet couldn't be found...${RESET}"
    echo "Example Wallet: $STEEM_EXAMPLE_WALLET"
    echo "Main Wallet: $STEEM_WALLET_FILE"
  fi
fi

# Array of additional arguments to be passed to Docker during builds
# Generally populated using arguments passed to build
# But you can specify custom additional build parameters by setting CUSTOM_ARGS
# as an array in .env
# e.g.
#
#    CUSTOM_ARGS=('--rm' '-q' '--compress')
#
CUSTOM_ARGS=()

function msg () {
  # usage: msg [color] message
  if [[ "$#" -eq 0 ]]; then echo ""; return; fi;
  if [[ "$#" -eq 1 ]]; then
    echo -e "$1"
    return
  fi
  if [[ "$#" -gt 2 ]] && [[ "$1" == "bold" ]]; then
    echo -n "${BOLD}"
    shift
  fi
  _msg="[$(date +'%Y-%m-%d %H:%M:%S %Z')] ${@:2}"
  case "$1" in
    bold) echo -e "${BOLD}${_msg}${RESET}";;
    [Bb]*) echo -e "${BLUE}${_msg}${RESET}";;
    [Yy]*) echo -e "${YELLOW}${_msg}${RESET}";;
    [Rr]*) echo -e "${RED}${_msg}${RESET}";;
    [Gg]*) echo -e "${GREEN}${_msg}${RESET}";;
    * ) echo -e "${_msg}";;
  esac
}

export -f msg
export RED GREEN YELLOW BLUE BOLD NORMAL RESET

if [[ -f .env ]]; then
  source .env
fi

help() {
  echo "Usage: $0 COMMAND [DATA]"
  echo
  echo "Commands: 
  start - starts network|container(s) - [eos|steem|ore]
  clean - Remove testnet files - [eos|steem|ore]
  stop - stops container(s) - [eos|steem|ore]
  status - show status of eos container - [eos|steem|ore]
  restart - restarts container(s) - [eos|steem|ore]
  install_docker - install docker
  rebuild - builds eos container(s), and then restarts it - [eos|steem|ore]
  build - build docker container(s) - [eos|steem|ore]
  buildcontact - build specific contact inside main container - [eos|ore]
  cleos - access cleos command line in container - [eos|ore]
  setcdt - set eosio.cdt version in container - [eos|ore]
  logs - show log stream - [eos|steem|ore]
  wallet - open wallet in the container - [eos|steem|ore]
  enter - enter a bash session in the currently running container - [eos|steem|ore]
  shell - launch the eos container with appropriate mounts, then open bash for inspection - [eos|steem|ore]
  "
  echo
  exit
}

# Usage: ./run.sh build [network]
# Build the docker images for specified network
#
#   network - specify which network to build network for [eos|steem]
#
build() {
  fmm="EOS Testnet"
  BUILD_MSG=" >> Building docker container [[ ${fmm} ]]"
  msg bold green "$BUILD_MSG"
  cd "$DOCKER_DIR"
  case $1 in
    eos)
      docker-compose build keosd nodeos pricefeed writehash
      ;;
    steem)
      docker-compose build steem
      ;;
  esac
  ret=$?
  if (( $ret == 0 )); then
    msg bold green " +++ Successfully built EOS Testnet images"
    msg green " +++ Docker tag: $1"
  else
    msg bold red " !!! ERROR: Something went wrong during the build process."
    msg red " !!! Please scroll up and check for any error output during the build."
  fi
}

# Usage: ./run.sh install_docker
# Downloads and installs the latest version of Docker using the Get Docker site
# If Docker is already installed, it should update it.
install_docker() {
  sudo apt update
  # curl/git used by docker, xz/lz4 used by dlblocks, jq used by tslogs/pclogs
  sudo apt install curl git xz-utils liblz4-tool jq
  curl https://get.docker.com | sh
  if [ "$EUID" -ne 0 ]; then 
    echo "Adding user $(whoami) to docker group"
    sudo usermod -aG docker $(whoami)
    echo "IMPORTANT: Please re-login (or close and re-connect SSH) for docker to function correctly"
  fi
}

# Usage: ./run.sh bootstrap [network]
# Bootstraps the testnet
#
#   network - specify which network to build container for [eos|steem]
#
bootstrap() {
  case $1 in
    eos|ore|steem)
      cd "$DIR"
      msg yellow bootstrap $1
      bash -c "./networks/$1/scripts/bootstrap.sh $2"
      ;;
    *)
      msg bold red "Unknown docker image use [eos|ore|steem]"
      ;;
  esac
}

### EOS|ORE Only
# Usage: ./run.sh deploy [contract]
# Deploy specified contract to network
#
#   contract - specify which contract to deploy
#
deploy() {
  cd "$DIR"
  msg yellow set contract $2
  case $1 in
    eos)
      case $2 in
        ict)
          docker exec -it "eos-main" cleos --wallet-url http://keosd:8901 set contract ict /root/contracts/ict/contract/ict/build/ict/ ict.wasm ict.abi -p ict@active
          ;;
        vpow.token)
          docker exec -it "eos-main" cleos --wallet-url http://keosd:8901 set contract vpow.token /root/contracts/vpow-contract/build/vpowtoken/ vpowtoken.wasm vpowtoken.abi -p vpow.token@active
          ;;
        delphioracle)
          bash -c "$EOS_DATADIR/scripts/delphi-deploy.sh clone build deploy configure"
          ;;
        eosio.system)
          docker exec -it "eos-main" cleos --wallet-url http://keosd:8901 set contract eosio /eosio.contracts/build/contracts/eosio.system/ eosio.system.wasm eosio.system.abi -p eosio@active
          ;;
        *)
          msg red "Contract not recognized: [ict|delphioracle|eosio.system]"
          ;;
      esac
      ;;
    ore)
      case $2 in
        delphioracle)
          bash -c "$ORE_DATADIR/scripts/delphi-deploy.sh clone build deploy configure"
          ;;
        eosio.system)
          docker exec -it "ore-main" cleos --wallet-url http://ore-wallet:8901 set contract eosio /root/contracts/aikon-system-contract/build/contracts/eosio.system/ eosio.system.wasm eosio.system.abi -p eosio@active
          ;;
        *)
          msg red "Contract not recognized: [ict|delphioracle|eosio.system]"
          ;;
      esac
      ;;
    *)
      msg bold red "Unsupported network. Use [eos|ore]"
      ;;
  esac
}

### EOS|ORE Only
# Usage: ./run.sh initcontract [contract]
# Initalize specified contract
#
#   contract - specify which contract to initcontract
#
initcontract() {
  if (( $# >= 1 )); then
    cd "$DIR"
    msg yellow set contract $1
    case $1 in
      ict)
        docker exec -it "eos-main" cleos --wallet-url http://keosd:8901 push action ict create '{"issuer":"ict","maximum_supply":"10000000.000 TESTS"}' -p ict@active
        ;;
      *)
        msg red "Contract not recognized: [ict]"
        ;;
    esac
  fi
}

### EOS|ORE Only
# Usage: ./run.sh build [contract]
# Deploy specified contract to network
#
#   contract - specify which contract to build
#
buildcontract() {
  if (( $# >= 1 )); then
    cd "$DIR"
    msg yellow set contract $1
    case $1 in
      ict)
        docker exec -it "eos-main" bash -c "cd /root/contracts/ict/contract/ict/build/ && cmake .. && make"
        ;;
      delphioracle)
        bash -c "$EOS_DATADIR/scripts/delphi-deploy.sh clone build deploy configure"
        ;;
      eosio.system)
        docker exec -it "eos-main" cleos --wallet-url http://keosd:8901 set contract eosio /eosio.contracts/build/contracts/eosio.system/ eosio.system.wasm eosio.system.abi -p eosio@active
        ;;
      ore)
        msg red "ORE: buildcontract not yet implemented"
        ;;
      *)
        msg red "Contract not recognized: [ict|delphioracle|eosio.system]"
        ;;
    esac
  fi
}

### EOS|ORE Only
# Usage: ./run.sh cleos [command]
# Run a cleos command
#
#   command - specify which contract to build and cleos
#
cleos() {
  case $1 in
    eos|ore)
      docker exec -it "$1"-main cleos --wallet-url http://"$1"-wallet:8901 "${@:2}"
    ;;
    *)
      msg red "Unrecognized network. Use: [eos|ore]"
    ;;
  esac
}

### EOS|ORE Only
# Usage: ./run.sh setcdt [version]
# Run a cleos command
#
#   version - specify which version of Eosio.CDT to activate inside main container
#
setcdt() {
  case $1 in
    eos|ore)
      case $2 in
        v1.4.1|v1.6.3)
          msg yellow "$1: Activating EOSIO.CDT Version $2"
          current=$(docker exec $1-main eosio-cpp --version)
          if [[ "$current" == *"${2:1:5}"* ]]; then
            msg green "$1: EOSIO.CDT version already set"
            return
          fi

          docker exec "$1"-main bash -c "cp -rf /eosio.cdt/$2/usr/* /usr/"
          msg yellow "$1: Done"
        ;;
        *)
          msg red bold "$1: Unknown CDT version. Select from [v1.4.1|v1.6.3]"
        ;;
      esac
      ;;
  esac
}

# Internal Use Only
# Checks if the container main container exists. Returns 0 if it does, -1 if not.
#
eos_main_exists() {
  ret=$(docker ps -a -f name="eos-main" | wc -l)
  if [[ $ret -eq 2 ]]; then
    return 0
  else
    return -1
  fi
}

# Internal Use Only
# Checks if the container wallet container exists. Returns 0 if it does, -1 if not.
#
eos_wallet_exists() {
  ret=$(docker ps -a -f name="eos-wallet" | wc -l)
  if [[ $ret -eq 2 ]]; then
    return 0
  else
    return -1
  fi
}

# Internal Use Only
# Checks if the container main container exists. Returns 0 if it does, -1 if not.
#
ore_main_exists() {
  ret=$(docker ps -a -f name="ore-main" | wc -l)
  if [[ $ret -eq 2 ]]; then
    return 0
  else
    return -1
  fi
}

# Internal Use Only
# Checks if the container wallet container exists. Returns 0 if it does, -1 if not.
#
ore_wallet_exists() {
  ret=$(docker ps -a -f name="ore-wallet" | wc -l)
  if [[ $ret -eq 2 ]]; then
    return 0
  else
    return -1
  fi
}

# Internal Use Only
# Checks if the container main container exists and is running. Returns 0 if it does, -1 if not.
#
eos_main_running() {
  ret=$(docker ps -f 'status=running' -f name="eos-main" | wc -l)
  if [[ $ret -eq 2 ]]; then
    return 0
  else
    return -1
  fi
}

# Internal Use Only
# Checks if the container wallet container exists and is running. Returns 0 if it does, -1 if not.
#
eos_wallet_running() {
  ret=$(docker ps -f 'status=running' -f name="eos-wallet" | wc -l)
  if [[ $ret -eq 2 ]]; then
    return 0
  else
    return -1
  fi
}

# Internal Use Only
# Checks if the container main container exists and is running. Returns 0 if it does, -1 if not.
#
ore_main_running() {
  ret=$(docker ps -f 'status=running' -f name="ore-main" | wc -l)
  if [[ $ret -eq 2 ]]; then
    return 0
  else
    return -1
  fi
}

# Internal Use Only
# Checks if the container wallet container exists and is running. Returns 0 if it does, -1 if not.
#
ore_wallet_running() {
  ret=$(docker ps -f 'status=running' -f name="ore-wallet" | wc -l)
  if [[ $ret -eq 2 ]]; then
    return 0
  else
    return -1
  fi
}

# Usage: ./run.sh start
# Creates and/or starts the Steem docker container
start() {
  msg bold green " -> Starting container(s) ${1}..."
  cd "$DOCKER_DIR"
  case $1 in
    eos|ore|steem)
      docker-compose -f docker-compose-"$1".yml -p $1 up -d $2
      ;;
    *)
      msg red "Network not recognized: [eos|steem]"
      ;;
  esac
}

# Usage: ./run.sh stop
# Stops the Steem container, and removes the container to avoid any leftover
#
stop() {
  msg "If you don't care about a clean stop, you can force stop the container with ${BOLD}./run.sh kill"
  msg red "Stopping network ..."
  cd "$DOCKER_DIR"
  case $1 in
    eos|ore|steem)
      docker-compose -f docker-compose-"$1".yml -p $1 rm -sf $2
      ;;
    *)
      msg red "Network not recognized: [eos|steem]"
      ;;
  esac
}

sbkill() {
  msg bold red "Killing network '${1}'..."
  cd "$DOCKER_DIR"
  docker-compose down -t 1 $1
}

# Usage: ./run.sh enter
# Enters the running docker container and opens a bash shell for debugging
#
enter() {
  docker exec -it "$1" bash
}

# Usage: ./run.sh shell
# Runs the container similar to `run` with mounted directories, 
# then opens a BASH shell for debugging
# To avoid leftover containers, it uses `--rm` to remove the container once you exit.
#
shell() {
  case $1 in
    eos)
      docker run -v "$EOS_DATADIR/data:/eosio-data" --rm -it "eosio-testnet" bash
      ;;
    ore)
      docker run -v "$ORE_DATADIR/data:/ore-data" --rm -it "ore-testnet" bash
      ;;
    steem)
      docker run -v "$STEEM_DATADIR/data:/steemd-data" --rm -it "steemit/steem:latest" bash
      ;;
    *)
      msg bold red "Unrecognized network name. Use [eos|ore|steem]"
      ;;
    esac
}

# Usage: ./run.sh wallet
# Opens cli_wallet inside of the running Steem container and
# connects to the local steemd over websockets on port 8090
#
wallet() {
  case $1 in
    eos)
      docker exec -it "eos-wallet" cleos  -u http://eos-main:8888 wallet "${@:2}"
      ;;
    ore)
      docker exec -it "ore-wallet" cleos -u http://ore-main:8888 wallet "${@:2}"
      ;;
    steem)
      docker exec -it "steem" /usr/local/steemd-testnet/bin/cli_wallet -w /steemd-data/wallet.json "${@:2}"
      ;;
    true) # used with wallet_cmd for Steem only
        docker exec "steem" /usr/local/steemd-testnet/bin/cli_wallet -w /steemd-data/wallet.json "${@:2}"
        ;;
    *)
      msg bold red "Unrecognized network name. Use [eos|steem]"
      ;;
  esac
}

# Usage: ./run.sh logs
# Shows the last 30 log lines of the running steem container, and follows the log until you press ctrl-c
#
logs() {
  msg blue "DOCKER LOGS: (press ctrl-c to exit) "
  cd "$DOCKER_DIR"
  case $1 in
    eos|ore|steem)
      docker-compose -f docker-compose-"$1".yml -p $1 logs -f --tail 30 $2
      ;;
    *)
      msg red "Network not recognized: [eos|ore|steem]"
      ;;
  esac
}

# Usage: ./run.sh status
# Very simple status display, letting you know if the container exists, and if it's running.
status() {
  
  echo "${BOLD}${BLUE}========= EOS =========${RESET}"

  if eos_main_exists; then
      echo "eos-main exists?: "$GREEN"YES"$RESET
    if eos_main_running; then
        echo "eos-main running?: "$GREEN"YES"$RESET
    else
        echo "eos-main running?: "$RED"NO (!)"$RESET
        echo "eos-main isn't running. Start it with '$0 start eos-main'"$RESET
    fi
  else
      echo "eos-main exists?: "$RED"NO (!)"$RESET 
      echo "eos-main doesn't exist, thus it is NOT running. Run '$0 start eos-main'"$RESET
  fi

  if eos_wallet_exists; then
      echo "eos-wallet exists?: "$GREEN"YES"$RESET
    if eos_wallet_running; then
        echo "eos-wallet running?: "$GREEN"YES"$RESET
    else
        echo "eos-wallet running?: "$RED"NO (!)"$RESET
        echo "eos-wallet isn't running. Start it with '$0 start eos-wallet'"$RESET
    fi
  else
      echo "eos-wallet exists?: "$RED"NO (!)"$RESET 
      echo "eos-wallet doesn't exist, thus it is NOT running. Run '$0 start eos-wallet'"$RESET
  fi

  echo "${BOLD}${BLUE}========= ORE =========${RESET}"

  if ore_main_exists; then
      echo "ore-main exists?: "$GREEN"YES"$RESET
    if ore_main_running; then
        echo "ore-main running?: "$GREEN"YES"$RESET
    else
        echo "ore-main running?: "$RED"NO (!)"$RESET
        echo "ore-main isn't running. Start it with '$0 start ore-main'"$RESET
    fi
  else
      echo "ore-main exists?: "$RED"NO (!)"$RESET 
      echo "ore-main doesn't exist, thus it is NOT running. Run '$0 start ore-main'"$RESET
  fi

  if ore_wallet_exists; then
    echo "ore-wallet exists?: "$GREEN"YES"$RESET
    if ore_wallet_running; then
        echo "ore-wallet running?: "$GREEN"YES"$RESET
    else
        echo "ore-wallet running?: "$RED"NO (!)"$RESET
        echo "ore-wallet isn't running. Start it with '$0 start ore-wallet'"$RESET
    fi
  else
    echo "ore-wallet exists?: "$RED"NO (!)"$RESET 
    echo "ore-wallet doesn't exist, thus it is NOT running. Run '$0 start ore-wallet'"$RESET
  fi

  echo "${BOLD}${BLUE}=========================${RESET}"

}

# Internal use only
# Used by `ver` to pretty print new commits on origin/master
simplecommitlog() {
  local commit_format;
  local args;
  commit_format=""
  commit_format+="    - Commit %Cgreen%h%Creset - %s %n"
  commit_format+="      Author: %Cblue%an%Creset %n"
  commit_format+="      Date/Time: %Cblue%ai%Creset%n"
  if [[ "$#" -lt 1 ]]; then
    echo "Usage: simplecommitlog branch [num_commits]"
    echo "invalid use of simplecommitlog. exiting"
    exit -1
  fi
  branch="$1"
  args="$branch"
  if [[ "$#" -eq 2 ]]; then
    count="$2"
    args="-n $count $args"
  fi
  git --no-pager log --pretty=format:"$commit_format" $args
}

# Usage: ./run.sh ver
# Displays information about your EOS Docker version, including the docker container
# as well as the scripts such as run.sh. Checks for updates using git and DockerHub API.
#
ver() {
  LINE="==========================="
  ####
  # Update git, so we can detect if we're outdated or not
  # Also get the branch to warn people if they're not on master
  ####
  git remote update >/dev/null
  current_branch=$(git branch | grep \* | cut -d ' ' -f2)
  git_update=$(git status -uno)

  ####
  # Print out the current branch, commit and check upstream 
  # to return commits that can be pulled
  ####
  echo "${BOLD}${BLUE}Current EOS Docker version:${RESET}"
  echo "    Branch: $current_branch"
  if [[ "$current_branch" != "master" ]]; then
    echo "${RED}WARNING: You're not on the master branch. This may prevent you from updating${RESET}"
    echo "${GREEN}Fix: Run 'git checkout master' to change to the master branch${RESET}"
  fi
  # Warn user of modified core files
  git_status=$(git status -s)
  modified=0
  while IFS='' read -r line || [[ -n "$line" ]]; do
    if grep -q " M " <<< $line; then
        modified=1
    fi
  done <<< "$git_status"
  if [[ "$modified" -ne 0 ]]; then
    echo "    ${RED}ERROR: Your EOS Docker core files have been modified (see 'git status'). You will not be able to update."
    echo "    Fix: Run 'git reset --hard' to reset all core files back to their originals before updating."
    echo "    This will not affect your running witness, or files such as config.ini which are supposed to be edited by the user${RESET}"
  fi
  echo "    ${BOLD}${BLUE}Current Commit:${RESET}"
  simplecommitlog "$current_branch" 1
  echo
  echo
  # Check for updates and let user know what's new
  if grep -Eiq "up.to.date" <<< "$git_update"; then
    echo "    ${GREEN}Your EOS Docker core files (run.sh, Dockerfile etc.) up to date${RESET}"
  else
    echo "    ${RED}Your EOS Docker core files (run.sh, Dockerfile etc.) are outdated!${RESET}"
    echo
    echo "    ${BOLD}${BLUE}Updates in the current published version of EOS Docker:${RESET}"
    simplecommitlog "HEAD..origin/master"
    echo
    echo
    echo "    Fix: ${YELLOW}Please run 'git pull' to update your EOS Docker. This should not affect any running containers.${RESET}"
  fi
  echo $LINE
}

# Usage: ./run.sh clean
# Removes blockchain, p2p, and/or shared memory folder contents, with interactive prompts.
#
# Example (delete blockchain+p2p folder contents without asking first):
#     ./run.sh clean
#
sb_clean() {
  msg bold red " !!! Clearing testnet data..."
  case $1 in
    eos)
      ebc_dir="${EOS_DATADIR}/data/blocks"
      ep2p_dir="${EOS_DATADIR}/data/p2p"
      estate_dir="${EOS_DATADIR}/data/state"

      msg yellow " ::::::::::::: EOS :::::::::::::"
      msg yellow " :: Blockchain:           $ebc_dir"
      msg yellow " :: P2P files:            $ep2p_dir"
      msg yellow " :: State files:          $estate_dir"
      msg

      # To prevent the risk of glob problems due to non-existant folders,
      # we re-create them silently before we touch them.
      mkdir -p "$ebc_dir" "$ep2p_dir" "$estate_dir" &> /dev/null
      rm -rfv "$ebc_dir"/*
      rm -rfv "$ep2p_dir"/*
      rm -rfv "$estate_dir"/*
      mkdir -p "$ebc_dir" "$ep2p_dir" "$estate_dir" &> /dev/null
      ;;
    ore)
      obc_dir="${ORE_DATADIR}/data/blocks"
      op2p_dir="${ORE_DATADIR}/data/p2p"
      ostate_dir="${ORE_DATADIR}/data/state"

      msg yellow " ::::::::::::: ORE :::::::::::::"
      msg yellow " :: Blockchain:           $obc_dir"
      msg yellow " :: P2P files:            $op2p_dir"
      msg yellow " :: State files:          $ostate_dir"
      msg

      # To prevent the risk of glob problems due to non-existant folders,
      # we re-create them silently before we touch them.
      mkdir -p "$obc_dir" "$op2p_dir" "$ostate_dir" &> /dev/null
      rm -rfv "$obc_dir"/*
      rm -rfv "$op2p_dir"/*
      rm -rfv "$ostate_dir"/*
      mkdir -p "$obc_dir" "$op2p_dir" "$ostate_dir" &> /dev/null
      ;;
    steem)
      sbc_dir="${STEEM_DATADIR}/data/blockchain"
      sp2p_dir="${STEEM_DATADIR}/data/p2p"

      msg yellow " ::::::::::::: STEEM :::::::::::::"
      msg yellow " :: Blockchain:           $sbc_dir"
      msg yellow " :: P2P files:            $sp2p_dir"
      msg

      # To prevent the risk of glob problems due to non-existant folders,
      # we re-create them silently before we touch them.
      mkdir -p "$sbc_dir" "$sp2p_dir" &> /dev/null
      rm -rfv "$sbc_dir"/*
      rm -rfv "$sp2p_dir"/*
      mkdir -p "$sbc_dir" "$sp2p_dir" &> /dev/null
      ;;
    all)
      msg yellow " ::::::::::::: EOSIO :::::::::::::"
      msg yellow " :: Blockchain:           $ebc_dir"
      msg yellow " :: P2P files:            $ep2p_dir"
      msg yellow " :: State files:          $estate_dir"
      msg

      # To prevent the risk of glob problems due to non-existant folders,
      # we re-create them silently before we touch them.
      mkdir -p "$ebc_dir" "$ep2p_dir" "$estate_dir" &> /dev/null
      rm -rfv "$ebc_dir"/*
      rm -rfv "$ep2p_dir"/*
      rm -rfv "$estate_dir"/*
      mkdir -p "$ebc_dir" "$ep2p_dir" "$estate_dir" &> /dev/null

      msg yellow " ::::::::::::: STEEM :::::::::::::"
      msg yellow " :: Blockchain:           $sbc_dir"
      msg yellow " :: P2P files:            $sp2p_dir"
      msg

      # To prevent the risk of glob problems due to non-existant folders,
      # we re-create them silently before we touch them.
      mkdir -p "$sbc_dir" "$sp2p_dir" &> /dev/null
      rm -rfv "$sbc_dir"/*
      rm -rfv "$sp2p_dir"/*
      mkdir -p "$sbc_dir" "$sp2p_dir" &> /dev/null
      ;;
    *)
      msg bold red "Unrecognized network name. Use [eos|steem]"
      ;;
  esac
  msg bold green " +++ Cleared testnet data"
}

if [ "$#" -lt 1 ]; then
    help
fi

case $1 in
  install_docker)
    install_docker
    ;;
  build)
    build "${@:2}"
    ;;
  buildcontract)
    buildcontract "${@:2}"
    ;;
  bootstrap)
    bootstrap "${@:2}"
    ;;
  deploy)
    deploy "${@:2}"
    ;;
  initcontract)
    initcontract "${@:2}"
    ;;
  cleos)
    cleos "${@:2}"
    ;;
  setcdt)
    setcdt "${@:2}"
    ;;
  start)
    start "${@:2}"
    ;;
  stop)
    stop "${@:2}"
    ;;
  kill)
    sbkill "${@:2}"
    ;;
  restart)
    stop "${@:2}"
    sleep 5
    start "${@:2}"
    ;;
  rebuild)
    stop "${@:2}"
    sleep 5
    build "${@:2}" true
    start
    ;;
  clean)
    sb_clean "${@:2}"
    ;;
  status)
    status "${@:2}"
    ;;
  wallet)
    wallet "${@:2}"
    ;;
  wallet_cmd)
    wallet true "${@:2}"
    ;;
  enter)
    enter "${@:2}"
    ;;
  shell)
    shell "${@:2}"
    ;;
  logs)
    logs "${@:2}"
    ;;
  ver|version)
    ver
    ;;
  help)
    help
    ;;
  *)
    msg red 'error'
    ;;
esac
