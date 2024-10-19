key avatarId = NULL_KEY; // person chatbot is listening to
integer activity = 0; // last time avatar interacted with chat bot

// ELIZA is a famous 1966 computer program by Joseph Weizenbaum
// ELIZA is a parody of a Rogerian therapist
// ELIZA rephrases many of the patient's statements as questions and posing them to the patient.

// This LSL version is a port from a BASIC implementation written by John Schugg in January 1985.

// Data Setup:
// Keywords and patterns are contained in a seperate notecard
// a keyword set appears on a line delimited with semi-colon and prefixed with number of responses
// each responses is written on its own line
// if more then one response follows a set of keywords, a random response will be chosen
// the last keyword in the notecard will always be used for responses that are not understood
// blank lines should only appear before keywords or after the last response.
// blank lines are optional and only used for easier management of data

// how long to wait before responding and listening for next user input
float delay = .1;//7.5; 

// name of notecard containing patterns and responses
string replyNote = "Chatbot.Eliza.txt";

// stated when end-user repeats themselves
string repeatReply = "please do not repeat yourself";

// greeting
string introduction = "I can help! Tell me about your problems.";

// don't listen to objects?
integer ignoreObjects = TRUE;

list keywords; // recognized keywords
list matchStart; // start position in notecard for responses to each keyword
list matchCount; // number of responses for each keyword
integer lastLine;

// used to rephrase input into responses
list conjugations = [
    "are", "am", 
    "were", "was", 
    "you", "i", 
    "your", "my", 
    "ive", "youve", 
    "im", "youre", 
    "you", "me"
];

// number of lines in reply notecard
integer replyLines;

// id of request for notecard line count
key replyCountId;

// current line number being requested from notecard
integer replyLine;

// id of request for text in notecard for initialization
key replyLineId;

// characters recognized from user input
string recognized = "abcdefghijklmnopqrstuvwxyz ";

// id of listener for user input
integer listener;

// id of request for text in notecard as a response to input
key responseId;

string said; // what the user said
string matched; // keyword/phrase the program understood

integer processing = FALSE; // state if program still processing last input

string say; // response to user input

