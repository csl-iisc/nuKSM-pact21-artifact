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

int main(int argc , char **argv) {
    mlockall(MCL_CURRENT);
    int multiplier;
    if(argc < 2) {
        printf("Error: Usage %s {number of pages}" , argv[0]);
        exit(1);
    }
    if(argc == 3) {
        multiplier = atoi(argv[2]);
    } else {
        multiplier = 1;
    }
    int  num_of_pages = atoi(argv[1]);
    srand(time(0));
    unsigned long size = 1024 * sizeof(int) * num_of_pages;
    int *addr = (int*)mmap(0, size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    printf("Mapped at %p\n", addr);
    //mlock(addr , size);
    uint64_t i=0;
    while(i < size/sizeof(int)) {
        *(addr+i) = i * multiplier;
        i++;
    }
    printf("Data populated\n");
    
    int s;
    while(1) {
    	sleep(100);
    }
}
