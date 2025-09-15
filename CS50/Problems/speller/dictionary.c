// Implements a dictionary's functionality

#include <stdbool.h>

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <strings.h>

#include "dictionary.h"

// Represents a node in a hash table
typedef struct node
{
    char word[LENGTH + 1];
    struct node *next;
}
node;

// Number of buckets in hash table 26 * 4
const unsigned int N = 104;

// Hash table
node *table[N];

// dictionary size global
int dict_size = 0;

// Returns true if word is in dictionary, else false
bool check(const char *word)
{
    // TODO
    // hash word

    int index = hash(word);

    // check hash table
    node *cursor = table[index];
    while (cursor != NULL)
    {
        if (strcasecmp(cursor->word, word) == 0)
        {
            return true;
        }
        else
        {
            cursor = cursor->next;
        }
    }
    return false;
}


// Hashes word to a number
unsigned int hash(const char *word)
{
    // TODO
    // temp word to store word as all lower case
    char tempword[LENGTH];
    strcpy(tempword, word);
    for (int i = 0; i < strlen(tempword); i++)
    {
        if (isupper(tempword[i]) != 0)
        {
            tempword[i] = tolower(tempword[i]);
        }
    }

    // set var
    int sum = 0;

    // loop through letters
    for (int i = 0; i < 4; i++)
    {
        //check word length
        if (i < strlen(tempword - 1))
        {
            int num = isalpha(tempword[i]);
            if (num != 0)
            {
                sum += (tempword[i] - 97);
            }
            
        }
    }
    return sum;

}

// Loads dictionary into memory, returning true if successful, else false
bool load(const char *dictionary)
{
    // TODO
    // set table adresses to NULL/0
    for (int i = 0; i < N; i++)
    {
        table[i] = NULL;
    }

    // open dictionary
    FILE *dict = fopen(dictionary, "r");
    if (dict == NULL)
    {
        return false;
    }

    // word buffer
    char tmpword[LENGTH];

    // load dictionary
    while (fscanf(dict, "%s", tmpword) != EOF)
    {
        node *n = malloc(sizeof(node));
        if (n == NULL)
        {
            return false;
        }

        strcpy(n->word, tmpword);
        n->next = NULL;

        // hash
        int index = hash(n->word);

        // hash table insert at starting point
        if (table[index] == NULL)
        {
            table[index] = n;
            dict_size++;
        }
        else
        {
            n->next = table[index];
            table[index] = n;
            dict_size++;
        }
    }

    fclose(dict);
    return true;
}

// Returns number of words in dictionary if loaded, else 0 if not yet loaded
unsigned int size(void)
{
    // TODO
    return dict_size;

}

// Unloads dictionary from memory, returning true if successful, else false
bool unload(void)
{
    // TODO
    for (int i = 0; i < N; i++)
    {
        node *cursor = table[i];
        while (cursor != NULL)
        {
            node *temp = cursor;
            cursor = cursor->next;
            free(temp);
        }
    }
    return true;
}