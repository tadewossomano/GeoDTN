nclude "Socket.h"
#include "string.h"
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include<iostream>
#include <string>
#include <sstream>
#include<iostream>
#include <libgpsmm.h>
//#include <libgpsmm>
#include<gps.h>
#include<cmath>
using namespace std;
Socket::Socket() :
  m_sock ( -1 )
{

  memset ( &m_addr,
	   0,
	   sizeof ( m_addr ) );

}

Socket::~Socket()
{
  if ( is_valid() )
    ::close ( m_sock );
}

bool Socket::create()
{
  m_sock = socket ( AF_INET,
		    SOCK_STREAM,
		    0 );

  if ( ! is_valid() )
    return false;


  // TIME_WAIT - argh
  int on = 1;
  if ( setsockopt ( m_sock, SOL_SOCKET, SO_REUSEADDR, ( const char* ) &on, sizeof ( on ) ) == -1 )
    return false;


  return true;

}



bool Socket::bind ( const int port )
{

  if ( ! is_valid() )
    {
      return false;
    }



  m_addr.sin_family = AF_INET;
  m_addr.sin_addr.s_addr =INADDR_ANY;
  m_addr.sin_port = htons( port );

  int bind_return = ::bind ( m_sock,
			     ( struct sockaddr * ) &m_addr,
			     sizeof ( m_addr ) );


  if ( bind_return == -1 )
    {
      return false;
    }

  return true;
}


bool Socket::listen() const
{
  if ( ! is_valid() )
    {
      return false;
    }

  int listen_return = ::listen ( m_sock, MAXCONNECTIONS );


  if ( listen_return == -1 )
    {
      return false;
    }

  return true;
}


bool Socket::accept ( Socket& new_socket ) const
{
  int addr_length = sizeof ( m_addr );
  new_socket.m_sock = ::accept ( m_sock, ( sockaddr * ) &m_addr, ( socklen_t * ) &addr_length );

  if ( new_socket.m_sock <= 0 )
    return false;
  else
    return true;
}

bool Socket::send(val2 values3 ) const 
{

  int status = ::send ( m_sock,&values3, sizeof(struct val2), 0 );//::send ( m_sock,&s, sizeof(s), 

//MSG_NOSIGNAL );

  if ( status == -1 )
    {
      return false;
    }
  else
    {
      return true;
    }
}


int Socket::recv(val values2 )  const
{
  char buf [ MAXRECV + 1 ];//char buf [ MAXRECV + 1 ];
int rx=0;
double displacement;
double speed;
double theta ;
double lat_d;
double long_d;
double alt_d;


 // s = "";//gpsdata="";//

  memset ( buf, 0, MAXRECV + 1 );

  int status = ::recv ( m_sock, buf, MAXRECV, 0 );

  if ( status == -1 )
    {
      std::cout << "status == -1   errno == " << errno << "  in Socket::recv\n";
      return 0;
    }
  else if ( status == 0 )
    {
      return 0;
    }
  else
    {
struct val *values=(struct val*) buf;
if(!std::isnan(values->val1) && !std::isnan(values->val2) && !std::isnan(values->val3) && !std::isnan(values->val4),!std::isnan(values->val5),!std::isnan(values->val6))

printf("received:%f %f %f %f %f %f\n",values->val1,values->val2,values->val3,values->val4,values->val5,values->val6);
//////////////////////
/*
//struct val2 values3 ;
//values3={newdata->fix.latitude,newdata->fix.longitude,newdata->fix.altitude,newdata->fix.speed,newdata->fix.track,newdata->fix.time};
////////////////////////
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


 ************************* */    

//close(m_sock);
      return status;

    }

}



bool Socket::connect ( const std::string host, const int port )
{
  if ( ! is_valid() ) return false;

  m_addr.sin_family = AF_INET;
  m_addr.sin_port = htons ( port );

  int status = inet_pton ( AF_INET, host.c_str(), &m_addr.sin_addr );

  if ( errno == EAFNOSUPPORT ) return false;

  status = ::connect ( m_sock, ( sockaddr * ) &m_addr, sizeof ( m_addr ) );

  if ( status == 0 )
    return true;
  else
    return false;
}

void Socket::set_non_blocking ( const bool b )
{

  int opts;

  opts = fcntl ( m_sock,
		 F_GETFL );

  if ( opts < 0 )
    {
      return;
    }

  if ( b )
    opts = ( opts | O_NONBLOCK );
  else
    opts = ( opts & ~O_NONBLOCK );

  fcntl ( m_sock,
	  F_SETFL,opts );

}

