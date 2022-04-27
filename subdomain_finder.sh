#!/usr/bin/bash

url=$1

if [ "$url" != "" ];then


if [ ! -d "$url" ];then
	mkdir $url
fi

if [ ! -d "$url/recon" ];then
	mkdir $url/recon
fi

echo -e "\e[32m[+] Harvesting subdomains with assetfinder... \e[0m"
assetfinder $url >> $url/recon/assets.txt

echo -e "\e[32m[+] Sorting output... \e[0m"
cat $url/recon/assets.txt | sort | uniq -u >> $url/recon/sub_domains.txt

sleep 2

echo -e "\e[32m[+] Cleaning up... \e[0m"
rm $url/recon/assets.txt

sleep 2
echo -e "\e[31m[+] Find output in $url/recon/sub_domains.txt \e[0m"

else
	echo -e "\e[31m[-] Enter subdomain to lookup \e[0m"
	echo "Usage: ./subdomain_finder.sh <domain_name>"
	echo "Example: ./subdomain_finder.sh tesla.com"
fi