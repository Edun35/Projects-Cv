#include <cs50.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>


int main(int argc, string argv[])
{
    if (argc != 2)
    {
        printf("Usage: ./caeser key\n");
        return 1;
    }
    else
    {
        for (int i = 0, n = strlen(argv[1]); i <= n; i++)
        {
            if (isdigit(argv[1][i]) == true)
            {
                printf("Usage: ./caeser key\n");
                return 1;
            }
        }
    }

    // get key
    int key = atoi(argv[1]);

    // get text
    string text = get_string("Plaintext: ");

    int len = strlen(text);
    //loop through plaintext
    for (int i = 0; i < len; i++)
    {

        // check if alphabetical
        if (isalpha(text[i]))
        {
            // check case
            if (isupper(text[i]))
            {
                // change to alph index
                text[i] = text[i] - 'A';

                // change to cypher
                text[i] = (text[i] + key) % 26;

                // change back to ascii
                text[i] = text[i] + 'A';

            }
            else if (islower(text[i]))
            {
                // change to alph index
                text[i] = text[i] - 'a';

                // change to cypher
                text[i] = (text[i] + key) % 26;

                // change back to ascii
                text[i] = text[i] + 'a';
            }
        }
    }

    // display cypher
    printf("ciphertext: %s", (string) text);
    printf("\n");
    return 0;
}