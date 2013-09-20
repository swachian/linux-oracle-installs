#yum -y install yum-fastestmirror  compat-db* compat-libc* compat-gcc* libXp.so.6 libc-* libaio* openmotif glibc-devel* libgcc* gnome-lib* 

cat > /etc/redhat-release << EOF
Red Hat Enterprise Linux AS release 3 (Taroon)
EOF

echo "add oracle user"
groupadd oinstall
groupadd dba
useradd -m -g oinstall -G dba oracle
passwd oracle

mkdir -p /data/oracle/product
mkdir -p /data/oracle/product/OraHome
mkdir -p /data/oraInventory
mkdir -p /data/oracle/oradata
mkdir -p /var/opt/oracle

chown -R oracle.oinstall /data/oracle
chown -R oracle.oinstall /data/oracle/oradata
chown -R oracle.oinstall /data/oracle/product/OraHome
chown -R oracle.dba /data/oraInventory
chown oracle.dba /var/opt/oracle 
chmod -R 775 /data/oracle
chmod -R 755 /var/opt/oracle


echo "add limits.conf"
cat >> /etc/security/limits.conf << EOF
oracle soft nproc 2047
oracle hard nproc 16384
oracle soft nofile 1024
oracle hard nofile 65536
EOF

cat >> /etc/pam.d/login << EOF
session required /lib/security/pam_limits.so
session required pam_limits.so
EOF

echo "add .bash_profile"
cat >> /home/oracle/.bash_profile << EOF
export ORACLE_BASE=/data/oracle
export ORACLE_HOME=/data/oracle/product/OraHome
export ORACLE_SID=orcl
export ORACLE_TERM=xterm
export PATH=$ORACLE_HOME/bin:$PATH

export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=$ORACLE_HOME/JRE:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib

ulimit -u 16384 -n 65536
EOF

cat >> /etc/hosts << EOF
127.0.0.1 localhost
192.168.137.103 Oracle2
EOF

gunzip 1.gz && cpio -idcmv < 1.10201_database_linux_x86_64.cpio 
