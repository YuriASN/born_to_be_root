# ***BORN TO BE ROOT***

This file will go step by step on how to create a virtual machine under specifics rules.</br>

### Topic:

1.	[Creating a Virtual Machine](#creating-a-virtual-machine)</br>

2.	[Installing OS](#installing-os)</br>
	- [Bonus Partitions](#the-following-goes-for-bonus-partitions)</br>

3.	[Configurating the Virtual Machine](#configurating-the-virtual-machine)</br>
	- [Update package index and Upgrade them](#update-package-index-and-upgrade-them)</br>
	- [Aptitude install](#aptitude-install)</br>
	- [Sudo install and config](#sudo-install-and-config)</br>
	- [Setup password policy](#setup-password-policy)</br>
	- [Firewall](#firewall)</br>
	- [SSH](#ssh)</br>
	- [Monitoring info](#monitoring-info)</br>

#	Creating a Virtual Machine.

1.	Create new VM, name it, and select appropriate OS.

2.	Select RAM size to be used (minimmum 1Gb).

3.	Create a new Virtual Hard Disk as VDI and Dynamically allocated size.

### Load the Debian Image to the VM.

1.	Settings -> Storage

2.	Under "Controller: IDE" select the disk and open the OS iso file.

# Installing OS.

Run the Virtual Machine

1.	Select `Install`.

2.	Select Language, Location and Keyboard.

3.	Hostname: "...must be your login ending with 42..."<br/>
	Domain name: N/A.<br/>
	Set users and passwords<br/>
	...<br/>
	Timezone<br/>

## The following goes for **Bonus partitions**.

1.	Manual Partition.<br/>
	Select disk -> "create new empty partition on this device?" -> YES<br/>
	/boot<br/>
	pri/log<br/>
	Create a new partition<br/>
	500M<br/>
	Primary<br/>
	Beginning<br/>
	Mount point<br/>
	/boot<br/>
	Done<br/>

2.	Create new partition<br/>
	pri/log<br/>
	Create a new partition<br/>
	"max"<br/>
	Logical<br/>
	Mount Point -> Do not mount it<br/>
	Done<br/>

3.	Configure encrypted volumes<br/>
	Yes<br/>
	Create encrypted volumes<br/>
	/dev/sda5<br/>
	Done<br/>
	Finish<br/>
	Erase data? -> YES<br/>
	Set password<br/>

4.	Configure the Logical Volume Manager<br/>
	Yes<br/>
	Create volume group<br/>
	LVMGroup<br/>
	/dev/mapper/sda5_crypt<br/>
	Create logical volume<br/>
	root, swap, home, var, srv, tmp, var-log.<br/>

5.	Select partitions and place them as:<br/>
```
	home #1		|	Ext4		|	/home
	root #1		|	Ext4		|	/
	srv #1		|	Ext4		|	/srv
	swap #1		|	swap area	|	N/A
	tmp #1		|	Ext4		|	/tmp
	var #1		|	Ext4		|	/var
	var-log #1	|	Ext4		|	/var/log
```

6.	Finish...</br>
	<br>YES

7. Scan extra media?<br/>
	NO

8.	Proxy -> empty

9.	Unselect all softwares leaving only `Core Debian`.

10.	Install GRUB

<br><br>
#	Configurating the Virtual Machine
**Tip**: During configuration log as root so you don't have to "***sudo***" every command.
<br><br>

##	Update package index and Upgrade them
```
apt update
apt upgrade
```
<br><br>

##	Aptitude install
Following commands install Aptitude, update packages and upgrade packages.
```
apt install aptitude
aptitude update
aptitude safe-upgrade
```
To check if any package is installed run
```
dpkg -l | grep <PACKAGE_NAME>
```
<br><br>

##	Sudo install and config
Create group ***user42*** and add users to both groups
```
aptitude install sudo
sudo addgroup user42
sudo adduser <USERNAME> sudo
sudo adduser <USERNAME> user42
```
Set sudo logs location secure path and it's password policies.
```
sudo mkdir /var/log/sudo
sudo nano /etc/sudoers.d/sudoconfig
```
Paste the text bellow and save it.
```
Defaults    passwd_tries=3
Defaults    badpass_message="You really don't remember it? You only have 3 tries."
Defaults    log_input,log_output
Defaults    logfile="/var/log/sudo/sudo.log"
Defaults    requiretty
Defaults    secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
```
<br><br>

## Setup password policy
Install the ***Password Quality Check Lib*** to add more options to password policy
```
aptitude install libpam-pwquality
```
Edit the file to add the desired policies.
```
sudo nano /etc/pam.d/common_password
```
After `retry=3` on the 1st uncommented line add:
```
reject_username difok=7 minlen=10 ucredit=-1 lcredit=-1 dcredit=-1 maxrepeat=3 enforce_for_root
```
</br>

**Policies descriptions**: </br>

> minlen		= minimum password length.<br>
minclass	= the minimum number of character types that must be used (i.e., uppercase, lowercase, digits, other).<br>
maxrepeat	= the maximum number of times a single character may be repeated.<br>
maxclassrepeat	= the maximum number of characters in a row that can be in the same class.<br>
lcredit		= maximum number of lowercase characters that will generate a credit.<br>
ucredit		= maximum number of uppercase characters that will generate a credit.<br>
dcredit		= maximum number of digits that will generate a credit.<br>
ocredit		= maximum number of other characters that will generate a credit.<br>
difok		= the minimum number of characters that must be different from the old password.<br>
remember	= the number of passwords that will be remembered by the system so that they cannot be used again<br>
gecoscheck	= whether to check for the words from the passwd entry GECOS string of the user (enabled if the value is not 0)<br>
dictcheck	= whether to check for the words from the cracklib dictionary (enabled if the value is not 0)<br>
usercheck	= whether to check if the password contains the user name in some form (enabled if the value is not 0)<br>
enforcing	= new password is rejected if it fails the check and the value is not 0<br>
dictpath	= path to the cracklib dictionaries. Default is to use the cracklib default.<br>

Now open `login.defs` to set expiration dates for new users, or when current users change their password.

```
sudo nano /etc/login.defs
```

Look for ***PASS_MAX_DAYS*** and change to:

```
PASS_MAX_DAYS	30
PASS_MIN_DAYS	2
PASS_WARN_DAYS	7
```

To set the same config to existing users without changing current password:
```
sudo chage --mindays 2 --maxdays 30 --warndays 7 <USERNAME>
```
Check password status with:
```
sudo chage --list <USERNAME>
```
<br><br>

## Firewall

If already not installed, install **UFW** and enable it.
```
aptitude install ufw
ufw enable
```
Allow connections at **4242 port**.
```
ufw allow 4242
```
Check UFW status
```
ufw status
```
<br><br>

## SSH
Install SSH service.
```
aptitude install openssh-server
```

Setup ssh port.
In the file below, at **line 13**, uncomment and set the wanted value (4242).<br/>
To disable ssh connection as root, in **line 32** uncomment and set, `PermitRootLogin no`.
```
nano /etc/ssh/sshd_config
```
Reboot the system and check changes.
```
service ssh status
```
To connect with your virtual machine using ssh:
```
ssh <username>@<ip-address>
```
Finish connection with `logout` or `exit`.</br>
<br><br>

## Monitoring info
First create the bash script (check the [monitoring.sh](https://github.com/YuriASN/42/blob/master/42cursus/born2beroot/monitoring.sh) file).</br>
Opens the file to schedule the desired command:
```
crontab -e
```	
Schedule it for every minute multiple of 10 and 15 seconds after reboot.</br>
15 seconds are needed to login as the crontab runs before it.
```
@reboot sleep 15 && bash <FILE_PATH>
*/10 * * * * bash <FILE_PATH>
```
You can see more exemples of schedules at [Crontab Guru](https://crontab.guru/crontab.5.html).<br>
<br>
*For evaluation's questions you can see this [file](https://github.com/YuriASN/42/blob/master/42cursus/born2beroot/Evaluation.md).*
