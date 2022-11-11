#/bin/bash
iptables -t nat -A POSTROUTING -j MASQUERADE
echo nameserver 1.1.1.1 > /etc/resolv.conf
curl https://ipv4.fetus.jp/ru.txt > ru.txt
tail -n +12 /root/ru.txt > /root/routes
ip -4 route add 172.16.0.0/12 via 172.17.203.254 dev ens160
wg-quick up kz
arr=()
while IFS= read -r line; do
   arr+=("$line")
done < /root/routes

for ((i=0;i<${#arr[@]};i++))
do
 ip -4 route add ${arr[$i]} via 172.17.203.254 dev ens160
done