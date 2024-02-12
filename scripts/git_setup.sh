echo "[git setup] ssh key generating"	
ssh-keygen -t rsa -b 4096 -C "m@omuomugin.com"	

echo "[git setup] ssh key copied to clipboard"	
pbcopy < ~/.ssh/id_rsa.pub