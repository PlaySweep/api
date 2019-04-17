unless Rails.env.production
  # Account
  League.find_or_create_by(name: "MLB", tenant: "Budweiser", image: "https://s3.amazonaws.com/budweiser-sweep-assets/bud_logo.png")

  # Teams
  Team.find_or_create_by(name: "St Louis Cardinals", account_id: 1, image: 'https://s3.amazonaws.com/budweiser-sweep-assets/st_louis_cardinals.png')
  Team.find_or_create_by(name: "Los Angeles Dodgers", account_id: 1, image: 'https://s3.amazonaws.com/budweiser-sweep-assets/los_angeles_dodgers.png')
  Team.find_or_create_by(name: "Chicago Cubs", account_id: 1, image: 'https://s3.amazonaws.com/budweiser-sweep-assets/chicago_cubs.png')
  Team.find_or_create_by(name: "San Diego Padres", account_id: 1, image: 'https://s3.amazonaws.com/budweiser-sweep-assets/san_diego_padres.png')
  Team.find_or_create_by(name: "New York Mets", account_id: 1, image: 'https://s3.amazonaws.com/budweiser-sweep-assets/new_york_mets.png')
  Team.find_or_create_by(name: "Washington Nationals", account_id: 1, image: 'https://s3.amazonaws.com/budweiser-sweep-assets/washington_nationals.png')

end