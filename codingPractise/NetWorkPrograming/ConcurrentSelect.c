
/*
 *
 *  The selet() system call
 *  select(max, rfds, wfds, xfds, tiemout);
 *  rdfs: the set of descriptors to monitor for reading
 *  wdfs: the set of descriptors to monitor for writing 
 *  xfds: the set of descriptors for "exceptional conditions", arrival of out-of-bound data
 *  max: Highest file descriptor +1, one larger than the biggest file descriptor you want to monitor.
 *
 *  FD_ZERO: remoe all descriptors from set 
 *  FD_SET: add descriptors to the set with FD_SET
 *  pass a pointer to the descriptor set in the select call
 *  when select returns, the descriptor sets will have been modified ot include only
 *  those descriptor that are actually ready 
 *  you need to make a copy of the descriptor set before you pass it to the call.
 *  Example:
 *  fd_set myset;
 *
 *  FD_ZERO(&myset);
 *  FD_SET(f1, &myset);
 *  FD_SET(f2, &myset);
 *  select(16, &myset, NULL, NULL, NULL);
 *  if(FD_ISSET(f1, &myset))
 *  {
 *     //Read froom descriptor f1
 *  }
 *
 */

/* Concurrent server using TCP and select()*/
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <netinet/in.h>
#include <string.h>
#include <sys/time.h>

#define GUESS_PORT 1500 /* out well-known port number*/

/*Function Prototypes */
int process_request(int fd);
// This is where we store the pre-client state (the number to guess)
// This array is indexed by the connection descriptor
int target[FD_SETSIZE];

extern time_t time();


int main(int argc, char*argv[])
{
  int sock, fd;
  int client_len;
  struct sockaddr_in server, client;

  /*These are the socket sets used by select() */
  fd_set test_set, ready_set;

  printf("FD_SETSIZE=%d\n", FD_SETSIZE);
  /*mark all entries in the target table as free */
  for(fd=0; fd<FD_SETSIZE; fd++)
  {
    target[fd] = 0;
  }
    
  /*Create the rendezvous socket & bind the well-known port */
  
  sock = socket(AF_INET, SOCK_STREAM,PF_UNSPEC);
  server.sin_family = AF_INET;
  server.sin_addr.s_addr = htonl(INADDR_ANY);
  server.sin_port = htons(GUESS_PORT);
  if(bind(sock, (struct sockaddr*)&server, sizeof(server))<0)
  {
    fprintf(stderr, "binding failed.\n");  
    exit(1);
  }

  listen(sock, 5);

  /*Initialy, the "test set" has in it just the rendezvous descriptor */
  FD_ZERO(&test_set);
  FD_SET(sock, &test_set);
  printf("server ready\n");

  /*here is the head of the main service loop*/
  while(1)
  {
    /*because select overwrites the descriptor set, we must not use our "permanent" set here, 
     * we must use a copy.
     * */
    memcpy(&ready_set, &test_set, sizeof test_set);
    select(FD_SETSIZE, &ready_set, NULL, NULL, NULL);
    /*Did we get a new connection request? if so, we accept it. add
     * the new descriptor into the read set, choose a random number for this client to guess
     * */
    if(FD_ISSET(sock, &ready_set))
    {
      client_len = sizeof client;
      fd = accept(sock, (struct sockaddr*)&client, &client_len);
      FD_SET(fd, &test_set);
      printf("new connection on fd %d\n", fd);
      target[fd] = 1 + rand() % 1000;
    }
    /* Now we must check each descriptor in the read set in turn.
     * for each one which is ready, we process the client request.
     */
    for(fd=0; fd<FD_SETSIZE; fd++)
    {
      if(fd == sock )continue;
      if(target[fd] == 0) continue;
      if(FD_ISSET(fd, &ready_set))
      {
        if(process_request(fd) < 0)
        {
          close(fd);
          FD_CLR(fd, &test_set);
          target[fd] = 0;
          printf("closing fd= %d \n", fd);
        }
      }
    }
  }
  return 0;

}


int process_request(int fd)
{
  int guess;
  char inbuffer[100], *p = inbuffer;

  //Read a guess from the client
  if(read(fd, inbuffer, 100) <= 0)
  {
    return -1; 
  }
  guess = atoi(inbuffer);
  printf("received guess %d on fd=%d\n", guess, fd);

  if(guess > target[fd])
  {
    write(fd, "too big\n", 8);
    return 0;
  } 
  if(guess > target[fd])
  {
    write(fd, "too small\n", 10);
    return 0;
  }
  write(fd, "correct!\n", 9);
  return -1;

} 
