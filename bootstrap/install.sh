sudo apt update
sudo apt full-upgrade -y
sudo apt install -y git


# install naspi scripts
# ---------------------
# https://wiki.geekworm.com/XScript
cd ~
sudo echo "dtoverlay=pwm-2chan" >> "/boot/config.txt"
git clone https://github.com/geekworm-com/xscript
cd xscript
chmod +x *.sh

# install the x-c1-fan service
sudo cp -f ./x-c1-fan.sh                /usr/local/bin/
sudo cp -f ./x-c1-fan.service           /lib/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable x-c1-fan
sudo systemctl start x-c1-fan

# install the x-c1-pwr service
sudo cp -f ./x-c1-pwr.sh                /usr/local/bin/
sudo cp -f x-c1-pwr.service             /lib/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable x-c1-pwr
sudo systemctl start x-c1-pwr

# Prepair software shutdown script
sudo cp -f ./x-c1-softsd.sh             /usr/local/bin/

# create alis for software shutdown
sudo echo "alias xoff='sudo /usr/local/bin/x-c1-softsd.sh'" > /etc/profile.d/custom-aliases.sh
sudo chmod 777 /etc/profile.d/custom-aliases.sh


# install docker
# https://docs.docker.com/engine/install/raspberry-pi-os/
# --------------
cd ~
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

sudo apt-get update 
sudo apt-get install ca-certificates curl gnupg

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/raspbian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/raspbian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x  /usr/local/bin/docker-compose
