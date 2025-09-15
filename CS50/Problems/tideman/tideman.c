#include <cs50.h>
#include <stdio.h>
#include <string.h>

// Max number of candidates
#define MAX 9

// preferences[i][j] is number of voters who prefer i over j
int preferences[MAX][MAX];

// locked[i][j] means i is locked in over j
bool locked[MAX][MAX];

// Each pair has a winner, loser
typedef struct
{
    int winner;
    int loser;
}
pair;

// Array of candidates
string candidates[MAX];
pair pairs[MAX * (MAX - 1) / 2];

int pair_count;
int candidate_count;

// Function prototypes
bool vote(int rank, string name, int ranks[]);
void record_preferences(int ranks[]);
void add_pairs(void);
void sort_pairs(void);
void lock_pairs(void);
void print_winner(void);

int main(int argc, string argv[])
{
    // Check for invalid usage
    if (argc < 2)
    {
        printf("Usage: tideman [candidate ...]\n");
        return 1;
    }

    // Populate array of candidates
    candidate_count = argc - 1;
    if (candidate_count > MAX)
    {
        printf("Maximum number of candidates is %i\n", MAX);
        return 2;
    }
    for (int i = 0; i < candidate_count; i++)
    {
        candidates[i] = argv[i + 1];
    }

    // Clear graph of locked in pairs
    for (int i = 0; i < candidate_count; i++)
    {
        for (int j = 0; j < candidate_count; j++)
        {
            locked[i][j] = false;
        }
    }

    pair_count = 0;
    int voter_count = get_int("Number of voters: ");

    // Query for votes
    for (int i = 0; i < voter_count; i++)
    {
        // ranks[i] is voter's ith preference
        int ranks[candidate_count];

        // Query for each rank
        for (int j = 0; j < candidate_count; j++)
        {
            string name = get_string("Rank %i: ", j + 1);

            if (!vote(j, name, ranks))
            {
                printf("Invalid vote.\n");
                return 3;
            }
        }

        record_preferences(ranks);

        printf("\n");
    }

    add_pairs();
    sort_pairs();
    lock_pairs();
    print_winner();
    return 0;
}

// Update ranks given a new vote
bool vote(int rank, string name, int ranks[])
{
    // TODO
    for (int n = 0; n < candidate_count; n++)
    {
        if (strcmp(candidates[n], name) == 0)
        {
            ranks[rank] = n;
            return true;
        }
    }
    return false;
}

// Update preferences given one voter's ranks
void record_preferences(int ranks[])
{
    // TODO
    for (int n = 0; n < candidate_count; n++)
    {
        for (int k = 1; k < candidate_count; k++)
        {
            preferences[ranks[n]][ranks[n + k]]++;
        }
    }
    return;
}

// Record pairs of candidates where one is preferred over the other
void add_pairs(void)
{
    // TODO
    for (int a = 0; a < candidate_count; a++)
    {
        for (int b = candidate_count; b > 0; b--)
        {
            if (preferences[a][b] > preferences[b][a])
            {
                pairs[pair_count].winner = a;
                pairs[pair_count].loser = b;
                pair_count++;
            }
        }
    }
    return;
}

// Sort pairs in decreasing order by strength of victory
void sort_pairs(void)
{
    // TODO
    typedef struct
    {
        int winner;
        int loser;
    }
    temp;
    temp temps[1];
    int sc = 1;

    while (sc != 0)
    {
        sc = 0;
        for (int i = 0; i < pair_count; i++)
        {
            if ((preferences[pairs[i].winner][pairs[i].loser] - preferences[pairs[i].loser][pairs[i].loser]) < 
                (preferences[pairs[i + 1].winner][pairs[i + 1].loser] - preferences[pairs[i + 1].loser][pairs[i + 1].loser]))
            {
                temps[0].winner = pairs[i].winner;
                temps[0].loser = pairs[i].loser;
                pairs[i] = pairs[i + 1];
                pairs[i + 1].winner = temps[0].winner;
                pairs[i + 1].loser = temps[0].loser;
                sc++;
            }
        }
    }
    return;
}

// Lock pairs into the candidate graph in order, without creating cycles
void lock_pairs(void)
{
    // TODO
    bool CheckCycle(int winner, int loser);

    for (int i = 0; i < pair_count; i++)
    {

        if (!CheckCycle(pairs[i].winner, pairs[i].loser))
        {
            locked[pairs[i].winner][pairs[i].loser] = true;
        }

    }
    return;
}

// cycle
bool CheckCycle(int winner, int loser)
{
    if (locked[loser][winner] == true)
    {
        return true;
    }
    else
    {
        for (int i = 0; i < candidate_count; i++)
        {
            if (locked[i][winner])
            {
                return CheckCycle(i, loser); // return is needed don't forget next time!!
            }
        }
        return false;
    }
}


// Print the winner of the election
void print_winner(void)
{
    // TODO
    int win = 0;
    for (int i = 0; i < candidate_count; i++)
    {
        bool lost = false;
        for (int j = 0; j < candidate_count; j++)
        {
            if (locked[j][i])
            {
                lost = true;
                break;
            }
        
        }
        if (lost == false)
        {
            win = i;
        }
    }
    
    printf("%s\n", candidates[win]);
    return;
}