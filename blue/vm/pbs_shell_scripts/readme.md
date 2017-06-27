See [torque environment variables documentation](http://docs.adaptivecomputing.com/torque/4-0-2/Content/topics/commands/qsub.htm)

`PBS_O_WORKDIR` The absolute path of the current working directory of the qsub command.



## Ideas for cluster-side commands

Environment variables in this sketch

```shell
CASE="name" # name of working directory for computation
BLUE_SRC="/path/to/blue" # path to Blue code base on science-gateway-cluster
```

One-time copy across backend code structure:

```shell
git clone git@github.com:alan-turing-institute/blue-source-ubuntu.git
scp -r blue-source-ubuntu vm-admin@science-gateway-cluster.westeurope.cloudapp.azure.com:$BLUE_SRC
```

Patch project (to be run be science-gateway-middleware):

```shell
fill_parameters template.nml data.json > Blue.nml # data.json is received from science-gateway-web
fill_parameters template.f90 data.json > $CASE.f90
```

Submit job to queue

```shell
cd $BLUE_SRC/project/$CASE
qsub job.sh # where job.sh is a pbs script
```

Job progress

```
tail -1 $BLUE_SRC/project/case/output.csv
```

Job status (via queueing system only as first iteration)

```
qstat 0.science-gateway-cluster
```