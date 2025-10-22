#!/bin/bash
LOG_FILE="/var/log/prysm_node_install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

printGreen() {
    echo -e "\033[32m$1\033[0m"
}

printLine() {
    echo "------------------------------"
}

# Function to print the node logo
function printNodeLogo {
    echo -e "\033[32m"
    echo "          
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
██████████████████████████████████████████████        ██████████████████████████████████████████████
███████████████████████████████████████████              ███████████████████████████████████████████
████████████████████████████████████████                    ████████████████████████████████████████
█████████████████████████████████████                          █████████████████████████████████████
█████████████████████████████████                                  █████████████████████████████████
██████████████████████████████             █             █            ██████████████████████████████
████████████████████████████           █████             ████           ████████████████████████████
████████████████████████████          ██████             ██████         ████████████████████████████
████████████████████████████          ██████             ██████          ███████████████████████████
████████████████████████████          ███████            ██████          ███████████████████████████
████████████████████████████          ██████████         ██████          ███████████████████████████
████████████████████████████          █████████████      ██████          ███████████████████████████
████████████████████████████             █████████████     ████          ███████████████████████████
████████████████████████████          █     █████████████     █          ███████████████████████████
████████████████████████████          █████     ████████████             ███████████████████████████
████████████████████████████          ██████       ████████████          ███████████████████████████
████████████████████████████          ██████          █████████          ███████████████████████████
████████████████████████████          ██████             ██████          ███████████████████████████
████████████████████████████          ██████             ██████          ███████████████████████████
████████████████████████████          ██████             ██████         ████████████████████████████
████████████████████████████            ████             ███            ████████████████████████████
██████████████████████████████                                        ██████████████████████████████
█████████████████████████████████                                  █████████████████████████████████
█████████████████████████████████████                           ████████████████████████████████████
████████████████████████████████████████                    ████████████████████████████████████████
███████████████████████████████████████████              ███████████████████████████████████████████
██████████████████████████████████████████████        ██████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
Hazen Network Solutions 2025 All rights reserved."
    echo -e "\033[0m"
}

# Show the node logo
printNodeLogo

# User confirmation to proceed
echo -n "Type 'yes' to start the installation Prysm v0.1.0 and press Enter: "
read user_input

if [[ "$user_input" != "yes" ]]; then
  echo "Installation cancelled."
  exit 1
fi

# Function to print in green
printGreen() {
  echo -e "\033[32m$1\033[0m"
}

printGreen "Starting installation..."
sleep 1

printGreen "If there are any, clean up the previous installation files"

sudo systemctl stop prysmd
sudo systemctl disable prysmd
sudo rm -rf /etc/systemd/system/prysmd.service
sudo rm $(which prysmd)
sudo rm -rf $HOME/.prysm
sed -i "/prysmd_/d" $HOME/.bash_profile

# Update packages and install dependencies
printGreen "1. Updating and installing dependencies..."
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install curl git wget htop tmux build-essential jq make lz4 gcc unzip -y

# User inputs
read -p "Enter your MONIKER: " MONIKER
echo 'export MONIKER='$MONIKER
read -p "Enter your PORT (2-digit): " PORT
echo 'export PORT='$PORT

# Setting environment variables
echo "export MONIKER=$MONIKER" >> $HOME/.bash_profile
echo "export PRYSM_CHAIN_ID=\"prysm-devnet-1\"" >> $HOME/.bash_profile
echo "export PRYSM_PORT=$PORT" >> $HOME/.bash_profile
source $HOME/.bash_profile

printLine
echo -e "Moniker:        \e[1m\e[32m$MONIKER\e[0m"
echo -e "Chain ID:       \e[1m\e[32m$PRYSM_CHAIN_ID\e[0m"
echo -e "Node custom port:  \e[1m\e[32m$PRYSM_PORT\e[0m"
printLine
sleep 1

# Install Go
printGreen "2. Installing Go..." && sleep 1
cd $HOME
VER="1.23.0"
wget "https://golang.org/dl/go$VER.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$VER.linux-amd64.tar.gz"
rm "go$VER.linux-amd64.tar.gz"
[ ! -f ~/.bash_profile ] && touch ~/.bash_profile
echo "export PATH=\$PATH:/usr/local/go/bin:~/go/bin" >> ~/.bash_profile
source $HOME/.bash_profile
[ ! -d ~/go/bin ] && mkdir -p ~/go/bin

# Version check
echo $(go version) && sleep 1

# Download Prysm protocol binary
printGreen "3. Downloading Prysm binary and setting up..." && sleep 1
cd $HOME
rm -rf prysm
git clone https://github.com/kleomedes/prysm prysm
cd prysm
git checkout v0.1.0-devnet
make install

