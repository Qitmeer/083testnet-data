TAR=qitmeer-0.8.3-darwin-amd64.tar.gz
if [ ! -e ./$TAR ]; then
  wget https://github.com/Qitmeer/qitmeer/releases/download/v0.8.3.1/$TAR
  tar xvf $TAR 
  echo download qitmeer ok
fi
if [ ! -e ./qitmeer ]; then
  ln -s build/release/darwin/amd64/bin/qitmeer 
  echo install qitmeer executble ok 
else
  echo find qitmeer executble ok 
fi

if [ ! -e ./testnet ]; then
  cat testnet0.8.3.part-*|tar xv
else
  echo find ./testnet ok
fi

