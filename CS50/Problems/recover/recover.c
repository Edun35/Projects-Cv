#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>


int main(int argc, char *argv[])
{
    // error incorrect usage
    if (argc != 2)
    {
        printf("ERROR: Usage: ./recover card.raw");
        return 1;
    }

    // open memory card
    FILE *INPUT = fopen(argv[1], "r");

    // error image unreadable
    if (INPUT == NULL)
    {
        printf("Input ERROR");
        return 1;
    }

    // type byte
    typedef uint8_t BYTE;
   
    // counter
    int jpeg_count = 0;
   
    // filename
    char filename[9];
    
    //
    FILE *img;  


    // look for jpeg start
    BYTE buffer[512];
    while (fread(&buffer, 512, 1, INPUT) != 0)
    {
        // if jpeg start
        if (buffer[0] == 0xff && buffer[1] == 0xd8 && buffer[2] == 0xff && (buffer[3] & 0xf0) == 0xe0)
        {
            // if first jpeg
            if (jpeg_count == 0)
            {
                sprintf(filename, "%03i.jpg", jpeg_count);
                img = fopen(filename, "w");
                fwrite(buffer, 512, 1, img);
                jpeg_count++;
            }
            // if not first jpeg
            else
            {
                fclose(img);
                sprintf(filename, "%03i.jpg", jpeg_count);
                img = fopen(filename, "w");
                fwrite(buffer, 512, 1, img);
                jpeg_count++;
            }
        }
        //if jpeg found
        else
        {
            if (jpeg_count > 0)
            {
                fwrite(buffer, 512, 1, img);
            }
        }
       
    }
   
    // close files
    fclose(INPUT);
    fclose(img);
    
    return 0;
}