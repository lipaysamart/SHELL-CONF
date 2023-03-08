
#!/bin/bash
#####################
# author: Ethan
# email: lipaysamart@gmail.com
# usage: 
#####################
Manu(){
cat <<-EOF 
----------------------------
|       1. NFS Clinet      | 
|       2. NFS Server      | 
----------------------------
EOF
}

NFS-Server(){
# 关闭防火墙
systemctl stop firewalld.service
systemctl disable firewalld.service

# 安装nfs工具包
yum -y install nfs-utils rpcbind

# 设置共享目录->设置权限
mkdir -p /var/lib/nfs
chmod 755 /var/lib/nfs

# 配置nfs文件
cat >> /etc/exports <<-EOF
/var/lib/nfs  *(rw,sync,no_root_squash)
EOF

systemctl enable rpcbind --now && systemctl enable nfs --now
systemctl status rpcbind && systemctl status nfs
}

NFS-Clint(){
systemctl stop firewalld.service
systemctl disable firewalld.service

yum -y install nfs-utils rpcbind

systemctl enable rpcbind --now && systemctl enable nfs --now
systemctl status rpcbind && systemctl status nfs
}

read -p "请输入你要安装的Number:"  num
if [ $num = 1 ] 
then echo "-------- 开始安装NFS Client --------"
NFS-Clint
elif [ $num = 2 ]
then echo "-------- 开始安装NFS Server --------"
NFS-Server
else 
exit
fi