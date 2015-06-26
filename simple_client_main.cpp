#include "ClientSocket.h"
#include "Socket.h"
#include "SocketException.h"
#include <iostream>
#include <string>
#include <libgpsmm>
#include<inttypes.h>
#include<unistd.h>
#include<arpa/inet.h>
#include<sys/socket.h>
#include<sys/types.h>
#include<netdb.h>
#include<stdio.h> 
#include<netinet/in.h>
#include<sys/param.h>
#include<cmath>
#include<ctgmath>

using namespace std;

int main ( int argc, char * argv[] )
{
  try
    {

ClientSocket client_socket ("192.168.1.2",30000);
/////////////////////////////////////////////
gpsmm gps_rec("localhost", DEFAULT_GPSD_PORT);

    if (gps_rec.stream(WATCH_ENABLE|WATCH_JSON) == NULL) 
            {
        std::cerr << "No GPSD running.\n";
        return 1;
             }

    for (;;) 
         {
        struct gps_data_t* newdata;

        if (!gps_rec.waiting(50000000))
          continue;

        if ((newdata = gps_rec.read()) == NULL) {
            cerr << "Read error.\n";
            return 1;}


         else 
{
 

      try
	{


struct val2 values3={newdata->fix.latitude,newdata->fix.longitude,newdata->fix.altitude,newdata->fix.speed,newdata->fix.track,newdata->fix.time};

  client_socket <<values3;
values3={};

}
      catch ( SocketException& ) {}
      
    
        }
    }
    }

  catch ( SocketException& e )
    {
      std::cout << "Exception was caught:" << e.description() << "\n";
    }
///////////////////////////////////////////////////

  return 0;
}

