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
#include<signal.h>

unsigned long size;
int *addr;
int multiplier;
unsigned long total_size;
int num_of_pages;
unsigned int number_of_loop;

#define WORKLOAD_SELF_MULTIPLIER 2

void filldata(int sig , siginfo_t *siginfo, void *context)
{
    long callerpid = (long)siginfo->si_pid;
    addr = (int*)mmap(0, size  , PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    uint64_t i=0;
    while(i < size/sizeof(int)) {
        *(addr+i) = i * multiplier;
        i++;
    }
    printf("Data populated\n");
    kill(callerpid , SIGUSR1);
}
void unmap_all() {
    munmap(addr , size);
}

int get_signalling_process_pid() {
    FILE *signallingfptr;
    
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

void random_access(int sig , siginfo_t *siginfo, void *context) {
    //printf ("Sending PID: %ld, UID: %ld\n",(long)siginfo->si_pid, (long)siginfo->si_uid);
    long callerpid = (long)siginfo->si_pid;
    printf("Random access started : %d loops\n" , number_of_loop);
    time_t start, end;
    int total_times = 1;
    int x;
    unsigned long sum = 0;
    uint64_t i=0;
    unsigned long total_size_by_2 = total_size/2;
    unsigned long state = 1;
    unsigned long random_num;
    unsigned long start_elem = 0;
    unsigned long iterations;
    time_t start_new;
    time(&start);
    time(&start_new);
    for(unsigned int j = 0 ; j < number_of_loop ; j++) {
    //while(j < number_of_loop) {
        i = 0;
        iterations = total_size/8;
        while(i < iterations) {
	    random_num = rand_num(total_size, &state);
	    x = *(addr+random_num);
            sum+=x;
            i++;
        }
	time(&end);
	time(&start_new);
    }
    time(&end);
    printf("Time taken : %d\n",end-start);
    printf("Sum : %lld" , sum);
    unmap_all();
    kill(callerpid , SIGUSR1);
    exit(0);
}

void write_pid_to_file() {
    FILE *pidfptr;
    pidfptr = fopen("pid_file" , "w");
    fprintf(pidfptr,"%d",getpid());
    fclose(pidfptr);
}

int main(int argc , char **argv) {
    if(argc < 2) {
        printf("Error: Usage %s {number of pages}" , argv[0]);
        exit(1);
    }
    write_pid_to_file();
    if(argc >= 3) {
        number_of_loop = atoi(argv[2]);
    } else {
        number_of_loop = 1;
    }
    if(argc == 4) {
        multiplier = atoi(argv[3]);
    } else {
        multiplier = 1;
    }
    num_of_pages = atoi(argv[1]);
    size = 1024 * sizeof(int) * num_of_pages;
    total_size = size/sizeof(int);
    struct sigaction act_filldata;
    struct sigaction act_random_access;
    act_filldata.sa_sigaction = &filldata;
    act_filldata.sa_flags = SA_SIGINFO;
    act_random_access.sa_sigaction = &random_access;
    act_random_access.sa_flags = SA_SIGINFO;

    //signal(SIGUSR1, filldata);
    sigaction(SIGUSR1,&act_filldata , NULL);
    //signal(SIGUSR2, random_access);
    sigaction(SIGUSR2,&act_random_access, NULL);

    while(1) {}
    return 0;
}
