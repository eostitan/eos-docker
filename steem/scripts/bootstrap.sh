#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Testnet Accounts Key Pair
# {
#   "brain_priv_key": "DESMA MASCLED MIDPIT TOWNISH EMBRYO HASSEL LAMBER ELUVIAL KNIAZI TUNU APHYRIC LINDEN CALLUS OPTION CACAM PIOTTY",
#   "wif_priv_key": "5J6RZBK9XRBPhQnPAbACVgMNUCwg6n5vQqYQDhSDGURJ32bd8qM",
#   "pub_key": "TST5kxr2ptyn6RX8T7bnAWAZdrbpTXwbFP3Q7UKL5oxkqN4mGHtr6"
# }

curl --data-binary '{"id":"2","method":"unlock","params":["master"]}' http://127.0.0.1:8091
curl --data-binary '{"id":"2","method":"import_key","params":["5J6RZBK9XRBPhQnPAbACVgMNUCwg6n5vQqYQDhSDGURJ32bd8qM"]}' http://127.0.0.1:8091

# Create accounts
curl --data-binary '{"id":"2","method":"create_account_with_keys","params":["initminer","tester1","","TST5kxr2ptyn6RX8T7bnAWAZdrbpTXwbFP3Q7UKL5oxkqN4mGHtr6","TST5kxr2ptyn6RX8T7bnAWAZdrbpTXwbFP3Q7UKL5oxkqN4mGHtr6","TST5kxr2ptyn6RX8T7bnAWAZdrbpTXwbFP3Q7UKL5oxkqN4mGHtr6","TST5kxr2ptyn6RX8T7bnAWAZdrbpTXwbFP3Q7UKL5oxkqN4mGHtr6",true]}' http://127.0.0.1:8091
curl --data-binary '{"id":"2","method":"create_account_with_keys","params":["initminer","tester2","","TST5kxr2ptyn6RX8T7bnAWAZdrbpTXwbFP3Q7UKL5oxkqN4mGHtr6","TST5kxr2ptyn6RX8T7bnAWAZdrbpTXwbFP3Q7UKL5oxkqN4mGHtr6","TST5kxr2ptyn6RX8T7bnAWAZdrbpTXwbFP3Q7UKL5oxkqN4mGHtr6","TST5kxr2ptyn6RX8T7bnAWAZdrbpTXwbFP3Q7UKL5oxkqN4mGHtr6",true]}' http://127.0.0.1:8091
curl --data-binary '{"id":"2","method":"create_account_with_keys","params":["initminer","tester3","","TST5kxr2ptyn6RX8T7bnAWAZdrbpTXwbFP3Q7UKL5oxkqN4mGHtr6","TST5kxr2ptyn6RX8T7bnAWAZdrbpTXwbFP3Q7UKL5oxkqN4mGHtr6","TST5kxr2ptyn6RX8T7bnAWAZdrbpTXwbFP3Q7UKL5oxkqN4mGHtr6","TST5kxr2ptyn6RX8T7bnAWAZdrbpTXwbFP3Q7UKL5oxkqN4mGHtr6",true]}' http://127.0.0.1:8091
curl --data-binary '{"id":"2","method":"create_account_with_keys","params":["initminer","eosio.ict","","TST5kxr2ptyn6RX8T7bnAWAZdrbpTXwbFP3Q7UKL5oxkqN4mGHtr6","TST5kxr2ptyn6RX8T7bnAWAZdrbpTXwbFP3Q7UKL5oxkqN4mGHtr6","TST5kxr2ptyn6RX8T7bnAWAZdrbpTXwbFP3Q7UKL5oxkqN4mGHtr6","TST5kxr2ptyn6RX8T7bnAWAZdrbpTXwbFP3Q7UKL5oxkqN4mGHtr6",true]}' http://127.0.0.1:8091

## Power up accounts
curl --data-binary '{"id":"2","method":"transfer_to_vesting","params":["initminer","tester1","100.000 TESTS",true]}' http://127.0.0.1:8091
curl --data-binary '{"id":"2","method":"transfer_to_vesting","params":["initminer","tester2","100.000 TESTS",true]}' http://127.0.0.1:8091
curl --data-binary '{"id":"2","method":"transfer_to_vesting","params":["initminer","tester3","100.000 TESTS",true]}' http://127.0.0.1:8091
curl --data-binary '{"id":"2","method":"transfer_to_vesting","params":["initminer","eosio.ict","100.000 TESTS",true]}' http://127.0.0.1:8091

## Transfer liquid tokens to accounts
curl --data-binary '{"id":"2","method":"transfer","params":["initminer","tester1","100.000 TESTS","bootstrap",true]}' http://127.0.0.1:8091
curl --data-binary '{"id":"2","method":"transfer","params":["initminer","tester2","100.000 TESTS","bootstrap",true]}' http://127.0.0.1:8091
curl --data-binary '{"id":"2","method":"transfer","params":["initminer","tester3","100.000 TESTS","bootstrap",true]}' http://127.0.0.1:8091
curl --data-binary '{"id":"2","method":"transfer","params":["initminer","eosio.ict","100.000 TESTS","bootstrap",true]}' http://127.0.0.1:8091
