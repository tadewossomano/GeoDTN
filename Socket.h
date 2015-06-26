#ifndef Socket_class
#define Socket_class
#include <libgpsmm>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <string>
#include <arpa/inet.h>
#include<cmath>
#include<ctgmath>
#include<inttypes.h>
#include<unistd.h>
#include<sys/socket.h>
#include<sys/types.h>
#include<netdb.h>
#include<stdio.h> 
#include<netinet/in.h>
#include<sys/param.h>
struct val {
double val1;
double val2;
double val3;
double val4;
double val5;
double val6;};
/******************************/
struct val2{
double val1;
double val2;
double val3;
double val4;
double val5;
double val6;};
/******************************/
const int equatorial_radius=6378200;
const int polar_radius =6356750;
const double pi=3.14159265359;
//#define _USE_MATH_DEFINES  //to use pi from math
//M_PI  //pi 
/******************************/
const int MAXHOSTNAME = 200;
const int MAXCONNECTIONS = 5;
const int MAXRECV = 500;



class Socket
{
 public:
  Socket();
  virtual ~Socket();

  // Server initialization
  bool create();
  bool bind ( const int port );
  bool listen() const;
  bool accept ( Socket& ) const;

  // Client initialization
  bool connect ( const std::string host, const int port );

  // Data Transimission
  bool send (val2) const;
  int recv( val ) const;//((char*)gps_data_t*);//


  void set_non_blocking ( const bool );

  bool is_valid() const { return m_sock != -1; }

 private:

  int m_sock;
  sockaddr_in m_addr;
  /////////////////////////////////////////////
double displacement=0;
double speed=0;
double theta=0 ;
double lat_d=0;
double long_d=0;
double alt_d=0;
///////////////////////////////////////////////



};


#endif
