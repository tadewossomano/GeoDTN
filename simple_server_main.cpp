nclude "ServerSocket.h"
#include "SocketException.h"
#include <string>
#include<iostream>
#include<vector>
#include<sstream>
int main ( int argc, char * argv[] )
{
  std::cout << "running....\n";
/////////////////////////////////////////////
double displacement;
double speed;
double theta ;
double lat_d;
double long_d;
double alt_d;
///////////////////////////////////////////////

  try
    {
      // Create the socket
      ServerSocket server ( 30000 );

      while ( true )
	{

	  ServerSocket new_sock;
	  server.accept ( new_sock );

	  try
	    {
	      while ( true )
		{                
struct val values;
new_sock >> values ;
values={};
//data="";
/*
/////////////////////////////////////////
gpsmm gps_rec("localhost", DEFAULT_GPSD_PORT);

///////////////////////////////////////
*/
struct val2 values3;
	  
		  new_sock << values3;
/**************************************************************************/
theta=values3.val5-values.val5;
displacement=sqrt(pow((values3.val1-values.val1)*(pi*polar_radius/180),2)+pow(((values3.val2-values.val2)*pi*polar_radius/180)*cos((values3.val1+values.val1)/2),2)+pow((values3.val3-values.val3)/3.2808,2));
//lat_d=pow((values3.val1-values->val1)*(pi*polar_radius/180),2);
//long_d=pow(((values3.val2-values->val2)*pi*polar_radius/180)*cos((values3.val1+values->val1)/2)),2);
//alt_d=pow((values3.val3-values->val3)/3.2808,2);
printf("local values:%f %f %f %f %f %f \n",values3.val1,values3.val2,values3.val3,values3.val4,values3.val5,values3.val6);
//displacement=sqrt(lat_d+long_d+alt_d);//line 171
if( theta >=0 ||theta <=180)
speed=sqrt(pow(values3.val4,2)+pow(values.val4,2)-2*values3.val4*values.val4*cos(theta*pi/180));
else 
speed=sqrt(pow(values3.val4,2)+pow(values.val4,2)-2*values3.val4*values.val4*cos(abs(theta*pi/180)));//here one condition should be added to include nodes moving towards each other.
printf("RawGeo Parameters:%f %f \n",displacement,speed);

/***************************************************************************/
		}
	    }
	  catch ( SocketException& ) {}

	}
    }
  catch ( SocketException& e )
    {
      std::cout << "Exception was caught:" << e.description() << "\nExiting.\n";
    }

  return 0;
}

