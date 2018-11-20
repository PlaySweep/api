slate = Slate.create(name: "Monday Night Madness", description: "The Chiefs battle the Rams on Monday Night Football", start_time: DateTime.current-2, type: "")
event = Event.create(description: "Will Mahomes throw for over 6 TDs tonight?", slate_id: slate.id)
s1 = Selection.create(description: "Yes", event_id: event.id)
s2 = Selection.create(description: "No", event_id: event.id)

slate2 = Slate.create(name: "Thursday Night Madness", description: "The Titans battle the Texans, eek", start_time: DateTime.current-1, type: "")
event2 = Event.create(description: "Will Mahomes throw for over 6 TDs tonight?", slate_id: slate2.id)
s3 = Selection.create(description: "Yes", event_id: event2.id)
s4 = Selection.create(description: "No", event_id: event2.id)

slate3 = Slate.create(name: "Thursday Night Madness", description: "The Titans battle the Texans, eek", start_time: DateTime.current, type: "")
event3 = Event.create(description: "Will Mahomes throw for over 6 TDs tonight?", slate_id: slate3.id)
s5 = Selection.create(description: "Yes", event_id: event3.id)
s6 = Selection.create(description: "No", event_id: event3.id)