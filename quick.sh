sudo apt update && sudo apt upgrade -y
sudo apt install curl build-essential git wget jq make gcc tmux -y
ver="1.17.5"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
git clone https://github.com/ingenuity-build/interchain-accounts --branch main
cd interchain-accounts
make install
icad init dacxys
wget -qO $HOME/.ica/config/genesis.json "https://raw.githubusercontent.com/ingenuity-build/testnets/main/killerqueen/kqcosmos-1/genesis.json"

SEEDS="66b0c16486bcc7591f2c3f0e5164d376d06ee0d0@65.108.203.151:26656"
sed -i -e "/seeds =/ s/= .*/= \"$SEEDS\"/"  $HOME/.ica/config/config.toml

sudo tee /etc/systemd/system/icad.service > /dev/null <<EOF
[Unit]
Description=icadQuicksilver
After=network-online.target

[Service]
User=$USER
ExecStart=/usr/bin/icad start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable icad
sudo systemctl restart icad
