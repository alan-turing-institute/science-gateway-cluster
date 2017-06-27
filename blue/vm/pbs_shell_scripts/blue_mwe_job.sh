#!/bin/bash
#PBS -j oe

date > $PBS_O_WORKDIR/foo
for i in {1..5}
do
  sleep 5
  date >> $PBS_O_WORKDIR/foo
done
