#!/bin/bash

OUT="./sysbench-CPU.csv"
if [ -f "$OUT" ]; then
   rm -f $OUT
fi

MAXTHREADS=64
echo "Date;"$(date) >> $OUT
echo "Version;"$(sysbench --version) >> $OUT
echo "Host;"$(hostname) >> $OUT
echo "Model name;"$(lscpu | egrep 'Model name' | awk -v f=3 '{for(i=f;i<=NF;i++) printf("%s%s",$i,(i!=NF)?" ":OFS)}') >> $OUT
echo "CPU MHz);"$(lscpu | egrep 'CPU MHz' | awk -F" " '{print $3}') >> $OUT
echo "CPU(s);"$(lscpu | egrep '^CPU\(s\)' | awk -F" " '{print $2}') >> $OUT
echo "Threads per core;"$(lscpu | egrep 'Thread\(s\) per core' | awk -F" " '{print $4}') >> $OUT
echo "NUMA node(s);"$(lscpu | egrep 'NUMA node\(s\)' | awk -F" " '{print $3}') >> $OUT

PRIME=100
echo "" >> $OUT
echo "Prime="$PRIME >> $OUT
echo "Threads;EPS" >> $OUT
THREADS=1
echo $THREADS";"$(sysbench cpu --threads=$THREADS --cpu-max-prime=$PRIME run | grep "events per second" | awk -F" " '{ print $4 }') >> $OUT
for THREADS in `seq 4 4 $MAXTHREADS`
do
echo $THREADS";"$(sysbench cpu --threads=$THREADS --cpu-max-prime=$PRIME run | grep "events per second" | awk -F" " '{ print $4 }') >> $OUT
done

PRIME=10000
echo "" >> $OUT
echo "Prime="$PRIME >> $OUT
echo "Threads;EPS" >> $OUT
THREADS=1
echo $THREADS";"$(sysbench cpu --threads=$THREADS --cpu-max-prime=$PRIME run | grep "events per second" | awk -F" " '{ print $4 }') >> $OUT
for THREADS in `seq 4 4 $MAXTHREADS`
do
echo $THREADS";"$(sysbench cpu --threads=$THREADS --cpu-max-prime=$PRIME run | grep "events per second" | awk -F" " '{ print $4 }') >> $OUT
done
