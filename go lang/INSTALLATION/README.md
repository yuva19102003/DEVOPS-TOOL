
 # Golang Installation 

## installation command

### download golang tar file

 ```bash
sudo wget https://golang.org/dl/go1.22.0.linux-amd64.tar.gz

 ```

 ```bash
sha256sum go1.22.0.linux-amd64.tar.gz

 ```
### extract the tar file

 ```bash
sudo tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz

 ```
### root access for the folder

 ```bash
sudo chown -R root:root /usr/local/go

 ```

 ```bash
mkdir -p $HOME/go/{bin,src}

 ```
### set environment variables for golang

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
### check the version 

 ```bash
go version
 ```
----
 
## script mode :


```bash
wget https://github.com/yuva19102003/DEVOPS-TOOL/raw/master/go%20lang/INSTALLATION/installation.zip
 ```
```bash
unzip installation.zip
```

```bash
cd installation
```
```bash
./golang-install.sh
```
 ```bash
go version
 ```

----
