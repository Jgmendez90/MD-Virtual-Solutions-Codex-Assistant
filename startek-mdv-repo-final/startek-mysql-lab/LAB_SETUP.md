
MySQL DBA Lab: Full Professional Recap (Expanded)

==================================================
LAB ENVIRONMENT OVERVIEW
--------------------------------------------------
Host:
- Windows 11 Pro with VirtualBox 7.x
- VirtualBox Guest Additions installed for bidirectional clipboard and mouse integration

Guest:
- Ubuntu Server 24.04 LTS (noble)
- Disk: 100 GB dynamic VDI
- Memory: 4-8 GB RAM for lab stability
- Networking: Bridged Adapter (enp0s3) for LAN visibility
- Static IP: 192.168.1.60
- SSH enabled with key-based authentication
- User: mysqladmin
- SSH Key: ed25519, passphrase protected
- SSH config hardened (PasswordAuthentication disabled post-setup)

Repository and Lab Structure:
- GitHub Repository: MySQL-DBA-Lab
- Organized into:
  01_Setup/
  02_Backups/
  03_Replication/
  04_Performance_Tuning/
  05_Monitoring/
  + clear README.md with procedural documentation

---

DETAILED STEP ORDER TO REACH CLEAN, STABLE STATE
--------------------------------------------------

1) VirtualBox VM Creation
   - Use Bridged Adapter for stable LAN testing
   - Allocate sufficient RAM (4-8 GB) and 100 GB dynamically allocated disk
   - Install Ubuntu Server 24.04 LTS with OpenSSH Server
   - Create mysqladmin user with strong password
   - Enable bidirectional clipboard in VirtualBox settings

2) Post-install OS Preparation
   - Update system:
       sudo apt update && sudo apt upgrade -y
   - Install utilities:
       sudo apt install net-tools curl wget nano htop lsb-release gnupg
   - Set timezone:
       sudo timedatectl set-timezone America/Mexico_City
   - Enable SSH service:
       sudo systemctl enable ssh
       sudo systemctl start ssh
   - Configure UFW:
       sudo ufw allow OpenSSH
       sudo ufw enable
       sudo ufw status

3) SSH Key-Based Authentication
   - On host:
       ssh-keygen -t ed25519 -C "mysql-lab-01"
   - Copy public key to VM:
       ssh-copy-id mysqladmin@192.168.1.60
   - Verify passwordless login, then disable password authentication:
       sudo nano /etc/ssh/sshd_config
       PasswordAuthentication no
       ChallengeResponseAuthentication no
       UsePAM yes
       sudo systemctl restart ssh
       ssh keyword: Blitzkrieg01*Key

4) Static IP Configuration
   - Disable Netplan to prevent fallback DHCP conflicts:
       sudo mv /etc/netplan /etc/netplan.backup
   - Create /etc/systemd/network/10-static-enp0s3.network:
       [Match]
       Name=enp0s3

       [Network]
       Address=192.168.1.60/24
       Gateway=192.168.1.1
       DNS=8.8.8.8
       DNS=8.8.4.4
       DHCP=no
       IPv6AcceptRA=no
   - Enable and restart systemd-networkd:
       sudo systemctl enable systemd-networkd
       sudo systemctl restart systemd-networkd
       sudo ip addr flush dev enp0s3
       sudo systemctl restart systemd-networkd
   - Validate:
       ip a
       ping 8.8.8.8
       ping google.com

5) MySQL Installation
   - Download MySQL APT repo (jammy for compatibility):
       wget https://dev.mysql.com/get/mysql-apt-config_0.8.29-1_all.deb
       sudo dpkg -i mysql-apt-config_0.8.29-1_all.deb
       sudo apt update
   - Install MySQL Server:
       sudo apt install mysql-server -y
   - Check:
       mysql --version
   - Secure MySQL:
       sudo mysql_secure_installation

6) MySQL Hardening
   - Remove test DB, anonymous users
   - Disable remote root login
   - Enforce strong password policies
   - Enable UFW port 3306 if needed for external testing:
       sudo ufw allow 3306

7) MySQL Configuration for Remote Connections
   - Edit:
       sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
       bind-address = 0.0.0.0
   - Restart:
       sudo systemctl restart mysql
   - Create admin user:
       sudo mysql -u root -p
       CREATE USER 'mysqladmin'@'%' IDENTIFIED BY 'Blitzkrieg01*';
       GRANT ALL PRIVILEGES ON *.* TO 'mysqladmin'@'%' WITH GRANT OPTION;
       FLUSH PRIVILEGES;

8) SSH Key Management
   - Maintain .ssh structure:
       ~/.ssh/
       ├── authorized_keys
       ├── id_ed25519
       └── id_ed25519.pub
   - Permissions:
       chmod 700 ~/.ssh
       chmod 600 ~/.ssh/authorized_keys

---

ISSUES ENCOUNTERED & LESSONS
-----------------------------
- NumLock issues ➔ enable before login
- GRUB recovery ➔ use `rw init=/bin/bash`
- MySQL APT conflicts ➔ use jammy for noble
- Duplicate IP ➔ disable Netplan, use systemd-networkd only
- SSH clipboard issues ➔ use VirtualBox bidirectional clipboard
- SSH key not working ➔ permissions and proper placement in ~/.ssh
- MySQL remote issues ➔ configure bind-address + grant privileges correctly

---

COMMAND GLOSSARY
------------------------------
Linux:
- ip a
- sudo apt update && sudo apt upgrade -y
- sudo systemctl restart/start/enable/disable/status
- sudo ufw allow/enable/status
- sudo nano
- ping, wget, curl, lsb_release, gnupg
- sudo ip addr flush dev enp0s3
- ssh-keygen, ssh-copy-id

MySQL:
- mysql --version
- sudo mysql -u root -p
- CREATE USER, GRANT, FLUSH PRIVILEGES
- SHOW DATABASES;
- SHOW TABLES;
- EXIT;

---

SUMMARY:
You now have a stable, professional MySQL DBA lab ready for:
- Structured backups
- Advanced replication lab with sbtest dataset
- Performance monitoring and tuning
- Query optimization testing
- Consistent, scalable MySQL DBA workflows

With this setup, you can now proceed immediately to replication with a professional, conflict-free environment.

