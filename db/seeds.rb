unless Rails.env.production?
  Apartment::Tenant.switch!('budweiser')

  slate1 = Slate.create(name: "Orioles vs White Sox", global: true, start_time: DateTime.current + 2.days, team_id: 7, field: "away", opponent_id: 6)
  slate2 = Slate.create(name: "Nationals @ Marlins", global: true, start_time: DateTime.current + 3.days, team_id: 9, field: "home", opponent_id: 8)


  event1 = slate1.events.create(description: "Will a home run be hit?", order: 1)
  event2 = slate1.events.create(description: "Will it go extra innings?", order: 2)
  event3 = slate1.events.create(description: "Who will win?", order: 3)

  event1.selections.create(description: "Yes", order: 1)
  event1.selections.create(description: "No", order: 2)

  event2.selections.create(description: "Yes", order: 1)
  event2.selections.create(description: "No", order: 2)

  event3.selections.create(description: "Orioles", order: 1)
  event3.selections.create(description: "White Sox", order: 2)

  event4 = slate2.events.create(description: "Will a home run be hit?", order: 1)
  event5 = slate2.events.create(description: "Will it go extra innings?", order: 2)
  event6 = slate2.events.create(description: "Who will win?", order: 3)

  event4.selections.create(description: "Yes", order: 1)
  event4.selections.create(description: "No", order: 2)

  event5.selections.create(description: "Yes", order: 1)
  event5.selections.create(description: "No", order: 2)

  event6.selections.create(description: "Nationals", order: 1)
  event6.selections.create(description: "Marlins", order: 2)
end