# Account
League.find_or_create_by(name: "MLB", tenant: "Budweiser", image: "https://s3.amazonaws.com/budweiser-sweep-assets/bud_logo.png")

# Teams
Team.find_or_create_by(name: "St Louis Cardinals", image: 'https://s3.amazonaws.com/budweiser-sweep-assets/st_louis_cardinals.png')
Team.find_or_create_by(name: "Los Angeles Dodgers", image: 'https://s3.amazonaws.com/budweiser-sweep-assets/los_angeles_dodgers.png')
Team.find_or_create_by(name: "Chicago Cubs", image: 'https://s3.amazonaws.com/budweiser-sweep-assets/chicago_cubs.png')