initialize()
{
    llSetTimerEvent(0);
    lastLine = -1;
    replyLine = 0;
    replyLines = -1;
    showProgress();
    keywords = [];
    matchCount = [];
    matchStart = [];
    replyCountId = llGetNumberOfNotecardLines(replyNote);
}
string conjugateWord(string word)
{
    // find word to replace
    integer i = llListFindList(conjugations, [word]);
    
    // not found
    if(i == -1) return word;
    
    // word found.  opposites in pairs.
    if(i % 2 == 0) return llList2String(conjugations, i + 1);
    return llList2String(conjugations, i - 1);
}
string processConjugates()
{
    // rephrase what user said after the matched keyword.
    
    integer i = llSubStringIndex(said, matched);
    string text = llGetSubString(said, i + llStringLength(matched), -1);
    list words = llParseString2List(text, [" "], []);
    text = "";
    
    integer n = llGetListLength(words);

    for(i = 0; i < n; i++)
        text += " " + conjugateWord(llList2String(words, i));
    
    return text;
}
processResponse(string message)
{
    // format response
    message = llToLower(message);
        
    // if wildcard in response, rephrase what user said
    integer i = llSubStringIndex(message, "*");
    if(i != -1)
    {
        message = llDeleteSubString(message, i, i);
        message = llInsertString(message, i, processConjugates());
    }
    
    // prepare to respond
    say = message;
    llSetTimerEvent(delay);
}
respondTo(integer keywordIndex)
{
    
    // determine what keyword to response to
    matched = llList2String(keywords, keywordIndex);
    
    
    // determine what to respond with
    integer start = llList2Integer(matchStart, keywordIndex);
    integer count = llList2Integer(matchCount, keywordIndex);
    integer line = start + llFloor(llFrand(count));
    
    // prevent repeat response
    while(line == lastLine && count != 1)
        line = start + llFloor(llFrand(count));
    lastLine = line;
    
    
    
    // request text for chosen response
    responseId = llGetNotecardLine(replyNote, line);
}
processMessage(string message)
{
    // don't process if we are still working on the last message
    if(processing) return;
    processing = TRUE;
    
    message = formatMessage(message);

    // do not bother with repeat input
    if(said == message)
    {
        say = repeatReply;
        llSetTimerEvent(delay);
        return;
    }
    
    // remember what user said last
    said = message;
    
    // itterate through keywords
    integer n = llGetListLength(keywords);
    integer i;
    for(i = 0; i < n; i++)
    {
        // padd keyword with spaces
        string keyword = " " + llList2String(keywords, i) + " ";
        
        // if keyword in user-input, respond to it.
        if(llSubStringIndex(message, keyword) != -1)
        {
            respondTo(i);
            return;
        }
    }
    
    // since keyword not found, response with last keywords replies (not understood)
    respondTo(n - 1);
}
string formatMessage(string message)
{
    // remove punctuation and change everything to lowercase
    
    string message = llToLower(message);
    string format = " ";
    integer i;
    integer n = llStringLength(message);
    for(i = 0; i < n; i++)
    {
        string char = llGetSubString(message, i, i);
        if(llSubStringIndex(recognized, char) != -1)
            format += char;
    }
    return format + " ";
}
showProgress()
{
    // determine how much is done
    integer percent = (integer)(((float)replyLine / (float)replyLines) * 100);
    
    // build a text based progress bar - 59% [|||||......]
    string progress = (string)percent + "%\n[";
    integer i = 0;
    for(i = 0; i < 100; i+= 3)
        if(i <= percent) progress += "|"; 
        else progress += ".";
    progress += "]";

    llSetText("Initializing\n" + progress, <1,1,1>, 1);
}
readReplies()
{
    // at end of notecard?
    if(replyLine >= replyLines)
    {
        llSetText("", ZERO_VECTOR, 0);
        llSetTimerEvent(60);
        return;
    }
    
    showProgress();

    // read next line
    replyLineId = llGetNotecardLine(replyNote, replyLine++);
}
initializeReply(string data)
{
    data = llToLower(data);
    
    // is this a pattern?
    if(llSubStringIndex(data, ";") != -1)
    {
        list patterns = llParseString2List(data, [";"], []);
        integer count = llList2Integer(patterns, 0);
        keywords += llDeleteSubList(patterns, 0, 0);
        replyLine++;
        setMatchStart();
        setMatchLength(count);
        replyLine += count;
    }
    
    readReplies();
}
setMatchStart()
{
    // set starting index for all keywords that do not yet have it set
    integer count = llGetListLength(keywords);
    integer i = llGetListLength(matchStart);
    for(; i < count; i++)
        matchStart += [replyLine - 1];
}
setMatchLength(integer length)
{
    // determine number of replies for keyword set
    integer count = llGetListLength(keywords);
    integer i = llGetListLength(matchCount);
    for(; i < count; i++)
        matchCount += [length];
}
startSession(key id)
{
    avatarId = id;
    activity = llGetUnixTime();
    
    // start listening
    if(listener != 0) llListenRemove(listener);
    listener = llListen(PUBLIC_CHANNEL, "", avatarId, "");
    llSay(0, introduction);
}
endSession()
{
    if(listener != 0) llListenRemove(listener);
    avatarId = NULL_KEY;
    activity = 0;
    llSay(PUBLIC_CHANNEL, "Goodbye.");
    llSetTimerEvent(0);
}
default
{
    state_entry()
    {
        initialize();
    }
    on_rez(integer start_param)
    {
        initialize();
    }
    changed(integer change)
    {
        if(change && CHANGED_INVENTORY) initialize();
    }
    dataserver(key queryId, string data) 
    {
        // finding reply count
        if(queryId == replyCountId)
        {
            replyLines = (integer)data;
            readReplies();
            return;
        }
        
        // initializing keywords/replies
        if(queryId == replyLineId)
        {
            initializeReply(data);
            return;
        }
        
        // retrieving response template
        if(queryId == responseId)
        {
            processResponse(data);
            return;
        }

    }
    listen(integer channel, string name, key id, string message)
    {
        if(ignoreObjects && llGetOwnerKey(id) != id) return;
        
        if(id != avatarId) return;
        
        activity = llGetUnixTime();

        processMessage(message);
    }
    touch_start(integer count)
    {
        if(avatarId == NULL_KEY)
            startSession(llDetectedKey(0));
        else
            endSession();
    }
    timer()
    {
        if(processing)
        {
            // say what we previously decided to say
            llSay(PUBLIC_CHANNEL, say);
            
            // listen for next input
            processing = FALSE;
            
            activity = llGetUnixTime();
            llSetTimerEvent(120.0);
        }
        else if(llGetUnixTime() - activity > 120)
        {
            processing = FALSE;
            endSession();
        }
        
    }
}