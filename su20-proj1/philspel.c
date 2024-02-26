/*
 * Include the provided hash table library.
 */
#include "hashtable.h"

/*
 * Include the header file.
 */
#include "philspel.h"

/*
 * Standard IO and file routines.
 */
#include <stddef.h>
#include <stdio.h>

/*
 * General utility routines (including malloc()).
 */
#include <stdlib.h>

/*
 * Character utility routines.
 */
#include <ctype.h>

/*
 * String utility routines.
 */
#include <string.h>

/*
 * This hash table stores the dictionary.
 */
HashTable *dictionary;

/*
 * The MAIN routine.  You can safely print debugging information
 * to standard error (stderr) as shown and it will be ignored in 
 * the grading process.
 */
int main(int argc, char **argv) {
  if (argc != 2) {
    fprintf(stderr, "Specify a dictionary\n");
    return 0;
  }

  //fprintf(stderr, "Wirting to myOUT");
  /*
   * Allocate a hash table to store the dictionary.
   */
  fprintf(stderr, "Creating hashtable\n");
  dictionary = createHashTable(2255, &stringHash, &stringEquals);

  fprintf(stderr, "Loading dictionary %s\n", argv[1]);
  readDictionary(argv[1]);
  //printf("DICTION: %p\n", (char *)dictionary->data[789]);
  fprintf(stderr, "Dictionary loaded\n");

  fprintf(stderr, "Processing stdin\n");
  processInput();

  /*
   * The MAIN function in C should always return 0 as a way of telling
   * whatever program invoked this that everything went OK.
   */
  return 0;
}

/*
 * This should hash a string to a bucket index.  Void *s can be safely cast
 * to a char * (null terminated string) and is already done for you here 
 * for convenience.
 */
unsigned int stringHash(void *s) {
  char *string = (char *)s;
  unsigned int h = 0;
  while (*string) {
    h = (h << 4) + *string++;
    unsigned int g = h & 0xF0000000;
    if (g) {
      h ^= g >> 24;
    }
    h &= ~g;
  }
  return h;
  // -- TODO --
}

/*
 * This should return a nonzero value if the two strings are identical 
 * (case sensitive comparison) and 0 otherwise.
 */
int stringEquals(void *s1, void *s2) {
  char *string1 = (char *)s1;
  char *string2 = (char *)s2;
  // -- TODO --
  //printf("EQUALS: %s \n %s\n\n", string1, string2);
  return strcmp(string1, string2) == 0;
}

/*
 * This function should read in every word from the dictionary and
 * store it in the hash table.  You should first open the file specified,
 * then read the words one at a time and insert them into the dictionary.
 * Once the file is read in completely, return.  You will need to allocate
 * (using malloc()) space for each word.  As described in the spec, you
 * can initially assume that no word is longer than 60 characters.  However,
 * for the final 20% of your grade, you cannot assumed that words have a bounded
 * length.  You CANNOT assume that the specified file exists.  If the file does
 * NOT exist, you should print some message to standard error and call exit(1)
 * to cleanly exit the program.
 *
 * Since the format is one word at a time, with new lines in between,
 * you can safely use fscanf() to read in the strings until you want to handle
 * arbitrarily long dictionary chacaters.
 */
void readDictionary(char *dictName) {
  // -- TODO --
  FILE *file = fopen(dictName, "r");
  if (file == NULL) {
    printf("Dictionary file not found\n");
    exit(1);
  }
  char *word = (char *)malloc(60 * sizeof(char));
  while(fscanf(file, "%s", word) != EOF) {
    //printf("word WROOOOOOO: %s\n", word);
    insertData(dictionary, (void *)word, (void *)word);
    word = (char *)malloc(60 * sizeof(char));
  }
  fclose(file);
}

void deal(char *s,size_t *len ,size_t *caplen, char c,int last);
/*
 * This should process standard input (stdin) and copy it to standard
 * output (stdout) as specified in the spec (e.g., if a standard 
 * dictionary was used and the string "this is a taest of  this-proGram" 
 * was given to stdin, the output to stdout should be 
 * "this is a teast [sic] of  this-proGram").  All words should be checked
 * against the dictionary as they are input, then with all but the first
 * letter converted to lowercase, and finally with all letters converted
 * to lowercase.  Only if all 3 cases are not in the dictionary should it
 * be reported as not found by appending " [sic]" after the error.
 *
 * Since we care about preserving whitespace and pass through all non alphabet
 * characters untouched, scanf() is probably insufficent (since it only considers
 * whitespace as breaking strings), meaning you will probably have
 * to get characters from stdin one at a time.
 *
 * Do note that even under the initial assumption that no word is longer than 60
 * characters, you may still encounter strings of non-alphabetic characters (e.g.,
 * numbers and punctuation) which are longer than 60 characters. Again, for the 
 * final 20% of your grade, you cannot assume words have a bounded length.
 */

int check(char *s);

void processInput() {
  // -- TODO --
  //printf("Processing input\n");

  char *test = "this";
  //printf("testANSSSSSS is %d\n", check(test));

  char *input = NULL;
  size_t inputSize = 0, inputCapacity = 0;

  char c;
  while( (c = getchar()) != EOF ) {
    //printf("c: %c\n", c);
    if(inputSize >= inputCapacity) {
      inputCapacity += 10;
      input = realloc(input, inputCapacity * sizeof(char));
      if (input == NULL) {
        printf("Memory allocation failed\n");
        exit(1);
      }
    }
    //printf("deal begin: ");
    //printf("%c %zu\n",c, inputSize);
    deal(input, &inputSize, &inputCapacity ,c, 0);
  }
  deal(input, &inputSize, &inputCapacity, '\0', 1);
}

int check(char *s) {
  //printf("checks is : %s\n", s);
  int *result = (int *)findData(dictionary, (void *)s);
  if(result == NULL) return 0;
  return 1;
}

void deal(char *s,size_t *len, size_t *caplen, char c, int last) {
  //printf("deal\n");
  if( (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') ) {
    s[(*len)++] = c;
  } else {
    //printf("%zu", *len);
    if(*len == 0) {
      if(last == 0) printf("%c", c);
      return ;
    }
    s[*len] = '\0';
    char *oris = (char *)malloc((*len + 1) * sizeof(char));
    strcpy(oris, s);
    //printf("\n SSoris is :%s\n\n", oris);
    //printf("s is %s\n", s);
    int finded = 0;
    finded += check(s);
    for(int i = 1; i < *len; i++) {
      if(s[i] >= 'A' && s[i] <= 'Z') s[i] += 32;
    }
    finded += check(s);
    if(s[0] >= 'A' && s[0] <= 'Z') s[0] += 32;
    finded += check(s);
    if(finded == 0) {
      printf("%s [sic]", oris);
    } else {
      printf("%s", oris);
    }
    *len = 0;
    *caplen = 0;
    s = NULL;
    if(last == 0) printf("%c", c);
  }
}