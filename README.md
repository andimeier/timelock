Timelock
========

Encrypts a file for a specified time span. It is not possible to decrypt the file before the specified time has elapse since the key is generated dynamically and held only in memory as long as the script is running.

If the script is stopped, there is no possibility to recover the encrypted file.

Usage
-----

    timelock FILE TIME

	Parameters:
      FILE ... File to be encrypted temporarily
      TIME ... amount of time before automatically decrypting the file
               format: 1h30m10s or 10s or 10m or ...
