# Client-server(Library Database) 

The implementation of the database structure on the server will be with Mnesia. 

In the file baseData.erl is the database (Mnesia). 
We will use three tables corresponding to the person (citizen card, name, address and telephone), book (identity book, title and authors) and requisition (citizen card and identity book).
In this file you will find the functions to query the tables in order to later answer the requested questions, plus the respective functions to add or delete data in the tables. 

The serverClient.erl file is used for communication between the client and the server. Both the client file and the server file can be run on the same machine or on two different machines. 



