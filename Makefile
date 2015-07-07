#Makefile for the socket programming example
simple_server_objects = ServerSocket.o Socket.o simple_server_main.o
simple_client_objects = ClientSocket.o Socket.o simple_client_main.o
CXXFLAGS=-std=c++0x #for c++0x Adaptation

all : simple_server simple_client

simple_server: $(simple_server_objects)
	g++ -lgps -o simple_server $(simple_server_objects)


simple_client: $(simple_client_objects)
	g++ -lgps -o simple_client $(simple_client_objects)


Socket: Socket.cpp
ServerSocket: ServerSocket.cpp
ClientSocket: ClientSocket.cpp
simple_server_main: simple_server_main.cpp
simple_client_main: simple_client_main.cpp


clean:
	rm -f *.o simple_server simple_client

