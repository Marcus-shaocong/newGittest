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
 *  }
 *
 *  Note: how to run this program
 *
 * #add following line in /etc/services file
 * #local services
 * rot13                   1067/tcp                        #rot13 service
 * 
 * # using folling command to run
 * #./client localhost rot13 abcd apple orange
 *
 */

#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <netdb.h>
#include <unistd.h>
#include <string.h>

#define BUF_SIZE 500

int main(int argc, char*argv[])
{
  struct addrinfo hints;
  struct addrinfo *result, *rp;
  int sfd, s, j;
  size_t len;
  ssize_t nread;
  char buf[BUF_SIZE];

  if(argc < 3)
  {
    fprintf(stderr, "Usage: %s:host port msg ...\n", argv[0]);
    exit(EXIT_FAILURE);
  }

  /*obtain address(es) matching host/port */

  memset(&hints, 0, sizeof(struct addrinfo));
  hints.ai_family = AF_UNSPEC;  /* allow IPv4 or IPv6 */
  hints.ai_socktype = SOCK_STREAM;  /* Stream socket(TCP) */
  hints.ai_flags = 0;
  hints.ai_protocol =  0;     /* Any protocol*/

  s = getaddrinfo(argv[1], argv[2], &hints, &result);
  if(s != 0)
  {
    fprintf(stderr, "getaddrinfo:%s\n", gai_strerror(s));
    exit(EXIT_FAILURE);
  }

  /* getaddrinfo() returns a list of address structures.
   * try each address until we successfully connect(2).
   * if socket(2)(or connect(2)) fails, we (close the socket
   * and ) try the next address */

  for(rp = result; rp != NULL; rp=rp->ai_next)
  {
    sfd = socket(rp->ai_family, rp->ai_socktype, rp->ai_protocol);
    if(sfd == -1)
      continue;
    if(connect(sfd, rp->ai_addr, rp->ai_addrlen) != -1)
      break;
    close(sfd);
   }

  if(rp == NULL)
  {
    fprintf(stderr, "could not connect\n");
    exit(EXIT_FAILURE);
  }

  freeaddrinfo(result);

  for(j=3; j<argc; j++)
  {
    len = strlen(argv[j]) +1;
    if(len +1 > BUF_SIZE)
    {
      fprintf(stderr, "Ignoring long message in argument %d\n", j);
      continue;
    }

    if(write(sfd,argv[j],len) != len)
    {
      fprintf(stderr, "partial/failed write \n");
      exit(EXIT_FAILURE);
    }
    nread = read(sfd, buf, BUF_SIZE);
    if(nread == -1)
    {
      perror("read");
      exit(EXIT_FAILURE);
    }
    printf("Received %ld bytes: %s\n", (long)nread, buf);
  }

   exit(EXIT_SUCCESS);
}
