/* The program :
 * Broadcasting the datagram
 *
 * A Distributed Update Service
 * 1.Multiple Participants
 * 2. Each generates status information periodically
 * 3. Each needs to receive status updates from all the others
 * 4. Each displays the overall status
 */



/*
  *  Broadcast peer-to-peer service using sockets
  *  update1.c This solution generates the x,y values randomly
  *  and displays the received values in a table
  */

/* how to compile*/
/* sudo zypper in ncurses-devel
 *
 * gcc UDPBroadcasting.c -o udpb -lncurses
 *
 *
 */
#include <string.h>
#include <stdlib.h>
#include <netdb.h>
#include <stdio.h>
#include <ncurses.h>

#define  UPDATE_PORT 2066


/* Define the broadcast packet format */
typedef struct packet
{
  char text[64];
  int x;
  int y;
}Packet;

/* Function prototypes */
void display_update(Packet p);


int main(int argc, char *argv[])
{

  int sock;     //Socket descriptor
  struct sockaddr_in server;  //Broadcast address
  struct sockaddr_in client;
  int client_len, yes = 1;
  int count;

  Packet pkt;

  /*Initialise the curses package */
  initscr();
  cbreak();  /*Disable input buffering*/
  noecho();  /* disable echoing*/

  /*Create a datagram socket and enable broadcasting*/
  sock = socket(AF_INET, SOCK_DGRAM,0);
  setsockopt(sock, SOL_SOCKET, SO_BROADCAST, (char*)&yes, sizeof yes);

  /* bind our well-know port number */
  server.sin_family = AF_INET;
  server.sin_addr.s_addr = htonl(INADDR_ANY);
  server.sin_port = htons(UPDATE_PORT);

  if(bind(sock, (struct sockaddr *)&server, sizeof server) < 0)
  {
    printw("server:bind failed\n");
    refresh();
    exit(1);
  }

  server.sin_family = AF_INET;
//  server.sin_addr.s_addr = 0xffffffff;
  server.sin_addr.s_addr = htonl(INADDR_BROADCAST);
  server.sin_port = htons(UPDATE_PORT);

  /*create an additional process. The parent acts as the client,
   * periodically broadcasting updates to anyone who happens to be listening
   * on port 2066, The child acts as the server, 
   * receiving the broadcasts and displaying the data.
   */

  if(fork())
  {
    if(argc > 1) strcpy(pkt.text, argv[1]);
    else gethostname(pkt.text,64);
    pkt.x = 40; pkt.y = 12;
    while(1)
    {
      pkt.x = rand() % 80;
      pkt.y = rand() % 24;
      /*Broadcast update packet ot servers */
      sendto(sock, (char*)&pkt, sizeof pkt, 0,
          (struct sockaddr*)&server, sizeof server);
      sleep(1);
    }
  }
  else
  {
    /*CHILD (server) here */
    /*Enter our service loop, receiving packets 
     * and displaying them in some appropriate way.
     * */
    while(1)
    {
      /*Receive an update packet */
      client_len = sizeof client;
      count = recvfrom(sock, (char*)&pkt, sizeof pkt, 0, (struct sockaddr*)&client, &client_len);
      printf("count %d",count);

      /*Display the packet's contents */
      display_update(pkt);
    }
  }

  return 0;

}

void display_update(Packet p)
{
#define TSIZE 50  
  static char table[TSIZE][64];
  static int entries = 0;
  int i, found=0;
  
  /* Search the table for an entry with a matching text string.
   * if found, the ordinal position of the entry in the table is used 
   * to determing the position on the screen at which this entry will
   * be displayed. The x,y values are only displayed; they are not kept
   * in the table. If no matching entry is found and the table is not full,
   * a new entry is created.
   * */

  for(i=0, found=0; i<entries; i++)
  {
    if(strcmp(p.text, table[i]) == 0)
    {
      found = 1;
      break;
    }
  }
  if(!found)
  {
    if(entries == TSIZE)  /* table is full */
    {
      return; 
    }
    strcpy(table[entries], p.text);
    i = entries++;
  }

  /* update the display of the i'th entry in the table */
  move(i,1);
  printw("%16s %4d %4d", p.text, p.x, p.y);
} 



