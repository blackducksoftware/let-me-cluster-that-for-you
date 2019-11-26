./kubectl.sh get ns | grep 0
./kubectl.sh get pods -n `./kubectl.sh get ns | grep 0 | cut -d' ' -f 1`
