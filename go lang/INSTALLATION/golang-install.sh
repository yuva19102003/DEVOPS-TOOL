


sudo apt get update -y
sudo apt install wget -y


sudo wget https://golang.org/dl/go1.22.0.linux-amd64.tar.gz

sha256sum go1.22.0.linux-amd64.tar.gz

sudo tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz

sudo chown -R root:root /usr/local/go

mkdir -p $HOME/go/{bin,src}

echo "export GOPATH=$HOME/go" >> ~/.profile
echo "export PATH=$PATH:$GOPATH/bin" >> ~/.profile
echo "export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin" >> ~/.profile

sudo . ~/.profile

echo $PATH

go version