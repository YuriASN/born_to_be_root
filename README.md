This project has been created as part of the 42 curriculum by ysantos-

# Born To Be Root

## Description
	A virtual machine is a virtual enviroment inside a phisical computer.  
It shares the hardwares of the host computer to it's own use without interfering with host's operational system. That way you can run different OS inside the same machine, work with unsafe files, test applications in a safe and close enviroment.  
	Why don't we always use a virtual machine?  
As you have 2 OS running together sharing resources, you lose some performance compared to a single one working.  

The goal of this project is to understand what a VirtalMachine is and how to create and configure one. With all the strict rules we had to follow, we also learned the usage and configuration of a few basic services that a VM or server use.  

## Instructions
For the creation of the VM I created another Markdown file ([InstallAndConfig.md](https://github.com/YuriASN/born_to_be_root/blob/main/InstallAndConfig.md)) that you can find on this same repository.  

### Commands
| Action | Command | Explanation |
| :--- |:--- | :--- | 
| Create user		| `sudo adduser <USER_NAME>` | |
| Delete user		| `sudo deluser <USER_NAME>` | *`--remove-home` or *`--remove-all-files`* can be used for complete removal. |
| Create group		| `sudo addgroup <GROUP_NAME>` | |
| Delete group		| `sudo deluser <USER_NAME> <GROUP_NAME>` | |
| Add user to group	| `sudo usermod -aG <GROUP_NAME> <USER_NAME>` | *`-a` Increment a new group. `-G` suplementar groups* |
| Read users		| `getent passwd` | |
| Read groups		| `getent group` | |
| Groups of an user	| `groups <USER_NAME>` | |
| Users of a group	| `getent group <GROUP_NAME>` | |
| Password change	| `passwd <USER_NAME>` | *Without \<UserName> change current user* |
| Hostname change	| `sudo hostnamectl set-hostname <HOST_NAME>` | *Also need to change the hostname on `/etc/hosts`* |
| Read sudo log		| `cat /var/log/sudo/sudo.log` | |
| Cron stop			| `crontab -e` | *Comment line with the task* |
| Installed services| `systemctl list-unit-files --type=service` | |

## Project Description

- **Partitioning**  
	The partitiions were done leaving minnimum for *boot* and *swap*, and splitting the rest between *root* for the file systems and *home* for personal files. The 50/50 division was done as there isn't an idea for what the VM will be used, but the best is to leave more for one or another depending on the usage.  

	The 10Gb were distributed as:  
	| Partition | Size |
	| :-	| :-	|
	| /boot	| 500mb	|
	| root	| Gb	|
	| /home	| Gb	|
	| swap	| 1Gb	|

- **Security Policies**  
	To protect the system many policies were adopted. Starting with a **encrypted disk** volume and a strong **password policy**.  
	For the **sudo** command the authentication try was limited for 3 and a custom message in case of a wrong password error was included and paths that can be used by sudo were restricted. A log file with input and output of every sudo command was created and TTY mode was enabled, avoiding scripts to use *sudo*.  
	The **SSH** connection was configured to deny a connection as root and the *port 4242* was set as default, setting also **UFW** to allow only this port open.  

- **User Management**    
    The project required a strict user and group management system. A user named after the my 42 login was created and added to the groups **user42** and **sudo**, granting administrative privileges.  
    The system implements password aging controls, forcing users to change passwords every 30 days, with a minimum of 2 days between changes and a 7-day warning before expiration.  
    Password quality checks via **libpam-pwquality** enforce strong passwords that must contain at least 10 characters, including uppercase, lowercase, and digits, with no more than 3 consecutive identical characters and at least 7 characters different from the previous password.  
    Users cannot include their username in passwords, and root passwords follow the same strict policies.  

- **Services Installed**  

### Comparisons
1. **Debian vs. Rocky**  
	**Debian** is a non-comercial OS, that's community driven. Have realeases aprox. every 2 years, only when things are ready and has security support for 5 years, not following any entrerprise schedule. Software can be old, but with many patches and support many CPU architectures. Has a vast repository, including test and unstable versions, so you can get random modern tools and pretty much everything you look for, it is supported by third-party which can be seen as unsafe to be used by enterprises. By default Debian is minimal and you assemble what you need.  
	**Rocky Linux** on the other hand is a OS focused for enterprises. It is community-led but *Red Hat* compatible. **Red Hat Enterprise Linux** being a comercial enterprise for Linux distribution. Its releases happens around every 10 years being aligned with *Red Hat* schedules. Software is *frozen* early and berely changes, giving companies a stability to work long time with it but on the other hand supports primarily x86_64 and ARM64 architecture. Softwares relies vendor-provided RPMs and *Extra Packages for Enterprise Linux*, but supported by trusted parties. Rocky is SELinux enabled and has tuned profiles to optimize your machine use as wanted (power saving, balanceed, performance.).  

2. **AppArmor vs. SELinux**  
	Both are policy-enforced security models, a *Mandatory Access Control* system. **AppArmor** being path-based and **SELinux** label-based.
	On SELinux every object (file, process, socket, port) has a *security label* and rules work as: *“Subject with label X can do action Y on object with label Z”*. That way renaming or moving a file doesn't change it's label.  
	On AppArmor the rules are path-base, so it implies that security depends on filesystem paths stays the same. *"`/usr/bin/nginx` can read `/var/www/\*\*`"*.  
	Therefore SELinux can constrain interections AppArmor can't, but it depends on correct labelin and policy design and requires active maintenance. Making it harder to learn and debug without deep knowledge. AppArmor although might be less complete it's easier to work with without deep knowledge.  
	SELinux is more recommended for large servers and and things that are maintened by proffesionals of that area, while AppArmor can be used on Desktop, dev machines and small servers because of it's easier to work with.  

3. **UFW vs. firewalld**  
	They work as a management Firewall. *UFW* is a simple and humane firewall, has a minimal interface and rules are apllied in a global way. Changes usually require a reload of the firewall, and that's why it's recomended for small servers and individual admins. As it's humane, it's easy to learn to use but it doesn't handle well multiple interfaces or complex networks.  
	*Firewalld* on the other hand handle changes without reloading the firewall or breaking connections and has good integration with services that "self-register" into the firewall. It is recommended for comporative servers, mutable enviroments (cloud, containers,VMs), and multiple interfaces.  

4. **VirtualBox vs. UTM**  
   They're virtual machines being *VirtualBox* optimized for **x86/x86-64** hosts, while UTM is for **macOS**, especially Apple Silicon. It can be run on other architecture but the emulation will slowdown the VM. VBox also provides more features, with complex networking options and snapshots of the system, UTM on the other hand is more minimalist making it easier to use and learn, but not good for larger uses.  

5. **Aptitude vs. apt**  
	Apt or Advanced Packaging Tool is a lower-level package manager that can be used for higher-level managers. Aptitude on the other hand is a high-level package manager that has all functionaties of apt, apt-get, apt-cache and more.  
	It checks for packages dependencies in order to install, remove or solve a conflict while with apt-get you would have to set an option for it. The search command in Aptitude is better than apt, giving you information if the package listed is already installed `i` or just present `p`.  
	
## Resources
The OS: [Debian](debian.org)  
The VM: [VirtualBox](https://www.virtualbox.org/)  
For the commands and configuration, I used the [man](https://man7.org/linux/man-pages/index.html) pages, [stackoverflow](https://stackoverflow.com/) and [ChatGPT](https://chat.openai.com/) for better, deeper and more humane explanation and comparsion in between commands that seemed to do the same thing.  
