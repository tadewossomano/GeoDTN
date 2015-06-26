#ifndef ClientSocket_class
#define ClientSocket_class
#include <libgpsmm.h>
#include "Socket.h"
#include <string>
class ClientSocket : private Socket
{
 public:

  ClientSocket ( std::string host, int port );
  virtual ~ClientSocket(){};

  const ClientSocket& operator << (  val2) const;
  const ClientSocket& operator >> ( val) const;

};


#endif
