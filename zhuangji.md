# JDK下载、解压与配置环境变量

Oracle站点下载最新版本的Java，jdk-7u17-linux-x64.tar.gz，此处用了64位的。

解压后形成jdk1.7.0_17目录

```
echo export JAVA_HOME=/home/deploy/jdk1.7.0_17 >> /etc/profile
echo export PATH=/home/deploy/jdk1.7.0_17/bin >> /etc/profile
```

# nginx下载与安装

wget http://nginx.org/download/nginx-1.2.7.tar.gz

wget http://sourceforge.net/projects/pcre/files/pcre/8.32/pcre-8.32.tar.gz/download

先安装pcre，解压，`configure && make && make instal`

再安装nginx，解压，`configure --prefix=/usr/local/nginx && make && make install`

如果运行nginx发生错误，可通过下面的命令查看是哪个lib的问题

`ldd $(which /usr/local/nginx/sbin/nginx)` =>


```
        linux-vdso.so.1 =>  (0x00007ffffb36e000)
        libpthread.so.0 => /lib64/libpthread.so.0 (0x0000003aac600000)
        libcrypt.so.1 => /lib64/libcrypt.so.1 (0x0000003abdc00000)
        libpcre.so.1 => /lib64/libpcre.so.1 (0x0000003aace00000)
        libcrypto.so.6 => /lib64/libcrypto.so.6 (0x0000003ab0200000)
        libz.so.1 => /usr/lib64/libz.so.1 (0x0000003aaca00000)
        libc.so.6 => /lib64/libc.so.6 (0x0000003aaba00000)
        /lib64/ld-linux-x86-64.so.2 (0x0000003aab600000)
        libdl.so.2 => /lib64/libdl.so.2 (0x0000003aabe00000)
```
如果有问题，是会报告not found的

proxy pass的code小抄

```shell
location / {
          proxy_set_header  X-Real-IP  $remote_addr;
          proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header Host $http_host;
          proxy_redirect off;
          client_max_body_size       30m;
          client_body_buffer_size    128k;

          proxy_connect_timeout      900;
          proxy_send_timeout         900;
          proxy_read_timeout         900;
          proxy_buffer_size          16k;
          proxy_buffers              4 32k;
          proxy_busy_buffers_size    64k;
          proxy_temp_file_write_size 64k;

            root   html;
            #index  index.html index.htm;
            proxy_pass http://192.168.203.198:8080;
        }
```

# redis安装与配置

在redis.io下载稳定版本的redis，此处用了redis-2.6.11.tar.gz

解压，`make`，这样二进制版本就存放在redis的src目录下了。

接着运行 `./utils/install_server.sh ` ,会把redis作为服务安装。

```
Please select the redis port for this instance: [6379] 
Selecting default: 6379
Please select the redis config file name [/etc/redis/6379.conf] 
Selected default - /etc/redis/6379.conf
Please select the redis log file name [/var/log/redis_6379.log] 
Selected default - /var/log/redis_6379.log
Please select the data directory for this instance [/var/lib/redis/6379] 
Selected default - /var/lib/redis/6379
Please select the redis executable path 

Copied /tmp/6379.conf => /etc/init.d/redis_6379
Installing service...
Successfully added to chkconfig!
Successfully added to runlevels 345!

Installation successful!
```

修改`/etc/redis/6379.conf`，调大里面的参数

```
hash-max-ziplist-entries 1024
hash-max-ziplist-value 128
maxmemory 4gb #限制最大内存使用4gb

```

执行 `/etc/init.d/redis_6379 stop` , `/etc/init.d/redis_6379 restart`


如果使用ruby的话，可以再安装rmon

# mysql安装

wget http://dev.mysql.com/get/Downloads/MySQL-5.1/mysql-5.1.68.tar.gz/from/http://cdn.mysql.com/

### 解压并安装

5.1开始，innodb引擎需要主动声明后才会编译安装，其他的就是指定默认的字符集以及加入对中文字符集的支持

