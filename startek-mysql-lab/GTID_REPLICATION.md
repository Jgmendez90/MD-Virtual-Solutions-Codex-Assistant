
=======================================================================
MySQL DBA Advanced GTID Replication & Monitoring Lab Recap
=======================================================================

Prepared for: Gabriel_Mendez
Session Date: 2025-07-06

───────────────────────────────────────────────────────────────────────
1️⃣ LAB INFRASTRUCTURE
───────────────────────────────────────────────────────────────────────
- Environment:
    - Oracle VirtualBox running Ubuntu Server VMs.
    - One VM as MySQL Master, another as MySQL Replica.
    - Planned use of SQLTools inside VS Code for workflow.

- IPs:
    - Master: 192.168.1.60
    - Replica: 192.168.1.61

───────────────────────────────────────────────────────────────────────
2️⃣ MASTER CONFIGURATION FOR GTID REPLICATION
───────────────────────────────────────────────────────────────────────
Edit:
    sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf

Recommended block:
    [mysqld]
    # Enabling GTID-based replication on Master Gabriel_Mendez
    server-id = 1
    log_bin = /var/log/mysql/mysql-bin.log
    binlog_format = ROW
    gtid_mode = ON
    enforce_gtid_consistency = ON
    log_slave_updates = ON
    expire_logs_days = 7
    sync_binlog = 1
    max_connections = 200
    innodb_file_per_table = 1
    innodb_flush_log_at_trx_commit = 1
    innodb_buffer_pool_size = 1G
    bind-address = 0.0.0.0

Commands:
    sudo systemctl restart mysql
    sudo systemctl status mysql

Validation:
    SHOW VARIABLES LIKE 'gtid_mode';
    SHOW VARIABLES LIKE 'enforce_gtid_consistency';
    SHOW MASTER STATUS;

───────────────────────────────────────────────────────────────────────
3️⃣ REPLICA CONFIGURATION
───────────────────────────────────────────────────────────────────────
- Ensure Replica has:
    server-id = 2
    gtid_mode = ON
    enforce_gtid_consistency = ON
    log_slave_updates = ON
    read_only = ON
    relay_log = mysql-relay-bin

───────────────────────────────────────────────────────────────────────
4️⃣ USER CREATION ON MASTER FOR REPLICATION
───────────────────────────────────────────────────────────────────────
On MASTER:
    CREATE USER 'repl'@'192.168.1.%' IDENTIFIED BY 'YourStrongPassword';
    GRANT REPLICATION SLAVE ON *.* TO 'repl'@'192.168.1.%';
    FLUSH PRIVILEGES;

Validation:
    SHOW GRANTS FOR 'repl'@'192.168.1.%';

───────────────────────────────────────────────────────────────────────
5️⃣ GTID REPLICATION CONFIG ON REPLICA
───────────────────────────────────────────────────────────────────────
ON REPLICA:
    STOP SLAVE;
    RESET SLAVE ALL;

    CHANGE MASTER TO
        MASTER_HOST='192.168.1.60',
        MASTER_USER='repl',
        MASTER_PASSWORD='YourStrongPassword',
        MASTER_AUTO_POSITION=1;

    START SLAVE;

Validation:
    SHOW SLAVE STATUS\G

Expected key fields:
    Slave_IO_Running: Yes
    Slave_SQL_Running: Yes
    Using_Gtid: Yes
    Auto_Position: 1
    Seconds_Behind_Master: 0

───────────────────────────────────────────────────────────────────────
6️⃣ TROUBLESHOOTING
───────────────────────────────────────────────────────────────────────
Error 1396: User already exists:
    DROP USER 'repl'@'192.168.1.%';

Error 1062: Duplicate entry:
    DROP DATABASE replication_test;

Error 1049: Unknown database:
    Create the missing database manually.

UUID Conflicts:
    - Check master UUID:
        SELECT @@server_uuid;
    - Check replica UUID:
        SELECT @@server_uuid;
    - If identical:
        Stop MySQL on REPLICA,
        Remove auto.cnf:
            sudo rm /var/lib/mysql/auto.cnf
        Restart MySQL:
            sudo systemctl start mysql

───────────────────────────────────────────────────────────────────────
7️⃣ HEALTH CHECK AUTOMATION SCRIPT
───────────────────────────────────────────────────────────────────────
Example script for scheduled checks:
```bash
#!/bin/bash
mysql -u root -pYourPassword -e "SHOW SLAVE STATUS\G" > /var/log/mysql/replication_check_$(date +%F).log
```
Set as cron job:
    crontab -e
    0 * * * * /path/to/replication_health_check.sh

───────────────────────────────────────────────────────────────────────
8️⃣ LAB BEST PRACTICES
───────────────────────────────────────────────────────────────────────
✅ Always configure GTID before cloning master for replicas.
✅ Validate environment with SELECT @@server_id before executing replication changes.
✅ Use SQLTools with environment banners to avoid executing commands on the wrong server.
✅ Automate monitoring with scheduled scripts or Rundeck.
✅ Keep master and replicas consistent in schema state before starting replication.

=======================================================================
END OF MYSQL DBA LAB RECAP
=======================================================================
