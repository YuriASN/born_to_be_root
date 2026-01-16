# ***BORN TO BE ROOT***

This file will go step by step on how to create a virtual machine under specifics rules.  

### Topic:

1.	[Creating a Virtual Machine](#creating-a-virtual-machine)  

2.	[Installing OS](#installing-os)  
	- [Bonus Partitions](#the-following-goes-for-bonus-partitions)  

3.	[Configurating the Virtual Machine](#configurating-the-virtual-machine)  
	- [Update package index and Upgrade them](#update-package-index-and-upgrade-them)  
	- [Aptitude install](#aptitude-install)  
	- [Sudo install and config](#sudo-install-and-config)  
	- [Setup password policy](#setup-password-policy)  
	- [Firewall](#firewall)  
	- [SSH](#ssh)  
	- [Monitoring info](#monitoring-info)  

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

3.	Hostname: "...must be your login ending with 42..."  
	Domain name: N/A.  
	Set users and passwords  
	...  
	Timezone  

## The following goes for **Bonus partitions**.

1.	Manual Partition.  
```bash
	Select disk -> "create new empty partition on this device?" -> YES  
	/boot  
	pri/log  
	Create a new partition  
	500M  
	Primary  
	Beginning  
	Mount point  
	/boot  
	Done  
```

2.	Create new partition  
```bash
	pri/log  
	Create a new partition  
	"max"  
	Logical  
	Mount Point -> Do not mount it  
	Done  
```

3.	Configure encrypted volumes  
```bash
	Yes  
	Create encrypted volumes  
	/dev/sda5  
	Done  
	Finish  
	Erase data? -> YES  
	Set password  
```

4.	Configure the Logical Volume Manager  
```bash
	Yes
	Create volume group
	LVMGroup
	/dev/mapper/sda5_crypt
	Create logical volume
	root, swap, home, var, srv, tmp, var-log.
```
5.	Select partitions and place them as:  

| Partition | Type | Mounting location |
| :--- | :--- | :--- |
| home		|	Ext4		|	/home |
| root		|	Ext4		|	/ |
| srv		|	Ext4		|	/srv |
| swap		|	swap area	|	N/A |
| tmp		|	Ext4		|	/tmp |
| var		|	Ext4		|	/var |
| var-log	|	Ext4		|	/var/log |

6.	Finish...  
	`YES`

7. Scan extra media?  
	`NO`

8.	Proxy -> empty

9.	Unselect all softwares leaving only `Core Debian`.

10.	Install GRUB

#	Configurating the Virtual Machine
**Tip**: *During configuration log as root so you don't have to "***sudo***" every command*.
  

##	Update package index and Upgrade them
```
apt update
apt upgrade
```
  

##	Aptitude install
The following commands install Aptitude, update packages and upgrade packages.
```
apt install aptitude
aptitude update
aptitude safe-upgrade
```
To check if any package is installed run
```
dpkg -l | grep <PACKAGE_NAME>
```
  

##	Sudo install and config

`aptitude install sudo`  
Create group *user42*.  
`sudo addgroup user42`  
Create *\<USERNAME\>*.  
`sudo adduser <USERNAME>`  
Add user to *user42* group.  
`sudo usermod -aG user42 <USERNAME>`  
Add use to *sudo* group.  
`sudo usermod -aG sudo <USERNAME>`  

Set sudo logs location secure path and it's password policies.
```bash
sudo mkdir /var/log/sudo
sudo nano /etc/sudoers.d/sudoconfig
```
Paste the text bellow and save it.
```bash
Defaults    passwd_tries=3
Defaults    badpass_message="You really don't remember it? You only have 3 tries."
Defaults    log_input,log_output
Defaults    logfile="/var/log/sudo/sudo.log"
Defaults    requiretty
Defaults    secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
```
requiretty: Any `sudo` command only works when executed from a terminal. In case you try to run it on a script like cron for example, it won't work.  

  

## Setup password policy
Install the ***Password Quality Check Lib*** to add more options to password policy
```bash
aptitude install libpam-pwquality
```
Edit the file to add the desired policies.
```bash
sudo nano /etc/pam.d/common_password
```
After `retry=3` on the 1st uncommented line add:
```bash
reject_username difok=7 minlen=10 ucredit=-1 lcredit=-1 dcredit=-1 maxrepeat=3 enforce_for_root
```
  

**Policies descriptions**:   

> minlen		= minimum password length.  
minclass	= the minimum number of character types that must be used (i.e., uppercase, lowercase, digits, other).  
maxrepeat	= the maximum number of times a single character may be repeated.  
maxclassrepeat	= the maximum number of characters in a row that can be in the same class.  
lcredit		= maximum number of lowercase characters that will generate a credit.  
ucredit		= maximum number of uppercase characters that will generate a credit.  
dcredit		= maximum number of digits that will generate a credit.  
ocredit		= maximum number of other characters that will generate a credit.  
difok		= the minimum number of characters that must be different from the old password.  
remember	= the number of passwords that will be remembered by the system so that they cannot be used again  
gecoscheck	= whether to check for the words from the passwd entry GECOS string of the user (enabled if the value is not 0)  
dictcheck	= whether to check for the words from the cracklib dictionary (enabled if the value is not 0)  
usercheck	= whether to check if the password contains the user name in some form (enabled if the value is not 0)  
enforcing	= new password is rejected if it fails the check and the value is not 0  
dictpath	= path to the cracklib dictionaries. Default is to use the cracklib default.  

To set expiration dates for new users, or when current users change their password open `login.defs`.

```bash
sudo nano /etc/login.defs
```

Look for ***PASS_MAX_DAYS*** and change to:

```bash
PASS_MAX_DAYS	30
PASS_MIN_DAYS	2
PASS_WARN_AGE	7
```

To set the same config to existing users without changing current password:
```bash
sudo chage --mindays 2 --maxdays 30 --warndays 7 <USERNAME>
```
Check password status with:
```bash
sudo chage --list <USERNAME>
```
  

## Firewall

Install **UFW** and enable it.
```bash
aptitude install ufw
ufw enable
```
Allow connections at **4242 port**.
```bash
ufw allow 4242
```
Check UFW status
```bash
ufw status
```
  

## SSH
Install SSH service.
```bash
aptitude install openssh-server
```

Setup ssh port.
In the `sshd_config`, at **line 13**, uncomment and set the wanted value (`4242`).  
And to disable ssh connection as root, in **line 32** uncomment and set, `PermitRootLogin no`.
```bash
nano /etc/ssh/sshd_config
```
Reboot the system and check changes.
```bash
service ssh status
```
To connect with your virtual machine using ssh:
```bash
ssh <username>@<ip-address>
```
Finish connection with `logout` or `exit`.  
  

## Monitoring info
First create the bash script (check the [monitoring.sh](https://github.com/YuriASN/born_to_be_root/blob/main/monitoring.sh) file).  
And set the schedule for the sript to run with:
```bash
crontab -e
```	
Schedule it for every minute multiple of 10 and 15 seconds after reboot.  
*15 seconds are needed to login as the **crontab** runs as long as server is on, but doesn't show on screen if not logged.*
```bash
@reboot sleep 15 && bash <FILE_PATH>
*/10 * * * * bash <FILE_PATH>
```
You can see more exemples of schedules at [Crontab Guru](https://crontab.guru/crontab.5.html).  
  

**Before delivering your project, don't forget to change the passwords `passwd` of root and your user to follow the new password policy you set.**  
  
*For evaluation's questions you can see this [file](https://github.com/YuriASN/born_to_be_root/blob/main/Evaluation.md).*
