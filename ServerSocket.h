#ifndef ServerSocket_class
#define ServerSocket_class
#include "Socket.h"
class ServerSocket : private Socket
{
 public:

  ServerSocket ( int port );
  ServerSocket (){};
  virtual ~ServerSocket();

  const ServerSocket& operator <<(val2) const;
  const ServerSocket& operator >>( val) const;

  void accept ( ServerSocket& );

};


#endif

