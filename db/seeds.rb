#
#contents = [
#'Lorem ipsum dolor sit amet.',
#'Consectetur adipisicing elit, sed do eiusmod tempor incididunt.',
#'Labore et dolore magna aliqua.',
#'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.',
#'Excepteur sint occaecat cupidatat non proident.'
#]
#
#puts "Deleting all articles..."
#Article.delete_all
#
#unless ENV['COUNT']
#
#  puts "Creating articles..."
#  %w[ One Two Three Four Five ].each_with_index do |title, i|
#    Article.create :title => title, :content => contents[i], :published_on => i.days.ago.utc
#  end
#
#else
#
#  puts "Creating 10,000 articles..."
#  (1..ENV['COUNT'].to_i).each_with_index do |title, i|
#    Article.create :title => "Title #{title}", :content => 'Lorem', :published_on => i.days.ago.utc
#    print '.'
#  end
#
#end


CityState = Struct.new(:city, :state)

city_states = [
  CityState.new('Boston',      'Massachusetts'),
  CityState.new('Worcester',   'Massachusetts'),
  CityState.new('Providence',  'Rhode Island'),
  CityState.new('Springfield', 'Massachusetts'),
  CityState.new('Bridgeport',  'Connecticut'),
  CityState.new('New Haven',   'Connecticut'),
  CityState.new('Hartford',    'Connecticut'),
  CityState.new('Stamford',    'Connecticut'),
  CityState.new('Waterbury',   'Connecticut'),
  CityState.new('Manchester',  'New Hampshire'),
  CityState.new('Lowell',      'Massachusetts'),
  CityState.new('Cambridge',   'Massachusetts'),
  CityState.new('New Bedford', 'Massachusetts'),
  CityState.new('Brockton',    'Massachusetts'),
  CityState.new('Quincy',      'Massachusetts'),
  CityState.new('Lynn',        'Massachusetts'),
  CityState.new('Fall River',  'Massachusetts'),
  CityState.new('Nashua',      'New Hampshire'),
  CityState.new('Norwalk',     'Connecticut'),
  CityState.new('Newton',      'Massachusetts'),
]

(1..10).each do

  city_state = city_states.sample

  # create person
  person = Person.create({
    first_name: RandomWord.nouns.next,
    last_name:  RandomWord.nouns.next,
    age:        Random.rand(1..100),
    city:       city_state.city,
    state:      city_state.state,
  })

  # create things
  things = (1..10).map do
    Thing.create({
      name:        RandomWord.nouns.next,
      description: RandomWord.nouns.next,
    })
  end

  person.things = things
  person.save

end
