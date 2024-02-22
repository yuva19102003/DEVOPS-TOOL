


sudo apt get update -y
sudo apt install wget -y


sudo wget https://golang.org/dl/go1.22.0.linux-amd64.tar.gz

sha256sum go1.22.0.linux-amd64.tar.gz

sudo tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz

sudo chown -R root:root /usr/local/go

mkdir -p $HOME/go/{bin,src}

cat profile.txt >> ~/.profile

. ~/.profile

echo $PATH

go version
