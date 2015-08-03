Lita.configure do |config|
  # The name your robot will use.
  config.robot.name = "lita"

  # The locale code for the language to use.
  # config.robot.locale = :en

  config.robot.admins = ENV["ADMINS_LIST"]  

  # The severity of messages to log. Options are:
  # :debug, :info, :warn, :error, :fatal
  # Messages at the selected level and above will be logged.
  config.robot.log_level = :info

  # An array of user IDs that are considered administrators. These users
  # the ability to add and remove other users from authorization groups.
  # What is considered a user ID will change depending on which adapter you use.
  # config.robot.admins = ["1", "2"]

  # The adapter you want to connect with. Make sure you've added the
  # appropriate gem to the Gemfile.
  config.robot.adapter = :slack
  config.adapters.slack.token = ENV["SLACK_TOKEN"]

  ## Set options for the Redis connection.
  config.redis[:url] = ENV["REDISTOGO_URL"]
  config.http.port = ENV["PORT"]

  # Username normalization
  normalized_karma_user_term = ->(user_id, user_name) {
    "@#{user_id} (#{user_name})" #=> @UUID (Liz Lemon)
  }

  # Karma settings
  config.handlers.karma.cooldown = 300
  config.handlers.karma.term_normalizer = lambda do |full_term|
    term = full_term.to_s.strip.sub(/[<:]([^>:]+)[>:]/, '\1')
    user = Lita::User.fuzzy_find(term.sub(/\A@/, ''))
    if user
      normalized_karma_user_term.call(user.id, user.name)
    else
      term.downcase
    end
  end

  config.handlers.slack_karma_sync.user_term_normalizer = normalized_karma_user_term
  
  # Giphy public api key
  config.handlers.giphy.api_key = "dc6zaTOxFJmzC"

  config.handlers.urban_dictionary.max_response_size = 5
end

