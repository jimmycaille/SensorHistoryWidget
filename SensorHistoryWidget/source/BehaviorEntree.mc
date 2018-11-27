using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;

class BehaviorEntree extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }
    
    function onSelect() {
    	System.println("onSelect Entree");
    	$.isEntered = true;
    	var view     = new SensorHistoryWidgetView();
        var delegate = new BehaviorPages();
        WatchUi.pushView(view, delegate, WatchUi.SLIDE_LEFT);
        return false;
    }
}
