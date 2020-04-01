DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $DIR/../../..

git clone git@github.com:CryptoMechanics/ict networks/eos/contracts/ict

cd networks/eos/contracts/ict && git checkout wip-multioracle && cp service/config.json.sample service/config.json

cd $DIR/../../..

./run.sh clean eos
./run.sh clean eos2
./run.sh restart eos
./run.sh bootstrap eos
./run.sh bootstrap eos2
./run.sh deploy eos ict
./run.sh deploy eos2 ict
./run.sh initcontract eos ict
./run.sh initcontract eos2 ict
./run.sh cleos eos transfer producer1 ict "50.0000 EOS" "producer1" -p producer1
./run.sh cleos eos push action ict lock '{"owner":"producer1","beneficiary":"producer1","quantity":"2.0000 EOS","memo":"producer1"}' -p producer1@active
echo "Tokens locked on EOS: Run ICT Oracle to process"
