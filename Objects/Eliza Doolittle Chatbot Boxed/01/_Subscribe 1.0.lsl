// subscription - allow customers to be notified when you post new products.
integer listener = 0; // listener for dialog menu
integer channel = -23481220; // channel to listen on
string listUrl = "http://dedricmauriac.x10hosting.com/api/sl/subscriptions/"; // subscription url
string listSuffix = ".php";
string listName = "Dedric Mauriac's Gadgets";
string listDescription = "Would you like to be notified about upcomming products and updates? Subscribe today and you will receive news through instant messages.";

startListening()
{
    if(listener != 0) stopListening();
    listener = llListen(channel, "", NULL_KEY, "");
    llSetTimerEvent(18000);
}
stopListening()
{
    llSetTimerEvent(0);
    if(listener != 0)
    {
        llListenRemove(listener);
        listener = 0;
    }
}
init()
{
    stopListening();
}
default
{
    state_entry()
    {
        init();
    }
    on_rez(integer start_param)
    {
        init();
    }
    touch_start(integer total_number)
    {
        integer i;
        for(i = 0; i < total_number; i++)
        {
            string name = llStringToBase64(listName);
            string id = llStringToBase64((string)llDetectedKey(i));
            string url = listUrl + "status" + listSuffix;
            string body = "subscriberId=" + id + "&subscriberListName=" + name;            
            llHTTPRequest(url, [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/x-www-form-urlencoded"], body);
        }
    }
    timer()
    {
        stopListening();
    }
    listen(integer channel, string name, key id, string message)
    {
        stopListening();
        
        if(message == "Website")
        {
            llLoadURL(id, "Login to website to manage your list.", "http://dedricmauriac.x10hosting.com/");
            return;
        }
        if(message == "Subscribe")
        {
            string name = llStringToBase64(listName);
            string id = llStringToBase64((string)id);
            string url = listUrl + "subscribe" + listSuffix;
            string body = "subscriberId=" + id + "&subscriberListName=" + name;            
            llHTTPRequest(url, [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/x-www-form-urlencoded"], body);
            return;
        }
        if(message == "Unsubscribe")
        {
            string name = llStringToBase64(listName);
            string id = llStringToBase64((string)id);
            string url = listUrl + "unsubscribe" + listSuffix;
            string body = "subscriberId=" + id + "&subscriberListName=" + name;            
            llHTTPRequest(url, [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/x-www-form-urlencoded"], body);
            return;
        }
    }
    http_response(key request_id, integer status, list metadata, string body)
    {
        list data = llParseString2List(body, [";"], []);
        if(llList2Key(data, 0) == "OK")
        {
            string id = llList2Key(data, 1);
            string type = llList2String(data, 2);
            string value = llList2String(data, 3);
            if(type == "Status")
            {
                startListening();
                if(value == "Subscribed")
                    llDialog(id, "\n" + listName + "\n\n" + listDescription, ["Unsubscribe"], channel);
                else if(value == "Unsubscribed")
                    llDialog(id, "\n" + listName + "\n\n" + listDescription, ["Subscribe"], channel);
                else if(value == "Owner")
                    llDialog(id, "\n" + listName + "\n\n" + listDescription, ["Website"], channel);
            }
            else if(type == "Subscribe")
            {
                llDialog(id, "\n" + value, [], channel);
            }
            else if(type == "Unsubscribe")
            {
                llDialog(id, "\n" + value, [], channel);
            }
            else
            {
                llDialog(id, "\n" + type, [], channel);
            }
        }
        else if(llList2Key(data, 0) == "ERR")
        {
            string id = llList2Key(data, 1);
            string message = llList2String(data, 2);
            llInstantMessage(id, message);
        }
        else
            llWhisper(DEBUG_CHANNEL, body);
    }
}
