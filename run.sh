#!/usr/bin/env bash
#
# EOS Docker node manager
# Released under MIT by @netuoso
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
: ${DOCKER_DIR="$DIR/Dockerfiles"}
: ${EOSIO_DATADIR="$DIR/eosio"}
: ${STEEM_DATADIR="$DIR/steem"}

# the tag to use when running/replaying eosio
: ${DOCKER_IMAGE="eosio-testnet"}

BOLD="$(tput bold)"
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
MAGENTA="$(tput setaf 5)"
CYAN="$(tput setaf 6)"
WHITE="$(tput setaf 7)"
RESET="$(tput sgr0)"
: ${DK_TAG="eostitan/eosio:latest"}
# Amount of time in seconds to allow the docker container to stop before killing it.
# Default: 60 seconds (1 minutes)
: ${STOP_TIME=60}

# Placeholder for custom tag var CUST_TAG (shared between functions)
CUST_TAG="eosio"
# Placeholder for BUILD_VER shared between functions
BUILD_VER=""

# EOSIO Blockchain
: ${EOSIO_BC_FOLDER="$EOSIO_DATADIR/data"}
: ${EOSIO_EXAMPLE_CONF="$EOSIO_DATADIR/configs/config.ini.example"}
: ${EOSIO_EXAMPLE_GENESIS="$EOSIO_DATADIR/configs/genesis.json.example"}
: ${EOSIO_EXAMPLE_LOGGING="$EOSIO_DATADIR/configs/logging.json.example"}
: ${EOSIO_CONF_FILE="$EOSIO_DATADIR/data/config.ini"}
: ${EOSIO_GENESIS_FILE="$EOSIO_DATADIR/data/genesis.json"}
: ${EOSIO_LOGGING_FILE="$EOSIO_DATADIR/data/logging.json"}
# Git repository to use when building EOSIO - containing EOSIO code
: ${EOSIO_SOURCE="https://github.com/eosio/eos.git"}

# Steem Blockchain
: ${STEEM_BC_FOLDER="$STEEM_DATADIR/data"}
: ${STEEM_EXAMPLE_CONF="$STEEM_DATADIR/configs/config.ini.example"}
: ${STEEM_CONF_FILE="$STEEM_DATADIR/data/config.ini"}
# Git repository to use when building Steem - containing steemd code
: ${STEEM_SOURCE="https://github.com/steemit/steem.git"}

# if the eosio config file doesn't exist, try copying the example config
if [[ ! -f "$EOSIO_CONF_FILE" ]]; then
    if [[ -f "$EOSIO_EXAMPLE_CONF" ]]; then
        echo "${YELLOW}File config.ini not found. copying example (eosio)${RESET}"
        cp -vi "$EOSIO_EXAMPLE_CONF" "$EOSIO_CONF_FILE" 
        echo "${GREEN} > Successfully installed example config for eosio node.${RESET}"
        echo " > You may want to adjust this if you're running a witness"
    else
        echo "${YELLOW}WARNING: You don't seem to have a config file and the example config couldn't be found...${RESET}"
        echo "Example Config: $EOSIO_EXAMPLE_CONF"
        echo "Main Config: $EOSIO_CONF_FILE"
    fi
fi

# if the eosio genesis file doesn't exist, try copying the example genesis file
if [[ ! -f "$EOSIO_GENESIS_FILE" ]]; then
    if [[ -f "$EOSIO_EXAMPLE_GENESIS" ]]; then
        echo "${YELLOW}File genesis.json not found. copying example (eosio)${RESET}"
        cp -vi "$EOSIO_EXAMPLE_GENESIS" "$EOSIO_GENESIS_FILE" 
        echo "${GREEN} > Successfully installed example genesis file for eosio node.${RESET}"
    else
        echo "${YELLOW}WARNING: You don't seem to have a genesis file and the example genesis couldn't be found...${RESET}"
        echo "Example Config: $EOSIO_EXAMPLE_GENESIS"
        echo "Main Config: $EOSIO_GENESIS_FILE"
    fi
fi

# if the eosio logging file doesn't exist, try copying the example logging config
if [[ ! -f "$EOSIO_LOGGING_FILE" ]]; then
    if [[ -f "$EOSIO_EXAMPLE_LOGGING" ]]; then
        echo "${YELLOW}File logging.json not found. copying example (eosio)${RESET}"
        cp -vi "$EOSIO_EXAMPLE_LOGGING" "$EOSIO_LOGGING_FILE" 
        echo "${GREEN} > Successfully installed example logging config for eosio node.${RESET}"
    else
        echo "${YELLOW}WARNING: You don't seem to have a logging config file and the example config couldn't be found...${RESET}"
        echo "Example Config: $EOSIO_EXAMPLE_LOGGING"
        echo "Main Config: $EOSIO_LOGGING_FILE"
    fi
fi

