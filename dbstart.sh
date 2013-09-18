source /home/oracle/.bash_profile
sqlplus '/as sysdba' << EOF
startup;
exit
EOF
lsnrctl start
