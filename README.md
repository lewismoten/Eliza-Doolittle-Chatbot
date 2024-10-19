# Eliza Doolittle Chatbot

![Eliza](./Assets/Eliza%20Doolittle%20Chatbot%20Picture.png)

ELIZA is a famous 1966 computer program by Joseph Weizenbaum. It was made as a parody of a Rogerian therapist. This is a port of the program into Linden Scripting Language (LSL). More information can be found in the notecard: [Eliza Doolittle Chatbot Info](./Objects/Eliza%20Doolittle%20Chatbot%20Boxed/01/Eliza%20Doolittle%20Chatbot%20Info.md). Eliza was given away freely since the code was freely available online in many forms.

## Second Life

This is one of many products that I created within Second Life. I had a shop called "Dedric Mauriac's Gagdget Shop" in which I sold hundreds of interactive products. You can get a glimpse of how one of the stores were setup here: https://www.youtube.com/watch?v=DYqWRdkMbCc

### Subscriptions

The Boxed version has a script [_Subscribe 1.0.lsl](./Objects/Eliza%20Doolittle%20Chatbot%20Boxed/01/_Subscribe%201.0.lsl). It references a website that I no longer use. I had created a system at one time to allow people to subscribe for updates.

### Synthesized Voice Box

There is a "Synthesized Voice Box" add-on that goes with Eliza that turns text into speech using sounds from the SPO256-AL2 chip. I may export that into its own project at a later time.

### Exporting

It's very difficult to export objects out of Second Life. First, there isn't a file for objects. [copy-prim.lsl](./scripts/copy-prim.lsl) is setup to create LSL scripts to change an existing primitive to appear as the original prim. It also creates a markdown file for permissions and inventory listings. Images are difficult in that I only have asset UUID's. I end up having to select various faces to open the texture picker that matches the UUID in my inventory to display a texture name. From there, I go through my inventory, find the same name, view the properties with the create date, and download the image. Sounds are very difficult as the interface does not offer a way to export them. Instead, I have to find assets on my file system by searching for the asset id's after they have started playing.

Eventually, I'd like to get most of my favorite gadgets exported, but it's a long process.