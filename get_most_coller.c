#include "types.h"
#include "stat.h"
#include "user.h"
#include "stddef.h"
#include "syscall.h"

int main(int argc, char *argv[]){
    printf(1,"The most caller process for SYS_fork : pid=%d \n", get_most_caller(SYS_fork));
    printf(1,"The most caller process for SYS_write : pid=%d \n", get_most_caller(SYS_write));
    printf(1,"The most caller process for SYS_wait : pid=%d \n", get_most_caller(SYS_wait));
    exit();
}