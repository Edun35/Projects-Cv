# Daily Notes
#### Video Demo:  <https://www.youtube.com/watch?v=tmsHBvsV-f8>
#### Description: A note taking android application to record sleep pattern and daily activities.
#### Files:
I chose to make a note taking application as I have chronic fatigue and need to keep records of my daily activities and sleep pattern.
I chose to make the app as simple as possible using few butttons views and functions.
I chose to use a Sqlite database over using individual files to save notes because a Sqlite database is more ordered than files.
I chose to create a sleep table and a notes table over creating a single table as times for going to sleep are varied and not always occuring on the same day notes are taken
e.g note take on Oct 1st and going to sleep at 1 AM on Oct 2nd.
I chose not to add a delete function for either table because I dont wish to accidently delete information recorded.
I also choose not to add a edit function to the sleep table so as not to be able to change times when walking up and going to sleep.

Databasehelper.java contains the functions used to create, edit and drop SQLite database.
Two tables are created the Sleep table contains a coloumn for an id, a coloumn for time when walking up and going to sleep
and a type coloumn for whether I woke up or went to sleep and
a Notes table with a note coloumn for notes and a date coloumn for the date the note was taken.
The functions included are:
1 The AddEntry function which adds the type(sleep/wake up) and timestamp to the sleep table with an autoincrementing id, this function is called by the wake up and sleep buttons in the main activiy.
2 The ReadSleepData function which reads the data from the sleep table to be viewed as items in the recyclerview in the main activity.
3 The AddNote function adds the note and date to the notes table this function is called by the create button in the add note activity.
4 The ReadNotesData function reads the data from the notes table to be viewed as items in the recyclerview in the notes activity.
5 The CheckDate function checks if a note was created for the date already and stops the creation of a note if there is already a note created. This function is called in the Addnote function.
6 The Editnote function updates the data of a created note, this function is called by the edit button in the view note activity.

Activity_main.xml contains the layout of the start up page of the app. It includes a recyclerView for displaying items in the database and three buttons.
The first button is a wake up button to add wake up times to the sleep table of the daily notes database.
The second button is a sleep button to add sleep times to the sleep table of the daily notes database.
the third button is the notes button to take you to the notes page of the app.

MainActivity.java contains the on click listeners for the buttons and the functions used to create and display the items in the recylerview.
SleepCustomAdapter.java with inner class SleepViewholder and sleep_row.xml are used to create the cards to display each item in the recyclerview in the main Activity.

NotesActivity.java and activity_notes.xml contains the code and layout for the second page of the app.
A recyclerview that shows the dates of notes taken that when an date is clicked takes you to the view note activity t o view and edit a note
and a floating action button that takes you to the create note activity to create a note.

AddNoteActivity.java and activity_add_notes.xml contains the code and layout for creating notes to add to the notes table in the databasehelper.java file.
An Edit text view for creating a note and a create button for adding the note and the date saved as a variable to the notes table.

ViewNoteActivity.java and activity_view_notes.xml contains the code and layout for viewing a note and to edit the note that is viewed.
An edit text view for viewing a already created note getting information from the notes table in databasehelper file and for editing said note, and an edit note for saving the notes changes and updating said note in the notes table.
CustomAdapter.java with inner class MyViewholder and my_row.xml are used to create the note cards for the each item in the recyclerview in the notes Activity.