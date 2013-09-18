yum install yum-fastestmirror -y
yum install compat-db*
yum install compat-libc*
yum install compat-gcc*
yum install libXp.so.6
yum install libc-*
yum install libaio*
yum install openmotif
yum install glibc-devel*
yum install libgcc*
yum install gnome-lib* 

#zcat /tmp/10201_database_linux_x86_64.cpio.gz /data/setupfiles/Oracle/ | cpio -idmv

cat > /etc/redhat-release << EOF
Red Hat Enterprise Linux AS release 3 (Taroon)
EOF 

echo >> ~/.bash_profile << EOF
export ORACLE_BASE=/data1/oracle
export ORACLE_HOME=/data1/oracle
export ORACLE_SID=orcl
export ORACLE_TERM=xterm
export PATH=$ORACLE_HOME/bin:$PATH

export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=$ORACLE_HOME/JRE:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib

if [ $USER = "oracle" ]; then
  if [ $SHELL = "/bin/ksh" ]; then
    ulimit -p 16384
    ulimit -n 65536
  else
    ulimit -u 16384 -n 65536
  fi
fi
EOF
