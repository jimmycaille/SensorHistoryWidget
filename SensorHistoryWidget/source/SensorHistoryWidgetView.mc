using Toybox.WatchUi;
using Toybox.Time.Gregorian;

class SensorHistoryWidgetView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
		if($.isEntered){
        	dc.setColor(dc.COLOR_WHITE,dc.COLOR_WHITE);
        	dc.clear();
        	dc.setColor(dc.COLOR_BLACK,dc.COLOR_TRANSPARENT);
		}else{
        	dc.setColor(dc.COLOR_BLACK,dc.COLOR_BLACK);
        	dc.clear();
        	dc.setColor(dc.COLOR_WHITE,dc.COLOR_TRANSPARENT);
        }
        switch($.globalvar){
        	case 0:
        		dc.drawText(dc.getWidth()/2, 40, dc.FONT_TINY, "Heartrate", dc.TEXT_JUSTIFY_CENTER|dc.TEXT_JUSTIFY_VCENTER);
        		drawGraph(dc,getHRIterator(),[40,90],[190,75], 1,"%d","bpm",$.globsettings[$.globalvar]);
        		break;
        	case 1:
        		dc.drawText(dc.getWidth()/2, 40, dc.FONT_TINY, "Temperature", dc.TEXT_JUSTIFY_CENTER|dc.TEXT_JUSTIFY_VCENTER);
        		drawGraph(dc,getTPIterator(),[40,90],[190,75], 1,"%.1f","°C",$.globsettings[$.globalvar]);
        		break;
        	case 2:
        		dc.drawText(dc.getWidth()/2, 40, dc.FONT_TINY, "Pressure", dc.TEXT_JUSTIFY_CENTER|dc.TEXT_JUSTIFY_VCENTER);
       			drawGraph(dc,getPRIterator(),[40,90],[190,75], 100,"%.2f","hpa",$.globsettings[$.globalvar]);
        		break;
        	case 3:
        		dc.drawText(dc.getWidth()/2, 40, dc.FONT_TINY, "Altitude", dc.TEXT_JUSTIFY_CENTER|dc.TEXT_JUSTIFY_VCENTER);
        		drawGraph(dc,getELIterator(),[40,90],[190,75], 1,"%.1f","m",$.globsettings[$.globalvar]);
        		break;
        	default:
        		
        		break;
        }
        
        
    }
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }
    //coord represent the top left corner of the graph [x, y]
    //size is [width, height]
    function drawGraph(dc, iterator, coord, size, divisor, format, unit, ignore){
    		var firstTime = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    		var lastTime = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    		var firstVal = 0.0;
    		var firstFound = false;
    		dc.drawLine(coord[0],coord[1],coord[0],coord[1]+size[1]);
    		dc.drawLine(coord[0],coord[1]+size[1],coord[0]+size[0],coord[1]+size[1]);
    		dc.drawLine(coord[0]+size[0],coord[1]+size[1],coord[0]+size[0],coord[1]);
			for(var i=size[0]-1;i>0;i--){
				var item = iterator.next();
				if(item == null){
					continue;
				}
				if(item.data != null && item.when != null){
					if(!firstFound){
						firstTime  = item.when;
						firstVal   = item.data;
						firstFound = true;
					}
					var value = (item.data-iterator.getMin())*size[1]/(iterator.getMax()-iterator.getMin());
					dc.drawLine(coord[0]+i,coord[1]+size[1]-1,coord[0]+i,coord[1]+size[1]-value);
					lastTime = item.when;
				}
				//ignore every n term
				for(var j=0;j<ignore;j++){
					item = iterator.next();
				}
			}
			dc.drawText(coord[0]-3, coord[1]+(size[1]/5),WatchUi.loadResource(Rez.Fonts.customFont), (iterator.getMax()/divisor).format(format), dc.TEXT_JUSTIFY_RIGHT|dc.TEXT_JUSTIFY_VCENTER);
			dc.drawText(coord[0]-3, coord[1]+(size[1]/5*4), WatchUi.loadResource(Rez.Fonts.customFont), (iterator.getMin()/divisor).format(format), dc.TEXT_JUSTIFY_RIGHT|dc.TEXT_JUSTIFY_VCENTER);
			dc.drawText(coord[0]+(size[0]/2),coord[1]-15,WatchUi.loadResource(Rez.Fonts.customFont),(firstVal/divisor).format(format)+unit, dc.TEXT_JUSTIFY_CENTER);
			var delta = firstTime.subtract(lastTime);
			dc.drawText(coord[0]+(size[0]/2),coord[1]+size[1], WatchUi.loadResource(Rez.Fonts.customFont), (delta.value()/3600.0).format("%.2f")+"h", dc.TEXT_JUSTIFY_CENTER);
    		
    		
    		//debug
    		/*
    		var newdelta = iterator.getNewestSampleTime().subtract(iterator.getOldestSampleTime());
    		dc.drawText(120,200,WatchUi.loadResource(Rez.Fonts.customFont),newdelta.value()/3600.0+"h",dc.TEXT_JUSTIFY_CENTER);
    		*/
    		dc.drawText(120,200,WatchUi.loadResource(Rez.Fonts.customFont),Application.getApp().getProperty("test"),dc.TEXT_JUSTIFY_CENTER);
    }
    // Create methods to get SensorHistoryIterator objects
	function getHRIterator() {
	    // Check device for SensorHistory compatibility
	    if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getHeartRateHistory)) {
	        return Toybox.SensorHistory.getHeartRateHistory({});
	    }
	    return null;
	}
	function getELIterator() {
	    // Check device for SensorHistory compatibility
	    if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getElevationHistory)) {
	        return Toybox.SensorHistory.getElevationHistory({});
	    }
	    return null;
	}
	function getPRIterator() {
	    // Check device for SensorHistory compatibility
	    if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getPressureHistory)) {
	        return Toybox.SensorHistory.getPressureHistory({});
	    }
	    return null;
	}
	function getTPIterator() {
	    // Check device for SensorHistory compatibility
	    if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getTemperatureHistory)) {
	        return Toybox.SensorHistory.getTemperatureHistory({});
	    }
	    return null;
	}

}
