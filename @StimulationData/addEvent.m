function data = addEvent(data,type,time)

ndx = strmatch(type,data.eventNames,'exact');
data.events(end).types(end+1) = ndx;
data.events(end).times(end+1) = time;
