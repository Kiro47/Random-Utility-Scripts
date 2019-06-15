#!/bin/bash

# Fill me in please
DESTINATION_EMAIL="no@u"

### STATICS
DAT_DIR="/root/sendmail/"
DAT_FILE="IP_Update_mailer.dat"
HOSTNAME="$(hostname)"

### Load Dynamic Data
# Get public routing interface
PRIM_NIC="$(ip route get 8.8.8.8 | cut -d $'\n' -f 1 | cut -d ' ' -f 5)"
# Get local ip address
LOCAL_IPV4="$(ip addr show "$PRIM_NIC" | grep -Po 'inet \K[\d.]+')"
# Get public facing IPV4 address
PUBLIC_IPV4="$(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'"' '{ print $2}')"

# Loaded Data
DAT_PRIM_NIC="t"
DAT_LOCAL_IPV4="t"
DAT_PUBLIC_IPV4="t"
### Utility functions

# Write data file
INTERNAL_FUNC_UPDATE_DAT ()
{ 
cat << __EOF__ > "${DAT_DIR}${DAT_FILE}"
PRIM_NIC:${PRIM_NIC}
LOCAL_IPV4:${LOCAL_IPV4}
PUBLIC_IPV4:${PUBLIC_IPV4}
__EOF__
}

# Loads data file to global vars
INTERNAL_FUNC_LOAD_DAT ()
{
	trap 'rm -rf ' EXIT; TMPPIPEDIR=$(mktemp -d); mkfifo "$TMPPIPEDIR"/TMPPIPE


        OLD_IFS=$IFS
        while IFS= read -r line
        do
                # key pair split
                FIELD="$(echo "$line" | cut -d ':' -f 1 )"
                VALUE="$(echo "$line" | cut -d ':' -f 2 )"

                # pair assignment
                echo "export DAT_${FIELD}=${VALUE}" >> "$TMPPIPEDIR/TMPPIPE" &


        done < "${DAT_DIR}${DAT_FILE}"
        IFS="$OLD_IFS"

	source "$TMPPIPEDIR/TMPPIPE"
}

# Sends mail
INTERNAL_FUNC_SENDMAIL()
{
	MSG_CONTENT="Subject: Networking Update for $HOSTNAME



	$(date)

	PRIMARY_NIC: ${PRIM_NIC}
	LOCAL_IPV4: ${LOCAL_IPV4}
	PUBLIC_IPV4: ${PUBLIC_IPV4}

	SERVICE_INFO:
	$(systemctl status ssh)

	DISK STATS:
	$(df -h)
"

echo "$MSG_CONTENT" | ssmtp "$DESTINATION_EMAIL"

}

# Check for changes

# Check if dat file exists.
if [ ! -f "$DAT_FILE" ]; then
	echo "No dat file...creating"
	mkdir --parents "$DAT_DIR"
	INTERNAL_FUNC_UPDATE_DAT
	INTERNAL_FUNC_SENDMAIL
	exit 47
else
	# Load data config
	INTERNAL_FUNC_LOAD_DAT
	# Verify
fi
if [ "$DAT_PRIM_NIC" != "$PRIM_NIC" ]; then
	INTERNAL_FUNC_UPDATE_DAT
	INTERNAL_FUNC_SENDMAIL
	exit 1
elif [ "$DAT_LOCAL_IPV4" != "$LOCAL_IPV4" ]; then
	INTERNAL_FUNC_UPDATE_DAT
	INTERNAL_FUNC_SENDMAIL
	exit 2
elif [ "$DAT_PUBLIC_IPV4" != "$PUBLIC_IPV4" ]; then
	INTERNAL_FUNC_UPDATE_DAT
	INTERNAL_FUNC_SENDMAIL
	exit 3
else
	# Everything is normal
	# nothing has changed
	exit 0
fi
