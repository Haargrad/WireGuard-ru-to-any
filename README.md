
![123 (1)](https://user-images.githubusercontent.com/61315483/201335367-006478cb-d75b-44ce-93a1-e83b57090405.jpg)

### Create WireGuard VPN only for foreign sites

#### 1. Install wireguard on router A and B

```bash
sudo apt update && sudo apt upgrade -y
```

```bash
curl -O https://raw.githubusercontent.com/angristan/wireguard-install/master/wireguard-install.sh
sudo  chmod +x wireguard-install.sh
sudo ./wireguard-install.sh
```

#### 2. Creating a script with automatic connection and adding routes for networks in the .RU segment

connect.sh script description

iptables -t nat -A POSTROUTING -j MASQUERADE #enabling NAT

echo nameserver 1.1.1.1 > /etc/resolv.conf #add nameserver

curl https://ipv4.fetus.jp/ru.txt > ru.txt #get a list of ip addresses in russia

tail -n +12 /root/ru.txt > /root/routes #trim the extra 12 lines

ip -4 route add 172.16.0.0/12 via 172.17.203.254 dev ens160 #add default route for all local networks

wg-quick up kz #enable wireguard

arr=() #add all routes in Russia

while IFS= read -r line; do

   arr+=("$line")

done < /root/routes

for ((i=0;i<${#arr[@]};i++))

do

 ip -4 route add ${arr[$i]} via 172.17.203.254 dev ens160

done

#### 3. Create systemd unit 

```bash
vi /etc/systemd/system/kzwg.service
```

```bash
[Unit]
Description=service for WG-vpn
After=multi-user.target

[Service]
Type=simple
ExecStart=/bin/bash /root/connect.sh

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl enable --now wg.service
```

#### you can use delete.sh to remove all routes and settings

