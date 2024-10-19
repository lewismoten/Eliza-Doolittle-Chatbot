Name
Eliza Doolittle Chatbot

Images
[Eliza Doolittle Chatbot Picture](../../../Assets/Eliza%20Doolittle%20Chatbot%20Picture.png)

Summary
Parody of a Rogerian therapist

Description
ELIZA is a famous 1966 computer program by Joseph Weizenbaum. It was made as a parody of a Rogerian therapist. it rephrases many of the patient's statements as questions and poses them to the patient. Solve all of your avatars emotional problems with this parody of an Rogerian therapist. Open Source Scripts allow customization.

Example

You: hi
Eliza Doolittle: how do you do--please state your problem.
You: i don't have a problem
Eliza Doolittle: does that trouble you?
You: no
Eliza Doolittle: you are being a bit negative.
You: does that trouble you?
Eliza Doolittle: we were discussing you-- not me.
You: you have the problem.
Eliza Doolittle: oh, i have the problem
You: yes
Eliza Doolittle: i see.



Features

    * Full permissions with Open Source.
    * Listens and responds to nearby residents.
    * Great for parties to get conversations going.
    * No dependency on third party websites.
    * Rephrases what resident said into a logical response.
    * Customizable note card to change responses
    * Does not repeat the last response it gave.

Configuration
Each time the configuration file (Chatbot.Eliza.txt) changes, the Eliza Doolittle Chatbot will initialize and read all information from the file. The file must be setup in a specific format.

Response Set

The configuration file is strict in how it is setup. Each response set begins with a line indicating how many responses are available, as well as patterns to match. This may seem redundant since the following lines can be read and counted. Due to memory limitations and to improve speed, the following lines after the pattern matching line are skipped during initialization. The response count allows the script to jump over these lines and read the next response set.

Multiple responses can be defined (and encouraged) for the same pattern. The script will choose a random response. The script will also go through an additional check to verify that the same response is not repeated to help the conversation continue. If a response contains an asterisk, it will be replaced by the users input occurring after that matching patter, but rephrased.

If a patient says "I want her to like me", the pattern matched would be "I want". If the response chosen is "Why do you want*", the users input will be rephrased "her to like you" at the end. Notice "me" has been rephrased to "you". This helps the AI to seem as if it is having cognitive thoughts.

Open Source
The script is available as open source to allow anyone to make their own changes.

Prims
7

Created
January 7, 2007

Permissions
Modify, Copy, Transfer

Versions
1.0 Initial Public Offering

Known Issues

Eliza can appear to spam conversations since it responds to everything that anyone says. It does not take long at all before conversations become odd or funny. Some conversations with Eliza can be insulting.

Background History

I purchased an S-Chat Bot from Metaverse Technology HQ. After speaking a bit with the owners and setting it up, it turns out that the back-end was actually hooked up into a pandorabots.net account. This is a free service of alice-based chatbots where you can submit your own AIML code in the back end. This sparked my interest in the original chat bot, ELIZA. Eliza was originally written in basic. I was able to find some old code and ported it over into LSL so that 3rd party websites were not needed in order for it to work.

Keywords

ai, artificial intelligence, chat, chatbot, configurable, configuration, copy, gadget, modify, scripted, speak, speech, talk, therapy