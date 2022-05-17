#include "types.h"
#include "stat.h"
#include "user.h"
#include "stddef.h"
#include "syscall.h"


int main(int argc, char *argv[]){
    int child_a, child_b;
    child_a = fork();
    if (child_a == 0) {     
        printf(1,"User: first child process with pid=%d\n", getpid());
	    printf(1,"User: the number of times the system call SYS_write was called in first child process: %d\n" , get_call_count(SYS_write));
	    printf(1,"User: the number of times the system call SYS_fork was called in first child process: %d\n" , get_call_count(SYS_fork));
        printf(1, "\n-----------------------------------------------------------\n");
		exit();
    }
	else{
		child_b = fork();
		if (child_b == 0) {  
            sleep(100);
		    printf(1,"User: second child process with pid=%d\n", getpid());
		    printf(1,"User: the number of times the system call SYS_write was called in second child process: %d\n" , get_call_count(SYS_write));
		    printf(1,"User: the number of times the system call SYS_fork was called in second child process: %d\n" , get_call_count(SYS_fork));
      	  	printf(1, "\n-----------------------------------------------------------\n");
			exit();
        }
  	  	else {
      	  	
      		wait();
       		wait();
            sleep(100);
            printf(1,"User: parent process with pid=%d\n", getpid());
            printf(1,"User: the number of times the system call SYS_write was called in parent process: %d\n" , get_call_count(SYS_write));
	    	printf(1,"User: the number of times the system call SYS_fork was called in parent process: %d\n" , get_call_count(SYS_fork));		
      		printf(1, "\n-----------------------------------------------------------\n");
		}  	  		 	
	}
 	exit();
} 