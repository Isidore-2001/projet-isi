# crypt database file 

function encryptDatabase() {
	# encrypt file
	# $1: file to encrypt
	# $2: password
	# $3: output file
	openssl enc -aes-256-cbc -in $1 -out $3 -k $2
}

function purgeKey {
    rm USB1/key
    rm USB2/key
}

function main() {
	# $1: password
	# $2: database file
	# $3: output file
	encryptDatabase "RAMDISK/databases" "RAMDISK/databases_tmp.crypt" "USB1/key" 
	encryptDatabase "RAMDISK/databases_tmp.crypt" "DISK/databases_encrypt.crypt" "USB2/key"
}
