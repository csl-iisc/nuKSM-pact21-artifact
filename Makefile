#################################################################################
# Makefile to generate binaries for the paper
#
# nuKSM: NUMA-aware Memory De-duplication for Multi-socket Servers [PACT'21]
#
# Authors: Akash Panda, Ashish Panwar, Arkaprava Basu
#
#################################################################################

all: btree xsbench cg randomreads btree_throughput

BENCHMARKS=benchmarks
WDEPS=benchmarks/README.md

btree: $(WDEPS)
	+$(MAKE) -C $(BENCHMARKS)/btree
	mkdir -p bin/
	cp $(BENCHMARKS)/btree/BTree bin/

btree_throughput: $(WDEPS)
	+$(MAKE) -C $(BENCHMARKS)/btree_throughput
	mkdir -p bin/
	cp $(BENCHMARKS)/btree_throughput/BTree bin/BTree_throughput

xsbench: $(WDEPS)
	+$(MAKE) -C $(BENCHMARKS)/XSBench/src
	mkdir -p bin/
	cp $(BENCHMARKS)/XSBench/src/XSBench bin/

cg: $(WDEPS)
	mkdir -p $(BENCHMARKS)/NPB3.4-OMP/bin
	+$(MAKE) -C $(BENCHMARKS)/NPB3.4-OMP/ cg CLASS=C
	mkdir -p bin
	cp $(BENCHMARKS)/NPB3.4-OMP/bin/cg.C.x bin/CG

randomreads: $(WDEPS)
	+$(MAKE) -C $(BENCHMARKS)/randomAccess
	mkdir -p bin/
	cp $(BENCHMARKS)/randomAccess/wl-randomreads-inputpages bin/
	cp $(BENCHMARKS)/randomAccess/wl-randomreads-inputpages-2 bin/

clean:
	+$(MAKE) -C $(BENCHMARKS)/btree clean
	+$(MAKE) -C $(BENCHMARKS)/XSBench/src clean
	+$(MAKE) -C $(BENCHMARKS)/NPB3.4-OMP/ clean
	+$(MAKE) -C $(BENCHMARKS)/randomAccess clean
	rm -rf bin/*
