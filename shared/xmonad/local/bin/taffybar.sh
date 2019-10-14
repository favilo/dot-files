#!/usr/bin/env bash

pushd ~/.config/taffybar
stack build --executable-profiling --library-profiling --ghc-options="-fprof-auto -rtsopts"
stack exec --profile -- my-taffybar +RTS -hd  -p -RTS
