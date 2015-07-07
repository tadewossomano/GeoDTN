// Implementation of the ClientSocket class

#include "ClientSocket.h"
#include "SocketException.h"
#include <string>

ClientSocket::ClientSocket ( std::string host, int port )
{
  if ( ! Socket::create() )
    {
      throw SocketException ( "Could not create client socket." );
    }

  if ( ! Socket::connect ( host, port ) )
    {
      throw SocketException ( "Could not bind to port." );
    }

}


const ClientSocket& ClientSocket::operator << ( val2 values3 ) const
{
  if ( ! Socket::send (values3 ))//( gpsdata->fix.latitude ))//
    {
      throw SocketException ( "Could not write to socket." );
    }

  return *this;

}


const ClientSocket& ClientSocket::operator >> ( val  values  ) const
{
  if ( ! Socket::recv(values  ) )//(gpsdata->fix.latitude )) //;
    {
      throw SocketException ( "Could not read from socket." );
    }

  return *this;
}
