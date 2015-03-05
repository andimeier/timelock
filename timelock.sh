#!/bin/bash
#
# kopiert ein File auf einen Remote-Server und startet lokal wie remote
# das selbe Programm: das angegebene File wird verschluesselt und erst 
# nach der angegebenen Zeit wieder entschlüsselt. Dazwischen ist der
# Encryption-Key (zufaellig erzeugt) nur im Memory. Eine reelle Chance, das
# wieder zureckzuerhalten, gibt es also praktisch nur nach dem Zeitablauf.
#
# Das Kopieren auf den remote-Server und das temporaere Verschluesseln dort
# mit der selben Methode soll ein Backup sein. Fall lokal das Programm abstuerzt
# oder sonst irgendetwas passiert, wird wenigstens remote nach dem Zeitablauf 
# ebenfalls das Originalfile wiederhergestellt.
#
# Usage:
#   timelock FILE TIME
# Parameters:
#   FILE ... File to be encrypted temporarily
#   TIME ... amount of time before automatically decrypting the file


SCP_TARGET=fritz@eck-zimmer.at:/home/fritz


function printUsage {
	cat <<EOT
Usage:
  timelock FILE TIME 
Parameters:
  FILE ... File to be encrypted temporarily
  TIME ... amount of time before automatically decrypting the file
           format: 1h30m10s or 10s or 10m or ...
EOT
	exit 0
}

if [ "$1" == "" ] ; then
	printUsage
fi

# parse command line parameters
FILE=$1
TIME=$2


if [ "$FILE" == "" ] ; then
	echo "File to encrypt not passed"
	exit 1
fi
if [ ! -e $FILE ] ; then
	echo "File not found: $FILE"
	exit 1
fi


if [ "$TIME" == "" ] ; then
	echo "Missing parameter TIME"
	exit 1
fi

PWD=`tr -dc "[:alnum:]" </dev/urandom | head -c 80`
TOKEN=`tr -dc "[:alnum:]" </dev/urandom | head -c 20`

# get number of seconds
SECONDS=`parsetime $2`

if [ "$SECONDS" -eq 0 ] ; then
	echo "Unable to parse timespan"
	exit 1
fi

# copy image file to server, as a backup ;)
REMOTE_FILE=`basename $FILE`
echo "Copying file to remote server ..."
#scp $FILE $SCP_TARGET
echo "File [$REMOTE_FILE] has been copied to $SCP_TARGET ..."
#ssh fritz@eck-zimmer.at "sh -c 'nohup /home/fritz/bin/tempcrypt $REMOTE_FILE $SECONDS $TOKEN >/tmp/tempcrypt.log &2>&1 &'"

echo "Remote encryption initiated."

# encrypt locally
echo "initiating local encryption ..."
tempcrypt $FILE $SECONDS

# after tempcrypt returns, display the file, assuming it is an image file
# show image
#pqiv -f -t $FILE

/cygdrive/c/Program\ Files\ \(x86\)/ACDSee32/ACDSee32.exe $FILE
