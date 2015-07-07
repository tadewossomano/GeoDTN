
#include "ServerSocket.h"
#include "SocketException.h"
#include "ClientSocket.h"
#include"Socket.h"
#include <string>
#include<iostream>
#include<vector>
#include<sstream>
#include <libgpsmm.h>
#include<gps.h>
using namespace std;
int main ( int argc, char * argv[] )
{
Socket skt;
  std::cout << "running....\n";
/////////////////////////////////////////////
double displacement;
double speed;
double theta ;
double lat_d;
double long_d;
double alt_d;
  char buf [ MAXRECV + 1 ];
//struct gps_data_t* newdata;
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

 if(!std::isnan(values.val1) && !std::isnan(values.val2) && !std::isnan(values.val3) && !std::isnan(values.val4),!std::isnan(values.val5),!std::isnan(values.val6))
printf("received:%f %f %f %f %f %f\n",skt.recv2(values).val1,skt.recv2(values).val2,skt.recv2(values).val3,skt.recv2(values).val4,skt.recv2(values).val5,skt.recv2(values).val6);

//printf("received:%f %f %f %f %f %f\n",values.val1,values.val2,values.val3,values.val4,values.val5,values.val6);
/*************************************************************************************
**************************************************************************************
//try
//{
	
//////////////////////////////////////////////////////////////////////////

//struct val values;//=(struct val*) buf;
//struct val values;
//new_sock >> values ;

//if(!std::isnan(values.val1) && !std::isnan(values.val2) && !std::isnan(values.val3) && !std::isnan(values.val4),!std::isnan(values.val5),!std::isnan(values.val6))

//printf("received:%f %f %f %f %f %f\n",values.val1,values.val2,values.val3,values.val4,values.val5,values.val6);
//values={};

//struct val2 values3={newdata->fix.latitude,newdata->fix.longitude,newdata->fix.altitude,newdata->fix.speed,newdata->fix.track,newdata->fix.time};

  //client_socket <<values3;
//new_sock << values3;
//values3={};


///////////////////////////////////////////////////////////////////////////////////////

//struct val2 values3;
	  
		  //new_sock << values3;
/**************************************************************************
theta=values3.val5-values->val5;
displacement=sqrt(pow((values3.val1-values->val1)*(pi*polar_radius/180),2)+pow(((values3.val2-values->val2)*pi*polar_radius/180)*cos((values3.val1+values->val1)/2),2)+pow((values3.val3-values->val3)/3.2808,2));
//lat_d=pow((values3.val1-values->val1)*(pi*polar_radius/180),2);
//long_d=pow(((values3.val2-values->val2)*pi*polar_radius/180)*cos((values3.val1+values->val1)/2)),2);
//alt_d=pow((values3.val3-values->val3)/3.2808,2);
printf("local values:%f %f %f %f %f %f \n",values3.val1,values3.val2,values3.val3,values3.val4,values3.val5,values3.val6);
//displacement=sqrt(lat_d+long_d+alt_d);//line 171
if( theta >=0 ||theta <=180)
speed=sqrt(pow(values3.val4,2)+pow(values->val4,2)-2*values3.val4*values->val4*cos(theta*pi/180));
else 
speed=sqrt(pow(values3.val4,2)+pow(values->val4,2)-2*values3.val4*values->val4*cos(abs(theta*pi/180)));//here one condition should be added to include nodes moving towards each other.
printf("RawGeo Parameters:%f %f \n",displacement,speed);

//values={};
//values3={};
***************************************************************************/


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