# if the steem config file doesn't exist, try copying the example config
if [[ ! -f "$STEEM_CONF_FILE" ]]; then
    if [[ -f "$STEEM_EXAMPLE_CONF" ]]; then
        echo "${YELLOW}File config.ini not found. copying example (seed)${RESET}"
        cp -vi "$STEEM_EXAMPLE_CONF" "$STEEM_CONF_FILE" 
        echo "${GREEN} > Successfully installed example config for seed node.${RESET}"
        echo " > You may want to adjust this if you're running a witness"
    else
        echo "${YELLOW}WARNING: You don't seem to have a config file and the example config couldn't be found...${RESET}"
        echo "${YELLOW}${BOLD}You may want to check these files exist, or you won't be able to launch Steem${RESET}"
        echo "Example Config: $STEEM_EXAMPLE_CONF"
        echo "Main Config: $STEEM_CONF_FILE"
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
    start - starts eosio container
    clean - Remove testnet files
    stop - stops container(s)
    status - show status of eosio container
    restart - restarts container(s)
    install_docker - install docker
    rebuild - builds eosio container(s), and then restarts it
    build - only builds eosio container(s)
    logs - show all logs inc. docker logs, and eosio logs
    wallet - open wallet in the container
    enter - enter a bash session in the currently running container
    shell - launch the eosio container with appropriate mounts, then open bash for inspection
    "
    echo
    exit
}

# Usage: ./run.sh build [network]
# Build the docker images for specified network
#
#   network - specify which network to build network for [eosio/steem]
#
build() {
    fmm="EOSIO Testnet"
    BUILD_MSG=" >> Building docker container [[ ${fmm} ]]"
    msg bold green "$BUILD_MSG"
    cd "$DOCKER_DIR"
    case $1 in
      eosio)
        docker-compose build
        ;;
      steem)
        msg bold red " !!! Not Yet Implemented"
        (exit 1)
        ;;
    esac
    ret=$?
    if (( $ret == 0 )); then
        msg bold green " +++ Successfully built EOSIO Testnet images"
        msg green " +++ Docker tag: ${DOCKER_IMAGE}"
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
#   network - specify which network to build container for [eosio/steem]
#
bootstrap() {
  case $1 in
    eosio)
      cd "$DIR"
      msg yellow build $1 $2
      bash -c "./scripts/bootstrap.sh $2"
      ;;
    steem)
      msg red Not yet implemented
      ;;
    *)
      msg bold red "Unknown docker image use [eosio/steem]"
      ;;
  esac
}

# Usage: ./run.sh deploy [network] [contract]
# Deploy specified contract to network
#
#   network - specify which network to build container for [eosio/steem]
#   contract - specify which contract to build and deploy
#
deploy() {
    if (( $# >= 1 )); then
      cd "$DIR"
      msg yellow set contract $1
      case $1 in
        delphioracle)
          bash -c "./eosio/scripts/delphi-deploy.sh clone build deploy configure"
          ;;
        eosio.system)
          docker exec -it nodeos cleos --wallet-url http://keosd:8901 set contract eosio /eosio.contracts/build/contracts/eosio.system/ eosio.system.wasm eosio.system.abi -p eosio@active
          ;;
        *)
          msg red Contract not recognized
          ;;
      esac
    fi
}

# Usage: ./run.sh cleos [comamnd]
# Run a cleos command
#
#   command - specify which contract to build and cleos
#
cleos() {
    if (( $# >= 1 )); then
      cd "$DIR"
      msg yellow Execute cleos command: $@
      docker exec -it nodeos cleos --wallet-url http://keosd:8901 $@
    fi
}

# Internal Use Only
# Checks if the container main container exists. Returns 0 if it does, -1 if not.
#
main_exists() {
  ret=$(docker ps -a -f name="nodeos" | wc -l)
  if [[ $ret -eq 2 ]]; then
      return 0
  else
      return -1
  fi
}

# Internal Use Only
# Checks if the container wallet container exists. Returns 0 if it does, -1 if not.
#
wallet_exists() {
  ret=$(docker ps -a -f name="keosd" | wc -l)
  if [[ $ret -eq 2 ]]; then
      return 0
  else
      return -1
  fi
}

# Internal Use Only
# Checks if the container main container exists and is running. Returns 0 if it does, -1 if not.
#
main_running() {
    ret=$(docker ps -f 'status=running' -f name="nodeos" | wc -l)
    if [[ $ret -eq 2 ]]; then
        return 0
    else
        return -1
    fi
}

# Internal Use Only
# Checks if the container wallet container exists and is running. Returns 0 if it does, -1 if not.
#
wallet_running() {
    ret=$(docker ps -f 'status=running' -f name="keosd" | wc -l)
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
    main_exists
    cd "$DOCKER_DIR"
    if [[ "$#" -ge 1 ]]; then
      docker-compose up -d $1
    else
      docker-compose up -d
    fi
}

# Usage: ./run.sh stop
# Stops the Steem container, and removes the container to avoid any leftover
# configuration, e.g. replay command line options
#
stop() {
    msg "If you don't care about a clean stop, you can force stop the container with ${BOLD}./run.sh kill"
    msg red "Stopping network ${1} ... (allowing up to ${STOP_TIME} seconds before killing)..."
    main_exists
    cd "$DOCKER_DIR"
    if [[ "$#" -ge 1 ]]; then
      docker-compose down $1
    else
      docker-compose down
    fi
}

sbkill() {
    msg bold red "Killing network '${1}'..."
    main_exists
    if [[ "$#" -ge 1 ]]; then
        cd "$DOCKER_DIR"
        case $1 in
          eosio)
            docker-compose down -t 1 $2
            ;;
          steem)
            docker run -v "$DATADIR":/steem -d --name $DOCKER_NAME -t "$DOCKER_IMAGE" steemd --data-dir=/steem/witness_node_data_dir
            ;;
          *)
            msg red Unrecognized network name. Use [eosio/steem]
            ;;
        esac
    fi
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
    eosio)
      docker run -v "$EOSIO_DATADIR":/eosio-data --rm -it "eosio-testnet" bash
      ;;
    steem)
      docker run -v "$STEEM_DATADIR":/steemd-data --rm -it "steem-testnet" bash
      ;;
    *)
      msg bold red "Unrecognized network name. Use [eosio/steem]"
      ;;
    esac
}

