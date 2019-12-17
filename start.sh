#!/usr/bin/env bash

path="-b "$(pwd)
net="--testnet"
rpc="--rpclisten 127.0.0.1:1234 --rpcuser test --rpcpass test"
p2p="--listen 127.0.0.1:2234"
connect="--connect 127.0.0.1:2234"

./qitmeer $path $net $p2p $rpc $connect "$@"