mkdir -p $HOME/.prysm/cosmovisor/genesis/bin
mv $HOME/go/bin/prysm $HOME/.prysmd/cosmovisor/genesis/bin/

sudo ln -s $HOME/.prysm/cosmovisor/genesis $HOME/.prysm/cosmovisor/current -f
sudo ln -s $HOME/.prysm/cosmovisor/current/bin/prysmd /usr/local/bin/prysmd -f



# Create service file
sudo bash -c "cat > /etc/systemd/system/prysmd.service" << EOF
[Unit]
Description=prysm node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.prysm"
Environment="DAEMON_NAME=prysmd"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.prysm/cosmovisor/current/bin"
Environment="LD_LIBRARY_PATH=$HOME/.prysm/lib"

[Install]
WantedBy=multi-user.target
EOF


# Enable the service
sudo systemctl daemon-reload
sudo systemctl enable prysmd

# Initialize the node
printGreen "7. Initializing the node..."
prysmd config set client chain-id ${PRYSM_CHAIN_ID}
prysmd config set client keyring-backend test
prysmd config set client node tcp://localhost:${PRYSM_PORT}657
prysmd init ${MONIKER} --chain-id ${PRYSM_CHAIN_ID}

# Download genesis and addrbook files
printGreen "8. Downloading genesis and addrbook..."
curl -Ls https://raw.githubusercontent.com/hazennetworksolutions/prysm/refs/heads/main/genesis.json > $HOME/.prysm/config/genesis.json
wget -O $HOME/.prysm/config/addrbook.json "https://raw.githubusercontent.com/hazennetworksolutions/prysm/refs/heads/main/addrbook.json"

# Configure gas prices and ports
printGreen "9. Configuring custom ports and gas prices..." && sleep 1
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.00001uprysm\"/" $HOME/.prysm/config/app.toml
sed -i.bak -e "s%:1317%:${PRYSM_PORT}317%g;
s%:8080%:${PRYSM_PORT}080%g;
s%:9090%:${PRYSM_PORT}090%g;
s%:9091%:${PRYSM_PORT}091%g;
s%:8545%:${PRYSM_PORT}545%g;
s%:8546%:${PRYSM_PORT}546%g;
s%:6065%:${PRYSM_PORT}065%g" $HOME/.prysm/config/app.toml

# Configure P2P and ports
sed -i.bak -e "s%:26658%:${PRYSM_PORT}658%g;
s%:26657%:${PRYSM_PORT}657%g;
s%:6060%:${PRYSM_PORT}060%g;
s%:26656%:${PRYSM_PORT}656%g;
s%^external_address = \"\"%external_address = \"$(wget -qO- eth0.me):${PRYSM_PORT}656\"%;
s%:26660%:${PRYSM_PORT}660%g" $HOME/.prysm/config/config.toml

# Set up seeds and peers
printGreen "10. Setting up peers and seeds..." && sleep 1
SEEDS="1b5b6a532e24c91d1bc4491a6b989581f5314ea5@prysm-testnet-seed.itrocket.net:25656"
PEERS="88ad3a3b9b981f0bbb52d5c996d0f7e1aa9426fa@65.108.206.118:61256,ff15df83487e4aa8d2819452063f336269958d09@prysm-testnet-rpc.itrocket.net:25656,01e40fe961c9522936a8bb7ede533198614abf9f@prysm-testnet-rpc.stakerhouse.com:14256,170bf5fa23b18d19148ca9a52dbdde485ad59f7b@65.109.79.185:15656,27354565dd49be9ffaf7fa566b7737e9891baec1@prysm.rpc.t.anode.team:26916"
sed -i -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*seeds *=.*/seeds = \"$SEEDS\"/}" \
       -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*persistent_peers *=.*/persistent_peers = \"$PEERS\"/}" $HOME/.prysm/config/config.toml
sed -i.bak -e "s/^seeds = \"\"/seeds = \"$SEEDS\"/" $HOME/.prysm/config/config.toml
sed -i.bak -e "s/^persistent_peers = \"\"/persistent_peers = \"$PEERS\"/" $HOME/.prysm/config/config.toml

# Pruning Settings
printGreen "12. Setting up pruning config..." && sleep 1
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.prysm/config/app.toml 
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.prysm/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"19\"/" $HOME/.prysm/config/app.toml

# Download the snapshot
# printGreen "12. Downloading snapshot and starting node..." && sleep 1





# Start the node
printGreen "13. Starting the node..."
sudo systemctl start prysmd

# Check node status
printGreen "14. Checking node status..."
sudo journalctl -u prysmd -f -o cat

# Verify if the node is running
if systemctl is-active --quiet prysmd; then
  echo "The node is running successfully! Logs can be found at /var/log/prysm_node_install.log"
else
  echo "The node failed to start. Logs can be found at /var/log/prysm_node_install.log"
fi
