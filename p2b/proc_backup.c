void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;

  int isHigh = 1;
  int lowprio_count = 0;
  
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){

      // maintain a counter of the ticket - 0 level
      if ( p->ticket != 1 ) {
        lowprio_count ++; 
      }

      //if all the processes have low_prio then execute low prio
      if ( lowprio_count == NPROC ) {
        isHigh = 0; 
      }

      if(p->state != RUNNABLE)
        continue;

      //if all the entries are not checked for the high priority ones skip the low priority ones
      if ( isHigh && p->ticket == 0) {
        continue;
      }

      //if no high iterate and execute the low_priority ones
      if ( isHigh == 0 ) {
        struct proc *temp_p;
        for ( temp_p = ptable.proc ; temp_p < &ptable.proc[NPROC] ; temp_p++) {
          if(temp_p->state != RUNNABLE)
            continue;
          if (temp_p->state == RUNNABLE) {
            p = temp_p;  
            //iterate over the list to check if high is there again before choosing next runnable
            isHigh = 1;
          }

        } 
      } 

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      //change the page table descriptor to use target page table
      switchuvm(p);
      //change the status of the process structure
      p->state = RUNNING;
      //give command to hardware to save current context and load new process context 
      // c-> scheduler saves the context of running process and p-> context new process
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);

  }
}
