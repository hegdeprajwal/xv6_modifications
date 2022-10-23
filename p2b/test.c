#include "types.h"
#include "user.h"
#include "pstat.h"

int
main(int argc, char *argv[])
{
// TBD :: check for the NULL case 
	// struct pstat ps;
	
  // int status = settickets(0);

  // printf(1, "status = %d\n", status);



  // int pid = fork();
  // int status2 ;
  // if ( pid == 0) {
    
  //   status = settickets(1);
  //   status2 = getpinfo(&ps);
  //   printf(1, "status = %d\n", status2);
  //   wait();
  //   for ( int i = 0 ; i < NPROC ; i++) 
  //     printf(1,"->-> i = %d tickets = %d pid = %d ticks = %d\n" ,i, ps.tickets[i], ps.pid[i], ps.ticks[i]);
  // }
  // else {
  //     status2 = getpinfo(&ps);
  //     for ( int i = 0 ; i < NPROC ; i++) 
  //       printf(1,"->-> i = %d tickets = %d pid = %d ticks = %d\n" ,i, ps.tickets[i], ps.pid[i], ps.ticks[i]);
  // }

   int * mem = malloc(10);
   printf(1, "value in mem = %x" , *mem);

  exit();
}
