using Toybox.Background;
using Toybox.System;

(:background)
class MyServiceDelegate extends System.ServiceDelegate {


/*
    // When a scheduled background event triggers, make a request to
    // a service and handle the response with a callback function
    // within this delegate.
    function onTemporalEvent() {
        Communications.makeWebRequest(
            "https://myrequesturl.com",
            {},
            {},
            method(:responseCallback)
        );
    }

    function responseCallback(responseCode, data) {
        // Do stuff with the response data here and send the data
        // payload back to the app that originated the background
        // process.
        Background.exit(backgroundData);
    }
*/
    
	function initialize() {
		System.ServiceDelegate.initialize();

	}
    
    function onTemporalEvent() {
    
    //TODO TEST CONCATENATE DATA FROM PREVIOUS SERVICE RUN
    //https://developer.garmin.com/downloads/connect-iq/monkey-c/doc/Toybox/Background.html
	//getBackgroundData ⇒ Object   - Get data previously saved by a background process.
    	
    	var now = System.getClockTime();
    	var ts  = now.hour+":"+now.min.format("%02d");
        System.println("bg exit: "+ts);
        //just return the timestamp
        
        //test
        var prev = Background.getBackgroundData();
        if(prev != null){
        	prev.add(ts);
        	Background.exit(ts);
        }else{
        	Background.exit([ts]);
        }
        
        //Background.exit(ts);
    }
    
}