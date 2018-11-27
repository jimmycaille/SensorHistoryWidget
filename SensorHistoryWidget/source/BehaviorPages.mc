using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;

class BehaviorPages extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onPreviousPage() {
    	$.globalvar = $.globalvar == 0 ? 3 : $.globalvar - 1 ;
    	System.println("onPrevious pages");
    	var view = new SensorHistoryWidgetView();
        var delegate = new BehaviorPages();
        WatchUi.switchToView(view, delegate, WatchUi.SLIDE_DOWN);
        return false;
    }

    function onNextPage() {
    	$.globalvar = $.globalvar == 3 ? 0 : $.globalvar + 1 ;
    	System.println("onNext pages");
    	var view = new SensorHistoryWidgetView();
        var delegate = new BehaviorPages();
        WatchUi.switchToView(view, delegate, WatchUi.SLIDE_UP);
        return false;
    }
    
    function onSelect() {
    	$.globsettings[$.globalvar] = $.globsettings[$.globalvar] == 3 ? 0 : $.globsettings[$.globalvar]+1;
    	System.println("KEY_ENTER"+$.globsettings);
        WatchUi.requestUpdate();
        return false;
    }
    
    function onBack() {
    	$.isEntered = false;
    	System.println("onBack pages");
    	WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }
}
