# biff
## see also https://github.com/BurntSushi/biff
BIFF_VERSION="0.1.0"
BIFF_FILE_BASENAME="biff-${BIFF_VERSION}-aarch64-apple-darwin"
BIFF_FILENAME="${BIFF_FILE_BASENAME}.tar.gz"

curl -L -o biff.tar.gz "https://github.com/BurntSushi/biff/releases/download/${BIFF_VERSION}/${BIFF_FILENAME}"
tar -xzf biff.tar.gz

sudo mv ${BIFF_FILE_BASENAME}/biff /usr/local/bin/

rm -rf ${BIFF_FILE_BASENAME} biff.tar.gz

echo "biff installed"
