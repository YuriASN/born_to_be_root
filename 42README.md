This project has been created as part of the 42 curriculum by ysantos-

# Born To Be Root

## Description

## Instructions

## Resources

## Project Description

- **Partitioning**
- **Security Policies**
- **User Management**
- **Services Installed**

1. **Debian vs. Rocky**  
	**Debian** is a non-comercial OS, that's community driven. Have realeases aprox. every 2 years only when things are ready and has security support for 5 years not following any entrerprise schedule. 	Software can be old but with many patches and support many CPU architectures.  Has a vast repository, including test and unstable versions, so you can get random modern tools and pretty much everything you look for, supported by third-party which can be seen as unsafe for enterprises to use. By default Debian is minimal and you assemble what you need.  
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