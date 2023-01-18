# git clone https://github.com/inconshreveable/ngrok.git
cp ssl.sh ngrok  
cd ngrok  
export NGROK_DOMAIN="ngrok.abc.com"
sh ssl.sh
cp base.pem assets/client/tls/ngrokroot.crt
GOOS=linux GOARCH=amd64
make release-server release-client

