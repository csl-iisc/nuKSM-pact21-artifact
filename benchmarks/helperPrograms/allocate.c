#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h> /* mmap() is defined in this header */
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <stdint.h>
#include <time.h>
#include <signal.h>

unsigned long size;
int multiplier;
unsigned long total_size;
int num_of_pages;
unsigned int number_of_loop;

#define WORKLOAD_SELF_MULTIPLIER 2

void filldata()
{
    int *addr = (int*)mmap(0, size  , PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    madvise(addr , size , MADV_MERGEABLE);
    uint64_t i=0;
    while(i < size/sizeof(int)) {
        *(addr+i) =  i * multiplier;
        i++;
    }
    printf("Data populated\n");
}

/*
 * Stupid ranged random number function.  We don't care about quality.
 *
 * Inline because it's starting to be a scaling issue.
 */

static inline unsigned long rand_num(unsigned long max, unsigned long *state)
{
	*state = *state * 1103515258476245 + 12345;
	return ((*state / 4294967295 ) % max);
}

int main(int argc , char **argv) {
    multiplier = 1;
    //num_of_pages = 1000000; //4GB
    //num_of_pages = 500000; //2GB
    num_of_pages = 262000; //1GB
    //num_of_pages = 131000; //0.5GB
    size = 1024 * sizeof(int) * num_of_pages;
    total_size = size/sizeof(int);
    filldata();
    printf("Complete\n");
    while(1) {
        sleep(200);
    }
    return 0;
}
