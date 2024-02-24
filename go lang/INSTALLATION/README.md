
 # Golang Installation 
 ```bash
sudo wget https://golang.org/dl/go1.22.0.linux-amd64.tar.gz

 ```

 ```bash
sha256sum go1.22.0.linux-amd64.tar.gz

 ```

 ```bash
sudo tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz

 ```

 ```bash
sudo chown -R root:root /usr/local/go

 ```

 ```bash
mkdir -p $HOME/go/{bin,src}

 ```

 ```bash
nano ~/.profile
 ```

 ```bash
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin
 ```

 ```bash
. ~/.profile
 ```

 ```bash
echo $PATH
 ```

 ```bash
go version
 ```
