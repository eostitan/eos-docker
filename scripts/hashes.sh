#!/bin/bash

cleos push action delphioracle reguser '{"owner":"producer1"}' -p producer1
cleos push action delphioracle writehash '{"owner":"producer1","hash":"0a3a3c2576f6dcda223b04cd80017d78924ed32f86d189c61b1680f059e818b8","reveal":""}' -p producer1
sleep 60
cleos push action delphioracle writehash '{"owner":"producer1","hash":"20e66721dfac88e8def3594f0405feedb07f2b652d1996bd9df55ca4865555d3","reveal":"newhash"}' -p producer1
sleep 60
cleos push action delphioracle writehash '{"owner":"producer1","hash":"e87d2b3194607f1769e5fb69dcba8542676f6a79bed397fff46b8a926e1575ca","reveal":"newhash2"}' -p producer1
sleep 60
cleos push action delphioracle writehash '{"owner":"producer1","hash":"a178b5c1065911a3bba8675e83ae24158234542de02840382b046bd4edf73c48","reveal":"newhash3"}' -p producer1
cleos get table delphioracle delphioracle stats
