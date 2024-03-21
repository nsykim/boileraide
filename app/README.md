Design considerations:

store[0] is reserved for chatlog names, so chatlogs begin at chatID == 1.

it's assumed that the total number of chats < INT_MAX - 2. 

chatIDs are never reused, so deleting chats will not allow for more total chats. 