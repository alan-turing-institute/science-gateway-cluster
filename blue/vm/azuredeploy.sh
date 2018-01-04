#!/bin/sh

# basic info
date > /tmp/azuredeploy.log.$$ 2>&1
whoami >> /tmp/azuredeploy.log.$$ 2>&1
echo $@ >> /tmp/azuredeploy.log.$$ 2>&1

# usage
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 VM_NAME ADMIN_USERNAME" >> /tmp/azuredeploy.log.$$
  exit 1
fi

# import command line arguments
VM_NAME=$1
ADMIN_USERNAME=$2

VM_IP=`hostname --ip-address`
echo $VM_IP $VM_NAME >> /etc/hosts
echo $VM_IP $VM_NAME > /tmp/hosts.$$

sudo apt-get update >> /tmp/azuredeploy.log.$$

sudo apt-get install --yes build-essential >> /tmp/azuredeploy.log.$$
sudo apt-get install --yes libtool >> /tmp/azuredeploy.log.$$
sudo apt-get install --yes libtool-bin >> /tmp/azuredeploy.log.$$
sudo apt-get install --yes libssl-dev >> /tmp/azuredeploy.log.$$
sudo apt-get install --yes libxml2-dev >> /tmp/azuredeploy.log.$$
sudo apt-get install --yes libboost-dev >> /tmp/azuredeploy.log.$$
sudo apt-get install --yes clamav* >> /tmp/azuredeploy.log.$$
sudo apt-get install --yes sysv-rc-conf >> /tmp/azuredeploy.log.$$

# download the torque source package
cd /tmp >> /tmp/azuredeploy.log.$$ 2>&1
wget http://www.adaptivecomputing.com/index.php?wpfb_dl=2936 -O torque.tar.gz >> /tmp/azuredeploy.log.$$ 2>&1
tar xzvf torque.tar.gz >> /tmp/azuredeploy.log.$$ 2>&1
cd torque-5.1.1* >> /tmp/azuredeploy.log.$$ 2>&1

# build the torque source package
./configure >> /tmp/azuredeploy.log.$$ 2>&1
make >> /tmp/azuredeploy.log.$$ 2>&1
make packages >> /tmp/azuredeploy.log.$$ 2>&1
libtool --finish /usr/local/lib >> /tmp/azuredeploy.log.$$
sudo make install >> /tmp/azuredeploy.log.$$ 2>&1

export PATH=/usr/local/bin/:/usr/local/sbin/:$PATH

# create and start trqauthd service
sudo cp contrib/init.d/debian.trqauthd /etc/init.d/trqauthd
sudo sysv-rc-conf trqauthd on >> /tmp/azuredeploy.log.$$
#systemctl daemon-reload # possibly needed

sudo sh -c "echo /usr/local/lib > /etc/ld.so.conf.d/torque.conf" >> /tmp/azuredeploy.log.$$ 2>&1
sudo ldconfig >> /tmp/azuredeploy.log.$$ 2>&1
sudo update-rc.d trqauthd defaults >> /tmp/azuredeploy.log.$$
sudo service trqauthd start >> /tmp/azuredeploy.log.$$ 2>&1


# Update config
sudo sh -c "echo $VM_NAME > /var/spool/torque/server_name" >> /tmp/azuredeploy.log.$$ 2>&1
sudo env "PATH=$PATH" sh -c "echo 'y' | ./torque.setup root" >> /tmp/azuredeploy.log.$$ 2>&1
sudo sh -c "echo $VM_NAME > /var/spool/torque/server_priv/nodes" >> /tmp/azuredeploy.log.$$ 2>&1

# start pbs_server
sudo cp contrib/init.d/debian.pbs_server /etc/init.d/pbs_server >> /tmp/azuredeploy.log.$$ 2>&1
sudo sysv-rc-conf pbs_server on >> /tmp/azuredeploy.log.$$
sudo update-rc.d pbs_server defaults >> /tmp/azuredeploy.log.$$
sudo service pbs_server start >> /tmp/azuredeploy.log.$$
sudo service pbs_server restart >> /tmp/azuredeploy.log.$$ 2>&1


# start pbs_mom
sudo cp contrib/init.d/debian.pbs_mom /etc/init.d/pbs_mom >> /tmp/azuredeploy.log.$$ 2>&1
sudo update-rc.d pbs_mom defaults >> /tmp/azuredeploy.log.$$
sudo service pbs_mom start >> /tmp/azuredeploy.log.$$ 2>&1

# start pbs_sched
sudo env "PATH=$PATH" pbs_sched >> /tmp/azuredeploy.log.$$ 2>&1

# restart pbs_server
sudo service pbs_server restart >> /tmp/azuredeploy.log.$$ 2>&1

# blue-specific requirements
sudo apt-get install --yes libopenmpi-dev >> /tmp/azuredeploy.log.$$
sudo apt-get install --yes gfortran >> /tmp/azuredeploy.log.$$
sudo apt-get install --yes libvtk5-dev >> /tmp/azuredeploy.log.$$
# sudo apt-get install python-vtk # untested

# test python installation
cd /tmp
wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O miniconda.sh >> /tmp/azuredeploy.log.$$
bash miniconda.sh -b -p /home/$ADMIN_USERNAME/miniconda /tmp/azuredeploy.log.$$

export PATH="/home/$ADMIN_USERNAME/miniconda/bin:$PATH"
echo export PATH="/home/$ADMIN_USERNAME/miniconda/bin:\$PATH" >> /home/$ADMIN_USERNAME/.bashrc # set miniconda python for future ssh logins
conda install --yes vtk >> /tmp/azuredeploy.log.$$
/home/$ADMIN_USERNAME/miniconda/bin/pip install f90nml >> /tmp/azuredeploy.log.$$
/home/$ADMIN_USERNAME/miniconda/bin/pip install pyfoam==0.6.8.1 >> /tmp/azuredeploy.log.$$

exit 0