```
$tar -zxvf mysql-5.1.68.tar.gz
$ sudo groupadd mysql
$ sudo useradd -g mysql mysql
$ ./configure --prefix=/opt/mysql --with-charset=utf8 --with-extra-charsets="gbk,gb2312,big5" --with-plugins=innobase
# 如果是5.5 5.6以上的源码，则需要使用cmake
$cmake . -DCMAKE_INSTALL_PREFIX=/opt/mysql \
-DMYSQL_DATADIR=/opt/mysql/data \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_MEMORY_STORAGE_ENGINE=1 \
-DWITH_READLINE=1 \
-DMYSQL_UNIX_ADDR=/tmp/mysqld.sock \
-DMYSQL_TCP_PORT=3306 \
-DENABLED_LOCAL_INFILE=1 \
-DEXTRA_CHARSETS=all \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci
$ make && make install
```

### 修改my.cnf
```
cp support-files/my-huge.cnf /etc/my.cnf

```

```
    # 在/etc/my.cnf中设置innodb成为默认的数据库引擎
    default-storage-engine=INNODB
    transaction-isolation=READ-COMMITTED #将innodb的事务隔离级别调整,以保证提交的数据必定被读取
    innodb_flush_log_at_trx_commit = 0 # 修改日志记录
    innodb_buffer_pool_size = 4096M  # 调大缓存
```

### 设置启动脚本

```
cp support-files/mysql.server /etc/init.d/mysqld
chmod 755 /etc/init.d/mysqld
cd /etc/init.d/
who -r
cd /ect/rc5.d/
ln -s ../init.d/mysqld S85mysqld
ln -s ../init.d/mysqld K85mysqld
```

### 启动并设置权限

```
cd /opt/mysql/
./bin/mysql_install_db
chown -R root .
chown -R mysql var
/etc/init.d/mysqld start
```

然后登陆mysql，设置远程帐号的权限

`grant all on *.* to 'user'@'%' identified by 'password';`

GRANT ALL PRIVILEGES ON *.* TO root@"%" IDENTIFIED BY "root";

create database simmax default character set utf8;

# tomcat安装

下载新版apache tomcat

wget http://apache.etoak.com/tomcat/tomcat-7/v7.0.37/bin/apache-tomcat-7.0.37.tar.gz

解压后得到tomcat

### 删除无关应用
webapps下面的自带的应用可以全部删掉。7和5不同，manager是从原来的`server/webapps`挪到了`webapps`下面，安全起见可以删掉。

多一个杂应用，就多一个隐患。

### 配置java参数

在`catalina.sh`中增加

```
export JAVA_HOME=/home/deploy/jdk1.7.0_17
JAVA_OPTS="-Xms1024m -Xmx4096m -XX:PermSize=128m -XX:MaxPermSize=512m"
export LANG=en_US.UTF-8
```

在`conf/server.xml`中调整参数

```
    <Connector port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
maxThreads="300" minSpareThreads="25" maxSpareThreads="75"
               enableLookups="false"  acceptCount="800"
               redirectPort="8443" />
```
Tomcat 7支持BIO NIO两种方式的HTTP connector，也可以自己设置线程池(excutor)。保守点，还是用老的BIO吧，这也是tomcat7默认的。

# 开机自动启动

mysql和redis的开机启动，如前所述都已经加到`/etc/rc5.d`下面，需要进一步开机自启动的是nginx和tomcat。

也十分简单，加到`/etc/rc.local`中即可：

```
echo su - deploy -c "/home/deploy/apache-tomcat-7.0.37/bin/startup.sh" >> /etc/rc.local  
echo  /usr/local/nginx/sbin/nginx >> /etc/rc.local  
``` 

启动tomcat之所以搞的有点复杂，是因此rc.local的启动都是以root身份运行的，但我们并不想让这个java进程以root身份启动。
