/*
 *
 * struct sockaddr_in
 * {
 *    sin_port;
 *    sin_addr;
 * }
 *
 *  /etc/services ======> getservbyname(service,protocol) ====> s_port
 *  /etc/hosts ========> gethostbyname(host) ======> struct hosten ====> h_addr
 *
 * /etc/services maps service names to port number and protocol
 *  
 *  getservbyname("http", "tcp"); http service name, tcp is protocol
 *  getservbyport(80);
 *
 *  both two return the "struct servent" struct, null pointer return if could not find
 *
 *  struct servent
 *  {
 *    char * s_name;    //official service name
 *    char **s_aliases;  // alias list
 *    int s_port;        //port number
 *    char *s_proto;     // protocol
 *  }
 *
 *
 *  gethostbyname("venus.example.com"); 
 *  gethostbyname("192.158.1.44");
 *  both return "struct hostent" struct
 *
 *  struct hostent
 *  {
 *      char *h_name;   //official name of host
 *      char **h_aliases;   //alias list
 *      int h_addrtype;    //host address type
 *      int h_length;     // length of address
 *      char **h_addr_list;    //list of addresses
 *  }
 *  #define h_addr h_addr_list[0]
 *
 *
 * Finding the service(the Modern way)
 * getaddrinfo("venus.example.com", "http", &hints, &result);
 * "venus.example.com" : machine name
 * "http": service Name
 * &hints: selection criteria
 * &result: linked list of endpoint addresses
 *
 *  the hints argument of getaddrinfo(), lets you constrain the types of endpoint addresses you want.
 *  For example to return only IPV6 UDP endpoints:
 *
 *  struct addrinfo hints;
 *  memset(&hints, 0, sizeof(struct addrinfo));
 *  hints.ai_family = AF_INET6;
 *  hints.ai_socktype = SOCK_DGRAM
 *
 *  add info structure
 *  result->{ai_addr, ai_next}
 *  ai_addr: pointer to a socket address structure
 *  ai_next: pointer to the next addrinfo  structure
 *
 *
 *  struct addrinfo
 *  {
 *    int ai_flags;
 *    int ai_family;   //AF_INET or AF_INET6
 *    int ai_socktype;  //SOCK_DGRAM or SOCK_STREAM
 *    int ai_protocol;
 *    socklen_t  ai_addrlen;  //the length of the sockaddr
 *    struct sockaddr *ai_addr; //Pointer to socket address
*     char  *ai_canonname;
*     struct addrinfo *ai_next;
 *
 *
 *  }
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <netdb.h>

#define BSIZE 1024

main(int argc, char*argv[])
{
  struct hostent *host_info;
  struct sockaddr_in server;
  int sock, count;
  char buf[BSIZE];
  char *server_name;

  /* Get server name from command line. if none, use "localhost"*/
  server_name = (argc>1)? argv[1]: "localhost";

  /*create the socke */
  sock = socket(AF_INET, SOCK_STREAM, 0);
  if(sock < 0)
  {
    perror("creating stream socket");  
    exit(1);
  }

  /*Look up the host's IP address */
  host_info = gethostbyname(server_name);
  if(host_info == NULL)
  {
    fprintf(stderr, "%s:unknown host: %s\n", argv[0], server_name);
    exit(2);
  }

  /*set up the server's socket address */
  server.sin_family = AF_INET;
  memcpy((char*)&server.sin_addr, host_info->h_addr, host_info->h_length);
  server.sin_port = htons(1067);

  if(connect(sock,(struct sockaddr*)&server, sizeof server) < 0)
  {
    perror("connected to server. ");  
    exit(4);
  }

  printf("Connected to server %s\n", server_name);
  while((count = read(0, buf,BSIZE))> 0)
  {
    write(sock, buf, count);
    read(sock, buf, count);
    write(1,buf,count);
  }
}
