/*   The Parent process
 *     Create socket
 *        | |
 *        \_/ 
 *     Bind port number 
 *        | |
 *        \_/ 
 *     Accept connection   <======
 *        | |                    ||
 *        \_/                    ||
 * ===== Fork                    ||
 * ||     | |                    ||
 * ||     \_/                    ||
 * ||  Close connection descriptor
 * ||
 * ||      The Child Process
 * ||----> Close rendezvous descriptro
             | |
             \_/ 
 *          Talk to client using connection descriptor
             | |
             \_/ 
 *          exit()    
 */

/* Concurrent hangman server */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <netdb.h>
#include <signal.h>
#include <netinet/in.h>

extern time_t time();

char *word[] = {
  "words",
  "apple",
  "target",
};

#define NUM_OF_WORDS (sizeof(word)/sizeof(word[0]))
#define MAXLEN 80   /*Maximum size of any string in the world*/
#define HANGMAN_TCP_PORT 1068

void play_hangman(int in, int out);

int main(int argc, char*argv[])
{
  int sock, msgsock, client_len;
  struct sockaddr_in server, client;
  //this would ignore the child signal, which will prevent the child process in to zombie process if the child process is finished before parent.
  signal(SIGCHLD,SIG_IGN);
  sock = socket(AF_INET, SOCK_STREAM,0);
  if(sock < 0)
  {
    perror("creating stream socket");  
    exit(1);
  }

  /*set up the server's socket address */
  server.sin_family = AF_INET;
  server.sin_addr.s_addr = htonl(INADDR_ANY);
  server.sin_port = htons(HANGMAN_TCP_PORT );

  if(bind(sock, (struct sockaddr*)&server, sizeof(server))<0)
  {
    perror("binding socket.");  
    exit(2);
  }
  listen(sock, 5);
  fprintf(stderr, "hangman server: listening ...\n");
  while(1)
  {
    client_len = sizeof(client);
    msgsock = accept(sock, (struct sockaddr*) &client, &client_len);
    if(msgsock < 0)
    {
      perror("accepting connection");
      exit(3);
    }

    if(fork() == 0)
    {
      close(sock);
      printf("new child(pid %d) using descriptor %d\n", getpid(), msgsock);
      srand((int)time((long*)0));  /*randomise the seed */
      play_hangman(msgsock, msgsock);
      printf("child(pid %d) exitting\n", getpid());
      exit(0);

    }
    else
    close(msgsock);
  }
  return 0;

}



/*play_hangman()*/
/* plays one game of hangman, returning when the word has been 
 * guessed or all the player's "lives" have been used. For each
 * "turn" of the game, a line is read from stream "in". the first 
 * character of this line is taken as the player's guess.
 * Afer each guess and prior to the first guess, a line is sent to stream "out".
 * This consists of the word as guessed so far, with - to show unguessed letters, followed
 * by the number of lives remaining.
 * Note that this function neither knows nor cares whether its
 * input and ouput streams refer to sockets, devices, or files.
 * */

void play_hangman(int in, int out)
{
  char *whole_word, part_word[MAXLEN], guess[MAXLEN], outbuf[MAXLEN];
  int lives = 12;      //Number of lives left
  int game_state = 'I';  // I ==> Incomplete
  int i, good_guess, word_length;

  /* Pick a word at random from the list */
  whole_word = word[rand()% NUM_OF_WORDS];
  word_length = strlen(whole_word);
  /*No letters are guessed initially */
  for(i=0; i< word_length; i++)
  {
      part_word[i]='-';  
  } 
  part_word[i] = '\0';
  sprintf(outbuf, " %s    %d\n", part_word, lives);
  write(out, outbuf, strlen(outbuf));

  while(game_state == 'I')
  {
    read(in, guess, MAXLEN);  /*Get guess letter from player*/
    if(strcmp(guess,"exit") ==0)
      break;
  }
}
