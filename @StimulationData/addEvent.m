function data = addEvent(data,eventType,eventTime)

i = data.nEvents + 1;
eventNdx = strmatch(eventType,data.eventNames,'exact');
data.curTrial.events(i) = eventNdx;
data.curTrial.eventTimes(i) = eventTime;
data.nEvents = i;
