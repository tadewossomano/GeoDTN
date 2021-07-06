#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <assert.h>
#include "scheduler.h"

// Experiment parameters
#define R 10e6                      // Channel rate
#define L 512                       // Packet length as produced by application
#define TARR 1000e-6                 // Mean arrival time
#define TTOT 4000                   // Total simulation time
#define IFG 9.6e-6                  // Inter Frame Gap

// Calculated parameters
int Lip = L + 28;                   // IP header length
int Leth = Lip + 26;                // Ethernet header length
double TTR = 8 * Leth / R + IFG;    // Time needed to transmit a packet
double mu = 1/TARR;                 // Mean number of arrivals

// Definition of boolean values
enum { FALSE = 0, TRUE };

// State variables
int queue = 0;                      // Queue length
int idle = TRUE;                    // Channel state
int packets = 0;                    // Number of generated packets (include rescheduled...)
int txpackets = 0;                  // Number of transmitted packets
int droppedpackets = 0;             // Number of dropped packets
int queuemax = 0;                   // Maximum queue fill level
int queuesample = 0;                // Number of times the queue level was sampled
#define QUEUE_FINITE
int queuelen = 6;
double firstmean;                   // When the first queue measure has been performed
double queuetot = 0;                // Cumulative queue length
double startidle = 0;               // When the last idle period has begun
double cumidle = 0;                 // Cumulative idle period
long totidle = 0;                   // Number of idle period monitored
#define QUEUE_TEST_MAX 50
int queuetest[QUEUE_TEST_MAX];

// handlers' ids
enum { arrival , txEnd };

void newPacketArrived(message* e, scheduler* sched) {
     // present time
     double now = e->time;

     // refresh the number of generated packets
     packets++;

     // create a message for the next arrival
     message* ne = new message();
     ne->time = now - log( 1 - drand48() )/mu;
     ne->handler = arrival;
     sched->insert( ne );

     // if channel is idle schedule a transmission re-start
     if ( idle == TRUE ) {
	  idle = FALSE;
	  message* ne = new message();

	  // when transmission will end
	  ne->time = now + TTR;
	  ne->handler = txEnd;
	  sched->insert( ne );

	  // refresh statistic on idle periods
	  cumidle += (now - startidle);
	  totidle ++;
	  // printf("qua %e 1\n", now);

	  assert(queue == 0);
	 
	  // track here otherwise we will lose this information
	  // NOTE we count the state that we will have
	  // in this case we were in status 0 and we go to status 1
	  if(queue + 1 < QUEUE_TEST_MAX)
	       queuetest[queue + 1]++;
	  else
	       queuetest[QUEUE_TEST_MAX]++;

	  // refresh the cumulative queue length
	  queuetot += queue + 1;
	  queuesample++;
     }

     // enqueue the packet
     queue++;
#ifdef QUEUE_FINITE
     // threshold is one packet above because the first
     // is being transmitted (already picked from the queue)
     // note: imagine one packet arrived when the queue is
     // empty. In this case the queue will count 1 and a txend
     // event is scheduled. If between now and txend another
     // packet arrive the model says that we will stay in status n=1
     // starting from status n=1.
     // But this handler will be called a second time, queue was 1
     // now it becomes 2 and if queuelen is only one then we will
     // drop this packet. For this reason we allow one packet more.
     if(queue > queuelen+1) {
	  queue = queuelen+1;
	  droppedpackets++;
     }
#endif
     if(queue > queuemax)
	  queuemax = queue;
}

void endTransmission(message* e, scheduler* sched) {

     // refresh number of transmitted packets
     txpackets++;
    
     // present time
     double now = e->time;

     // remove packet from the queue
     assert(queue > 0);
     queue--;

     // maintain queue status information
     if(queue < QUEUE_TEST_MAX)
	  queuetest[queue]++;
     else
	  queuetest[QUEUE_TEST_MAX]++;

     // refresh the cumulative queue length
     queuetot += queue;
     queuesample++;

     // if queue is empty set the channel idle and leave
     if ( queue == 0 ) {
	  idle = TRUE;
	  startidle = now;
	  return;
     }

     // there are other packeets: schedule next transmission end
     message* ne = new message();
     ne->time = now + TTR;
     ne->handler = txEnd;
     sched->insert( ne );
}

int main(int argc,char *argv[]) {

     int i;
     for(i = 0; i < QUEUE_TEST_MAX; i++)
	  queuetest[i] = 0;

     printf("mean arrival time %f\n", TARR);
     printf("tx duration %f\n", TTR);

     // if a parameter has been given use it to initialize the random number generator
     if ( argc > 1 )
	  srand48(atoi(argv[1]));

     // create a new scheduler
     scheduler sched;

     // schedule the first arrival
     message* fe = new message();
     fe->time = 0;
     fe->handler = arrival;
     sched.insert(fe);

     double now;

     // loop on all events
     while ( 1 ) {

	  // get the first message from the list
	  message * e = sched.pop();
	  now = e->time;

	  // if present time is beyond simulation time leave
	  if ( now > TTOT ) break;

	  // dispatch this message to its handler
	  switch ( e->handler ) {
	  case arrival:
	       newPacketArrived( e , &sched );
	       break;
	  case txEnd:
	       endTransmission( e , &sched );
	       break;
	  default:
	       printf("???\n");
	       exit(-1);
	  }

	  // discard this message
	  delete( e );
     }

     // display results
     printf("queue monitored for %f seconds\n", (float) (now-firstmean) );
     printf("queue mean occupation = %f\n", (float) (queuetot/queuesample) );
     printf("number of generated packets = %d\n", packets);
     printf("number of transmitted packets = %d\n", txpackets);
     printf("number of dropped packets = %d\n", droppedpackets);
     printf("number of packets in queue at sim end = %d\n", queue);
     printf("probability of transmission = %f\n", txpackets * TTR / now);
     printf("maximum number of packets in the queue = %d\n", queuemax);
     printf("mean idle time = %f\n", (float) (cumidle/totidle) );
     printf("asintotic probabilities:\n");
     long long summa = 0;
     int boundary;
     if(queuemax + 1 < QUEUE_TEST_MAX)
	  boundary = queuemax + 1;
     else
	  boundary = QUEUE_TEST_MAX;
     for(i = 0; i < boundary; i++)
	  summa += queuetest[i];
     for(i = 0; i < boundary; i++)
	  printf("%d %f\n", i, float(queuetest[i])/float(summa) );

     // print events still in the list
     sched.walk();
     return 0;
}
