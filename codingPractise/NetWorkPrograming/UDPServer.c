/* The program :
 *  rcat venus foo
 *  remote cat  a file and return the file output in the local
 * Receiving a Datagram
 * recvfrom(sock, buff, count, flags, addr, len)
 *
 *
 *
 *  TFTP Paacket Formats
 *  |IP Header  | UdP Header | Opcode 1=RRQ | File name | 0|   Mode     | 0|
 *    20 bytes     8 types       2 types       N bytes         N bytes 
 *
 *                           |Opcode 3=Data | Block number |  data      |
 *                              2 bytes     | 2 bytes      | 0-512 bytes
 *
 *
 *                           |Opcode 4=ACK  | Block number
 *                              2 bytes     | 2 bytes   
 *
 *                           |Opcode 5=error | Error number | Error message | 0 |
 *
 *  TFTP well-known port 69
 *  
 *  tftp service configration:
 *  service tftp
 *  {
 *    protocol = udp
 *    port = 69
 *    socket_type = dgram
 *    wait = yes
 *    user = root 
 *    server = /usr/sbin/in.tftpd
 *    server_args = -s /tftpboot --verbose
 *    disable = no
 *  }
 *
 *  sudo mkdir /tftpboot
 *  sudo chmod 777 /tftpboot/
 *  sudo chwon nobody /tftpboot/
 *  sudo /usr/sbin/rcxined restart
 *
 *
 * c4dev@sles12-liangs4-dev:~> tftp -v 10.244.101.244
 * Connected to 10.244.101.244 (10.244.101.244), port 69
 * tftp> get services
 * getting from 10.244.101.244:services to services [netascii]
 * Transfer timed out.
 *
 * tftp> get services
 *
 *
 * sudo tail -f /var/log/messages
 */



/*
  *   remote cat client using TFTP server(UDP socket implementation).
  *   Usage: rcat hostname filename
  */

#include <string.h>
#include <stdlib.h>
#include <netdb.h>
#include <stdio.h>

#define  TFTP_PORT 69
#define BSIZE  600   /* size of our data buffer */
#define MODE  "octet"

#define OP_RRQ 1
#define OP_DATA 3
#define OP_ACK 4 
#define OP_ERROR 5

int main(int argc, char *argv[])
{

  int sock;
  struct sockaddr_in server;
  struct hostent *host;
  char buffer[BSIZE], *p;
  int count, server_len;

  if(argc != 3)
  {
    fprintf(stderr, "usage: %s hostname filename\n", argv[0]); 
    exit(1);
  }

  /*create a datagram socket*/
  sock = socket(AF_INET, SOCK_DGRAM, 0);

  /*get the server's address */
  host = gethostbyname(argv[1]);
  if(host == NULL)
  {
    fprintf(stderr, "unknown host: %s\n", argv[1]); 
    exit(1);
  }

  server.sin_family = AF_INET;
  memcpy(&server.sin_addr.s_addr, host->h_addr, host->h_length);
  server.sin_port = htons(TFTP_PORT);

  /* build a tftp read request packet. this is messy because the fields have variable
   * length, so we can't use a structure.
   * Note:pointer p is one past the end of the full packet when done!*/

  *(short *)buffer = htons(OP_RRQ);   /*the op-code */
  p = buffer + 2;
  strcpy(p,argv[2]);               /* the file name */
  p += strlen(argv[2]) + 1;       /* keep the nul */
  strcpy(p,MODE);
  p += strlen(MODE) + 1;

  /*Send read Request to tftp server */
  count = sendto(sock, buffer, p-buffer, 0, (struct sockaddr*)&server, sizeof server);

  /*Loop collecting data packets from the server, until a short packet arrives. This indicates the end of the file.*/
  
  do 
  {
    server_len = sizeof server;
    count = recvfrom(sock, buffer, BSIZE, 0,(struct sockaddr*)&server, &server_len);

    if(ntohs(*(short*)buffer) == OP_ERROR)
    {
      fprintf(stderr, "rcat:%s\n",buffer+4);
    } 
    else
    {
      write(1,buffer+4,count-4);
      /*Send an ack packet, the block number we want to ack is
       * already in the buffer so we just need to change the opcode.
       * Note that the aCK is sent to the port number which the server just
       * send the data from, NOT to port 69 */
      *(short *)buffer = htons(OP_ACK);
      sendto(sock,buffer, 4, 0,(struct sockaddr*)&server,sizeof server);
    }
  } while(count == 516);

  return 0;
}



