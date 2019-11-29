#!/usr/bin/env bash
set +e
SITE=`cat settings.yaml  |sed -rn "s/^default_site: (.*)$/\1/p"`
export JOBID=$(mcc job add gros 4 for 2h now)
echo JOB=$JOBID
mcc job wait $JOBID
export DEPID=$(mcc dep add $JOBID)
echo dep=$DEPID
mcc dep wait $DEPID
mcc job install $JOBID salt
mcc alias list $JOBID > hosts
echo "echo $JOBID" >> hosts

