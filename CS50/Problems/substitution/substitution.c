#include <cs50.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

string key;

int main(int argc, string argv[])
{
    // check if command works
    if (argc != 2)
    {
        printf("Usage: ./sub key\n");
        return 1;
    }
    else if (strlen(argv[1]) != 26)
    {
        printf("Key must contain 26 characters.\n");
        return 1;
    }
    else
    {

        // get key
        key = argv[1];
        for (int i = 0; i < 26; i++)
        {
            key[i] = toupper(key[i]);

        }

        // check if key works
        for (int i = 0; i < 26; i++)
        {
            if (!isalpha(key[i]))
            {
                printf("Key must only contain alphabetic characters.\n");
                return 1;
            }
            else
            {
                for (int n = i; n <= 25; n++)
                {
                    if (key[i] == key[i + 1])
                    {
                        printf("Key must not contain repeated characters.\n");
                        return 1;
                    }
                }
            }
        }

    }

    // get text
    string text = get_string("Plaintext: ");

    // lenght plaintext
    int len = strlen(text);

    // cypher
    for (int i = 0; i <= len; i++)
    {
        // uppercase
        if (isupper(text[i]))
        {
            text[i] -= 65;
            for (int n = 0; n < 26; n++)
            {
                key[n] = toupper(key[n]);
                if (text[i] == n)
                {
                    text[i] = key[n];
                }
            }

        }
        // lowercase
        else if (islower(text[i]))
        {
            text[i] -= 97;
            for (int n = 0; n < 26; n++)
            {
                key[n] = tolower(key[n]);
                if (text[i] == n)
                {
                    text[i] = key[n];
                }
            }
        }
    }
    // display cypher
    printf("ciphertext: %s", text);
    printf("\n");
    return 0;
}