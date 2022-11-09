# ***Evaluation***
We will use the **sudo** in most commands as we will be logged as our user.

### Topic:

1. [Knowledges](#knowledges)<br>
	- [What is a Virtual Machine](#what-is-a-virtual-machine)<br>
	- [CentOS vs. Debian](#centos-vs-debian)<br>
	- [APT vs. Aptitude](#apt-vs-aptitude)<br>
	- [AppArmor](#apparmor)<br>
2. [Check boot services](#check-boot-services)<br>
3. [Users](#users)<br>
	- [Advantages and disadvantages of a strong password policy](#advantages-and-disadvantages-of-a-strong-password-policy)<br>
	- [Managing Users and Groups](#managing-users-and-groups)<br>
4. [Hostname](#hostname)<br>
5. [LVM](#lvm)<br>
6. [Sudo](#sudo)<br>
7. [UFW](#ufw)<br>
8. [SSH](#ssh)<br>
9. [Cron](#cron)<br>
<br>
<br>

## Knowledges
### What is a Virtual Machine

&emsp;A virtual machine is a *virtual enviroment* inside a phisical computer.<br>
It shares the hardwares of the host computer to it's own use without interfering with host's operational system. That way you can run different OS inside the same machine, work with unsafe files, test applications in a safe and close enviroment.<br>
&emsp;Why don't we always use a virtual machine?<br>
As you have 2 OS running together sharing resources you lose some performance over a single one working.<br>
<br>

### CentOS vs. Debian

&emsp;CentOS and Debian are both used as internet servers or web servers. CentOS being a variant of RedHat Linux while Ubuntu, Kali e etc are variants of Debian.<br>
&emsp;CentOS is more stable as it realeases versions, usually with a 10 years gap between them, however minor updates may happen from time to time. This makes easier for enterprise apllication to run on it, as those applications won't need constant updates to keep up with OS releases.<br>
On the other hand that cause some issues with many application softwares as they change during this time, the lack of compatibility with an *old OS* will force you to use old versions of those, probably leaving you with less resources.<br>
&emsp;Meanwhile Debian usually releases new versions in a 2 years gap and has more packages. That helps solve the issue with applications compatibility, keeping up with recent versions of applications and it's resources.<br>

<br>To see what system is installed run:
```
uname -v
```
<br>

### APT vs. Aptitude

&emsp;Apt or Advanced Packaging Tool is a lower-level package manager that can be used for higher-level managers. Aptitude on the other hand is a high-level package manager that has all functionaties of apt, apt-get, apt-cache and more.<br>
&emsp;It checks for packages dependencies in order to install, remove or solve a conflict while with apt-get you would have to set an option for it. The search command in Aptitude is better than apt, giving you information if the package listed is already installed `i` or just present `p`.<br>
<br>

### AppArmor

&emsp;AppArrmor is a security feature that comes with Debian by default. The program restrict actions processes can take, reducing the chances of software being exploited.<br>
As an example, it will allow a music player to only read and play songs. In case you open a malicious music file it won't be able to affect anything in the system as AppArmor won't give it access to it.<br>

<br>
<br>

## Check boot services
To check if SSH and UFW are running:
```
sudo ufw status
sudo service ssh status
```
<br>
<br>

## Users

### Advantages and Disadvantages of a strong password policy
&emsp;The main advantage of a strong password policy is the security, as it makes harder to hack into or decifre the password.
The use of upper-case letters, numbers and symbols increase it's combinations compared to a simple one with only lower-case letters.<br>
&emsp;On the down side, as a passord gets bigger and more complex, it becomes harder to remember. And depending of how many times we have to use it, it can get annoying to type everything over and over again.<br>
<br>

### Managing Users and Groups
Check the groups a user is in
```
groups <USERNAME>
```
Create a new user
```
sudo adduser <USERNAME>
```
Create a new group
```
sudo addgroup <GROUPNAME>
```
Add a user to a group
```
sudo adduser <USERNAME> <GROUPNAME>
```
Just change `add` for `del` in order to do the opposite of above.<br>
<br>
<br>

## Hostname
Check the hostname of the machine with:<br>
`hostname` or `hostnamectl`.<br>
<br>
Change hostname
```
sudo sed -i 's/<OLDHOST>/<NEWHOST/g' /etc/hostname
sudo sed -i 's/<OLDHOST>/<NEWHOST/g' /etc/hosts
```
Reboot to apply changes.<br>
<br>
<br>

## LVM

### What is it?
&emsp;LVM or *Logical Volume Management* is a program that manages filesystems.<br>
LVM manages Volume Groups, Physical Volumes and Logical Volumes.<br>
&emsp;- A *Volume Group* is a named collection of physical and logical volumes.<br>
&emsp;- *Physical Volumes* correspond to disks.<br>
&emsp;- *Logical volumes* correspond to partitions. Unlike partitions though, logical volumes get names rather than numbers, they can span across multiple disks, and do not have to be physically contiguous.<br>
&emsp;You can resize partitions shrinking or expanding it, using one or multiple *physical volumes* on the same *volume group* for the same partition. Move them between disk while using the system.<br>
&emsp;LVM can take snapshots of your disk. Meaning that when you take a snapshot of a logical volume and write any data on it, it will save the previous data written on that block and preserve it until the snapshot volume is deleted. You can mount and use the snapshot volume to make tests on it or just use it as a back up.<br>
<br>

To list all partitions run:
```
lsblk
```
<br>
<br>

## Sudo

### What is SUDO?
&emsp;Sudo (from, "**s**ubistitute **u**ser, **do**") is a program that enables users to run a command as other user (root by default).<br>
This give a user access to commands that only the super-user aka root, is able to use. Rules can be applied to enforce security of commands or directories where sudo can be used.<br>
Ex.: `ls /root` won't work without root permissions but will work if you add `sudo`.<br>
<br>

### Commands
Check sudo installation
```
sudo -V
```
Add new user to sudo group
```
sudo adduser <NEWUSER> sudo
```
To check configuration and available commands for the current user, run
```
sudo -l
```
To see other user's permissions add `-U <USERNAME>` to the same command above.<br>
<br>
<br>

## UFW

### What is UFW?
&emsp;UFW or Uncomplicated Firewall is a program that manages netfilter. It allows to allow or deny connections to ports, create logs, especify rules for connections.<br>
&emsp;You can specify the direction a port is open, source and destination adresses, as well as deny it. It supports connection rate limit, that is helpful to protect against brute-force login attacks.<br>
<br>

### Commands
Check if it is installed
```
ufw --version
```
Check it's status
```
sudo ufw status
```
Open ports
```
sudo ufw allow <PortNumber>
```
Disable ports
```
sudo ufw status numbered
sudo ufw delete <RuleNumber>
```
<br>
<br>

## SSH

### What is SSH?

&emsp;SSH or Secure Socket Shell, is a network protocol that gives users a secure way to access a computer using a usecured network.<br>
&emsp;It uses a password and public key authenticantions to provide a encripted connection to a computer, allowing then to execute commands and move files between them.<br><br>

### Commands
Check installation
```
ssh -V
```
Check status
```
sudo service ssh status
```
Log into Newuser
```
ssh <NEWUSER>@<ip-address>
```
To finish connection run `exit` or `logout`.<br>
<br>
<br>

## Cron

### What is Cron?
&emsp;Cron is program that's made for scheduling tasks to be executed periodically.<br>
&emsp;Every minute cron searches for `crontab` files that contains instructions to run commands under the user who owns that file. When it's time for a task it runs the scheduled command.<br>
The tasks are scheduled as: ` <minute> <hour> <day-of-month> <month> <day-of-week>	<command> `.
<br>See the example below.
```
11 23 3 4 5	echo "Runs every Friday that is 3rd of the April at 23:11."
```
In the place of the numbers you can use `*` for *every*. If you replace *3, 4 and 5* with * it will run everyday at 23:11.<br>
The use of `*/N` works as multiples of *N*. `*/5 * * * SUN` runs every 5 minutes during every sunday.
<br>

### How to start and stop a cron job
```
sudo service cron start
sudo service cron stop
sudo service cron restart
```
<br>

To list current user's crontab run `crontab -l`.
