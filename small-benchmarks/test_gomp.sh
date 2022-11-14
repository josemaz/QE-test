QEbin=/opt/apps/qe-gnu/bin/pw.x

for i in {1..4}
do
	procs=$(( i*$(nproc)/4 ))
	echo $procs
  # export GOMP_CPU_AFFINITY=0-17
	export OMP_NUM_THREADS=$procs
	export OMP_PROC_BIND=TRUE
	$QEbin -in test_4.in > test_4-${procs}c.out
done
