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

#echo -e "\e[32m[+] Harvesting subdomains with Amass... \e[0m"
#amass enum -d $url >> $url/recon/assets.txt

echo -e "\e[32m[+] Sorting output... \e[0m"
cat $url/recon/assets.txt | sort | uniq >> $url/recon/sub_domains.txt

sleep 2

echo -e "\e[32m[+] Probing for alive domains ---> \e[31mHTTPs\e[0m"
cat $url/recon/sub_domains.txt | httprobe -s -p https:443 | sed 's/\https:\/\///g' | tr -d ':443' | sort >> $url/recon/https_subdomains.txt


echo -e "\e[32m[+] Probing for alive domains ---> \e[31mHTTP\e[0m"
cat $url/recon/sub_domains.txt | httprobe -s -p http:80 | sed 's/\http:\/\///g' | tr -d ':80' | sort >> $url/recon/http_subdomains.txt

echo -e "\e[32m[+] Cleaning and Merging into a single file \e[32m[\e[0m \e[31mhttps and http\e[0m \e[32m]\e[0m"
cat $url/recon/https_subdomains.txt $url/recon/http_subdomains.txt | sort | uniq >> $url/recon/both_http_and_https_subdomains.txt

echo -e "\e[32m[+] Cleaning up... \e[0m"
rm $url/recon/assets.txt
rm $url/recon/sub_domains.txt

sleep 2

echo -e "\e[31m[+] Find output in $url/recon/ \e[0m"

else
	echo -e "\e[31m[-] Enter subdomain to lookup \e[0m"
	echo "Usage: ./subdomain_finder.sh <domain_name>"
	echo "Example: ./subdomain_finder.sh tesla.com"
fi