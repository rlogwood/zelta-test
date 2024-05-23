set -x
rm -fr /usr/local/share/zelta
rm -fr /usr/local/bin/zelta
cd ~/zelta
git pull
git checkout dev
./install.sh
