#include <cs50.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <math.h>


int main(void)
{ 
    // get text
    string text = get_string("Text: ");
    
    // letter count
    int let = 0;
    for (int i = 0; text[i] != '\0'; i++)
    {
        if (isalpha(text[i]))
        {
            let++;
        }
    }
    
    // word count
    int word = 1;
    for (int i = 0; text[i] != '\0'; i++)
    {
        if (text[i] == ' ')
        {
            word++;
        }
    }

    // sentence count
    int sent = 0;
    for (int i = 0; text[i] != '\0'; i++)
    {
        if (text[i] == '.' || text[i] == '!' || text[i] == '?')
        {
            sent++;
        }
    }

    // index
    float L = let / (float) word * 100;
    float S = sent / (float) word * 100;
    double index = 0.0588 * L - 0.296 * S - 15.8;

    // display grade
    if (index < 1.0)
    {
        printf("Before Grade 1\n");
    }
    else if (index >= 16.0)
    {
        printf("Grade 16+\n");
    }
    else
    {
        printf("Grade %i\n", (int) round(index));
    }
}