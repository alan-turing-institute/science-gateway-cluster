sudo apt-get update --yes
sudo apt-get install --yes build-essential
sudo apt-get install --yes libopenmpi-dev
sudo apt-get install --yes gfortran
sudo apt-get install --yes libvtk5-dev

# Install Python stuff
sudo apt --yes --force-yes install python-pip
sudo pip install --upgrade pip
sudo pip install f90nml

wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O ~/miniconda.sh
bash ~/miniconda.sh -b -p $HOME/miniconda
export PATH="$HOME/miniconda/bin:$PATH"
conda install --yes vtk

# === Install Torque ===
sudo apt-get install --yes libboost-dev

# Download the source package
cd /tmp
wget http://www.adaptivecomputing.com/index.php?wpfb_dl=3170 -O torque.tar.gz
tar xzvf torque.tar.gz
cd torque-6.1.0*

# Build
./configure
sudo make
sudo make packages
sudo make install

export PATH=/usr/local/bin/:/usr/local/sbin/:$PATH

# Create and start trqauthd
sudo cp contrib/init.d/trqauthd /etc/init.d/
sudo chkconfig --add trqauthd
sh -c "echo /usr/local/lib > /etc/ld.so.conf.d/torque.conf" >> /tmp/azure_pbsdeploy.log.$$ 2>&1
ldconfig >> /tmp/azure_pbsdeploy.log.$$ 2>&1
service trqauthd start >> /tmp/azure_pbsdeploy.log.$$ 2>&1

# Update config
sh -c "echo $MASTER_HOSTNAME > /var/spool/torque/server_name" >> /tmp/azure_pbsdeploy.log.$$ 2>&1

env "PATH=$PATH" sh -c "echo 'y' | ./torque.setup root" >> /tmp/azure_pbsdeploy.log.$$ 2>&1

sh -c "echo $MASTER_HOSTNAME > /var/spool/torque/server_priv/nodes" >> /tmp/azure_pbsdeploy.log.$$ 2>&1

# Start pbs_server
cp contrib/init.d/pbs_server /etc/init.d >> /tmp/azure_pbsdeploy.log.$$ 2>&1
chkconfig --add pbs_server >> /tmp/azure_pbsdeploy.log.$$ 2>&1
service pbs_server restart >> /tmp/azure_pbsdeploy.log.$$ 2>&1

# Start pbs_mom
cp contrib/init.d/pbs_mom /etc/init.d >> /tmp/azure_pbsdeploy.log.$$ 2>&1
chkconfig --add pbs_mom >> /tmp/azure_pbsdeploy.log.$$ 2>&1
service pbs_mom start >> /tmp/azure_pbsdeploy.log.$$ 2>&1

# Start pbs_sched
env "PATH=$PATH" pbs_sched >> /tmp/azure_pbsdeploy.log.$$ 2>&1
