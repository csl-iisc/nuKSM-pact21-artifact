#################################################################################
# Makefile to generate binaries for the paper
#
# nuKSM: NUMA-aware Memory De-duplication for Multi-socket Servers [PACT'21]
#
# Authors: Akash Panda, Ashish Panwar, Arkaprava Basu
#
#################################################################################

all: btree xsbench cg

BENCHMARKS=benchmarks
WDEPS=benchmarks/README.md

btree : $(WDEPS)
	+$(MAKE) -C $(BENCHMARKS)/btree
	cp $(BENCHMARKS)/btree/BTree bin/

xsbench: $(WDEPS)
	+$(MAKE) -C $(BENCHMARKS)/XSBench/src
	cp $(BENCHMARKS)/XSBench/src/XSBench bin/

cg: $(WDEPS)
	+$(MAKE) -C $(BENCHMARKS)/NPB3.4-OMP/ cg CLASS=C
	cp $(BENCHMARKS)/NPB3.4-OMP/bin/cg.C.x bin/CG

clean:
	+$(MAKE) -C $(BENCHMARKS)/btree clean
	+$(MAKE) -C $(BENCHMARKS)/XSBench/src clean
	+$(MAKE) -C $(BENCHMARKS)/NPB3.4-OMP/ clean
	rm -rf bin/*