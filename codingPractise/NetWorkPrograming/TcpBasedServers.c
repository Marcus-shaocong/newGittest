/*   The Linux Programming Interface : book 
 *   lsof command 
 *   list network open endpoint
 *   $sudo lsof -i TCP
 *
 *
 * nmap check whick port is opening on a ip address
 * c4dev@sles12-liangs4-dev-01:~/codingPractise/NetWorkPrograming> nmap 10.141.60.62
 *
 * Starting Nmap 6.46 ( http://nmap.org ) at 2016-09-03 09:32 EDT
 * Nmap scan report for 10.141.60.62
 * Host is up (0.022s latency).
 * Not shown: 995 closed ports
 * PORT     STATE SERVICE
 * 22/tcp   open  ssh
 * 111/tcp  open  rpcbind
 * 139/tcp  open  netbios-ssn
 * 445/tcp  open  microsoft-ds
 * 2049/tcp open  nfs
 *
 * Nmap done: 1 IP address (1 host up) scanned in 0.41 seconds
 *
 *
 *  1.The sockaddr_in Structure
 *  struct sockaddr_in
 *  {
 *    sa_family_t  sin_family;    // Address family (AF_INET)
 *    in_port_t    sin_port;
 *    struct in_addr sin_addr;   //Ipv4 address
 *    unsigned char __pad[];
 *  }
 *
 *  2.macros convert to/from the machine's internal byte order
 *  host byte order /network byte order
 *  htons()/ntohs()   host to network short/network to host short 16-version
 *  htol()/ntohl()  host to network long 32-bit version
 *
 *
 *  3.create a socket
 *  sock = socket(doman, type, protocol);
 *  domain:AF_UNIX/AF_INET/AF_INET6 AF_UNIX: name pipe
 *  type: SCOK_STREAM/SOCK_DGRAM 
 *  protocol: usually 0, system selects protocol based on domain and type
 *
 *  Setting the local Address
 *
 *  4.#define SERVER_PORT 1067
 *  struct sockaddr_in   server;
 *  server.sin_family  = AF_INET;
 *  server.sin_addr.s_addr = htonl(INADDR_ANY);
 *  server.sin_port   = htons(SERVER_PORT);
 *
 *  bind(sock,(struct sockaddr*)&server, sizeof server);
 *
 *  #address just a unsigned int number
 *  c4dev@sles12-liangs4-dev-01:~/codingPractise/NetWorkPrograming> grep -r 'typedef.*in_addr_t;' /usr/include
 *  /usr/include/netinet/in.h:typedef uint32_t in_addr_t;
 *  /usr/include/apr-1/apr_network_io.h:typedef struct in_addr          apr_in_addr_t;
 *
 * */

#include <netinet/in.h>
#include <netdb.h>
#include <stdlib.h>
#include <stdio.h>


#define SERVER_PORT 1067

void rot13(unsigned char* s, int n)
{
  unsigned char *p;
  for(p=s; p<s+n; p++)
  {
    if(islower(*p))
    {
      *p += 13;
      if(*p > 'z') *p -= 26;
    }
  }
}

void rot13_service(int in, int out)
{
  unsigned char buf[1024];
  int count;
  while(( count = read(in, buf, 1024)) > 0)
  {
    rot13(buf,count);
    write(out, buf, count);
  }
}


void main()
{
  int sock, fd, client_len;
  struct sockaddr_in server, client;
  struct servent *service;

  sock = socket(AF_INET, SOCK_STREAM, 0);
  server.sin_family  = AF_INET;
  server.sin_addr.s_addr = htonl(INADDR_ANY);
  server.sin_port   = htons(SERVER_PORT);
  
  bind(sock, (struct sockaddr*)&server, sizeof(server));
  listen(sock, 5);
  printf("listening ...\n");

  while(1)
  {
    client_len = sizeof(client);
    fd = accept(sock, (struct sockaddr *)&client, &client_len);
    printf("got connection\n");
    rot13_service(fd,fd);
    close(fd);
  }
}



