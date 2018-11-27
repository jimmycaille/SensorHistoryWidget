using Toybox.Application;
using Toybox.Time;

var globalvar    = 0;
var globsettings = [0, 0, 0, 0];
var isEntered    = false;


// info about whats happening with the background process
var counter=0;
var bgdata="none";
var canDoBG=false;
// keys to the object store data
var OSCOUNTER="oscounter";
var OSDATA="osdata";


class SensorHistoryWidgetApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    	$.globalvar = Application.getApp().getProperty("globalvar") != null ? Application.getApp().getProperty("globalvar") : 0;
    	$.globsettings = Application.getApp().getProperty("globset") != null ? Application.getApp().getProperty("globset") : [0,0,0,0];
    	/*
    	
		using Toybox.Application.Storage;
        //https://developer.garmin.com/downloads/connect-iq/monkey-c/doc/Toybox/Application/Storage.html
        var int = 0;
        if(Storage has :number){
        	int = Storage.getValue(number);
       	}
        System.println("app launched:"+int);
        int += 1;
        Storage.setValue("number", int);
    	
    	
    	*/
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    	Application.getApp().setProperty("globalvar",$.globalvar);
    	Application.getApp().setProperty("globset",$.globsettings);
    }

    // Return the initial view of your application here
    function getInitialView() {
        
        
        
        //register for temporal events if they are supported
    	if(Toybox.System has :ServiceDelegate) {
    		//canDoBG=true;
    		System.println("test a");
    		Background.registerForTemporalEvent(new Time.Duration(300));
    		System.println("test b");
    	} else {
    		System.println("****background not available on this device****");
    	}
    	
    	
    	
        return [ new SensorHistoryWidgetView(), new BehaviorEntree() ];
    }


//FOLLOWING FOR SERVICE
    function onBackgroundData(data) {
    
    
    
    //TODO MANAGE ARRAY VALUES
    	var test = Application.getApp().getProperty("test");
    	test = test != null ? test + data.size() : 1; //test with size of array
    	Application.getApp().setProperty("test",test);
    
    	counter++;
    	var now=System.getClockTime();
    	var ts=now.hour+":"+now.min.format("%02d");
        System.println("onBackgroundData="+data+" "+counter+" at "+ts);
        bgdata=data;
        Application.getApp().setProperty(OSDATA,bgdata);
        WatchUi.requestUpdate();
    }    

    function getServiceDelegate(){
    	
    	var now=System.getClockTime();
    	var ts=now.hour+":"+now.min.format("%02d");    
    	System.println("getServiceDelegate: "+ts);
        return [new MyServiceDelegate()];
    }
}