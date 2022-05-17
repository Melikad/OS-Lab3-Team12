#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
int
sys_find_next_prime_number(void)
{
  int number = myproc()->tf->ebx; //register after eax
  cprintf("Kernel: sys_find_next_prime_num() called for number %d\n", number);
  return find_next_prime_number(number);
}

int 
sys_get_call_count(void)
{
  int  *cnt;
  int sys_num;
  struct proc *curproc = myproc();
  argint(0, &sys_num);
  cnt = curproc->syscnt;
  return *(cnt+sys_num-1);
}

int
sys_get_most_caller(void)
{
  int sys_num;
  argint(0, &sys_num);
  return get_most_caller(sys_num);
}

int 
sys_wait_for_process(void)
{
  int pid;
  argint(0, &pid);
  return wait_for_process(pid);

}


int
sys_set_proc_queue(void)
{
  int pid;
  if(argint(0, &pid) < 0)
    return -1;

  int q_num;
  if(argint(1, &q_num) < 0)
    return -1;
  
  set_proc_queue(pid, q_num);
  return 0;
}

int
sys_set_tickets(void)
{
  int pid;
  if(argint(0, &pid) < 0)
    return -1;

  int tickets;
  if(argint(1, &tickets) < 0)
    return -1;

  set_tickets(pid, tickets);
  return 0;
}

int
sys_set_bjf_params_in_proc(void)
{
  int pid;
  if(argint(0, &pid) < 0)
    return -1;

  int pratio;
  if(argint(1, &pratio) < 0)
    return -1;

  int atratio;
  if(argint(2, &atratio) < 0)
    return -1;
  
  int ecratio;
  if(argint(3, &ecratio) < 0)
    return -1;

  set_bjf_params_in_proc(pid, pratio, atratio, ecratio);
  return 0;
}

int
sys_set_bjf_params_in_system(void)
{
  int pratio;
  if(argint(0, &pratio) < 0)
    return -1;

  int atratio;
  if(argint(1, &atratio) < 0)
    return -1;
  
  int ecratio;
  if(argint(2, &ecratio) < 0)
    return -1;
  
  set_bjf_params_in_system(pratio, atratio, ecratio);
  return 0;
}

int
sys_print_info(void)
{
  print_info();
  return 0;
}

