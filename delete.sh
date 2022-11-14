#/bin/bash
wg-quick down kz
ip -4 route delete 172.16.0.0/12 via 172.17.203.254 dev ens160
arr=()
while IFS= read -r line; do
   arr+=("$line")
done < /root/routes

for ((i=0;i<${#arr[@]};i++))
do
 ip -4 route del ${arr[$i]} via 172.17.203.254 dev ens160
done
