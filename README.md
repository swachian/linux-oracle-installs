一些用于安装Linux虚拟机和Oracle的脚本

- config.sh: 这个用于初始化linux配置，包括参数的修改，ip的配置，hostname的更改等等

- oracle_yum.sh: 安装oracle前，需要配置的环境变量以及相关的yum文件盒必要的release声明

- dbstart.sh: Oracle的开机启动脚本，可放入`/etc/rc.local`中，用`su - oracle -c "/bin/bash /home/oracle/dbstart.sh"` 运行

- 装机相关：

1. 系统参数调整: 参见`config.sh`

2. jdk下载、解压与配置环境变量

3. nginx下载与安装

4. redis安装与配置

5. mysql安装

6. tomcat安装

7. 开机自动启动

8. 安装自动监控工具