# Usage: ./run.sh wallet
# Opens cli_wallet inside of the running Steem container and
# connects to the local steemd over websockets on port 8090
#
wallet() {
    docker exec -it "keosd" cleos wallet -u http://nodeos:8888 $@
}

# Usage: ./run.sh logs
# Shows the last 30 log lines of the running steem container, and follows the log until you press ctrl-c
#
logs() {
    msg blue "DOCKER LOGS: (press ctrl-c to exit) "
    main_exists
    cd "$DOCKER_DIR"
    case $1 in
      eosio)
        docker-compose logs -f --tail 30 $2
        ;;
      steem)
        msg red "Not implemented"
        ;;
      *)
        msg bold red "Unrecognized network name. Use [eosio/steem]"
        ;;
    esac
}

# Usage: ./run.sh status
# Very simple status display, letting you know if the container exists, and if it's running.
status() {
    
    echo "${BOLD}${BLUE}========= EOSIO =========${RESET}"

    if main_exists; then
        echo "EOSIO Main exists?: "$GREEN"YES"$RESET
    else
        echo "EOSIO Main exists?: "$RED"NO (!)"$RESET 
        echo "EOSIO Main doesn't exist, thus it is NOT running. Run '$0 build && $0 start'"$RESET
        return
    fi

    if main_running; then
        echo "EOSIO Main running?: "$GREEN"YES"$RESET
    else
        echo "EOSIO Main running?: "$RED"NO (!)"$RESET
        echo "EOSIO Main isn't running. Start it with '$0 start nodeos'"$RESET
        return
    fi

    if wallet_exists; then
        echo "EOSIO Wallet exists?: "$GREEN"YES"$RESET
    else
        echo "EOSIO Wallet exists?: "$RED"NO (!)"$RESET 
        echo "EOSIO Wallet doesn't exist, thus it is NOT running. Run '$0 build && $0 start'"$RESET
        return
    fi

    if wallet_running; then
        echo "EOSIO Wallet running?: "$GREEN"YES"$RESET
    else
        echo "EOSIO Wallet running?: "$RED"NO (!)"$RESET
        echo "EOSIO Wallet isn't running. Start it with '$0 start keosd'"$RESET
        return
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
    bc_dir="${DATADIR}/data/blockchain"
    p2p_dir="${DATADIR}/data/p2p"
    
    # To prevent the risk of glob problems due to non-existant folders,
    # we re-create them silently before we touch them.
    mkdir -p "$bc_dir" "$p2p_dir" &> /dev/null

    msg yellow " :: Blockchain:           $bc_dir"
    msg yellow " :: P2P files:            $p2p_dir"
    msg
    
    msg bold red " !!! Clearing testnet data..."
    rm -rfv "$bc_dir"/*
    rm -rfv "$p2p_dir"/*
    mkdir -p "$bc_dir" "$p2p_dir" &> /dev/null
    msg bold green " +++ Cleared testnet data"

}

if [ "$#" -lt 1 ]; then
    help
fi

case $1 in
    build)
        build "${@:2}"
        ;;
    bootstrap)
        bootstrap "${@:2}"
        ;;
    deploy)
        deploy "${@:2}"
        ;;
    cleos)
        cleos "${@:2}"
        ;;
    install_docker)
        install_docker
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
        stop
        sleep 5
        start
        ;;
    rebuild)
        stop
        sleep 5
        build
        start
        ;;
    clean)
        sb_clean "${@:2}"
        ;;
    status)
        status
        ;;
    wallet)
        wallet "${@:2}"
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
    *)
        msg red 'error'
        ;;
esac
