sudo yum update -y
sudo yum install -y make automake gcc gcc-c++ kernel-devel # Rough equivalent of Ubuntu build-essential
sudo yum install -y openmpi-devel
module add mpi/openmpi-x86_64 # Load MPI module
# sudo yum install -y gcc-gfortran # Not required. Already installed with openmpi-devel

# Install Python stuff
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python get-pip.py 
sudo pip install --upgrade pip
sudo pip install f90nml

# VTK
sudo yum install -y epel-release # Add EPEL repository, which has VTK
sudo yum install -y vtk-python # Install VTK plus Python interface

# === Install Torque ===
sudo yum install -y boost-devel # Needed for Torque "make" step
sudo yum install -y libxml2-devel # Needed for Torque "make" step
sudo yum install -y openssl-devel # Needed for Torque "make packages" step

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
sudo sh -c "echo /usr/local/lib > /etc/ld.so.conf.d/torque.conf"
sudo ldconfig
sudo service trqauthd start

# Update config
# sudo sh -c hostname > /var/spool/torque/server_name # Not required. Already correctly set

echo $( hostname --ip-address) " " $(hostname -f) " " $(hostname) | sudo tee --append /etc/hosts
sudo env "PATH=$PATH" sh -c "echo 'y' | ./torque.setup root $(hostname -f)"

sudo sh -c "echo $(hostname -f) > /var/spool/torque/server_priv/nodes"

# Start pbs_server
sudo cp contrib/init.d/pbs_server /etc/init.d
sudo chkconfig --add pbs_server
sudo service pbs_server restart

# Start pbs_mom
sudo cp contrib/init.d/pbs_mom /etc/init.d
sudo chkconfig --add pbs_mom
sudo service pbs_mom start

# Start pbs_sched
sudo env "PATH=$PATH" pbs_sched

# === Untweaked code to deploy Torque to workers and add them to config on master ===
# Push packages to compute nodes
# c=0
# rm -rf /tmp/hosts
# echo "$MASTER_HOSTNAME" > /tmp/host
# while [ $c -lt $WORKER_COUNT ]
# do
#         printf "\n$WORKER_HOSTNAME_PREFIX$c">> /tmp/host
#         workerhost=$WORKER_HOSTNAME_PREFIX$c     
#         service pbs_mom stop
#         ####Keeping the following three lines for computenode remote ssh script execution but this won't work as compnodes are not created yet####
#         service pbs_mom start
#         echo $workerhost >> /var/spool/torque/server_priv/nodes
#          echo $workerhost
#         (( c++ ))
# done
# sed '2d' /tmp/host > /tmp/hosts
# rm -rf /tmp/host


# Restart pbs_server
# service pbs_server restart >> /tmp/azure_pbsdeploy.log.$$ 2>&1
# 
# cp /var/spool/torque/server_priv/nodes  $SHARE_HOME/$HPC_USER/machines.LINUX
# chown $HPC_USER:$HPC_USER $SHARE_HOME/$HPC_USER/machines.LINUX
# service pbs_mom start
