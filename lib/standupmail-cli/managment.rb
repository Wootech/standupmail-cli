module StandupmailCli
  class Managment
    BLOCKED = "\e[31m⨉\e[0m"
    DONE = "\e[32m✓\e[0m"
    WORKING = "\e[34m→\e[0m"

    def self.teams
      teams = Request.get_teams
      teams.each.with_index.reduce('') do |memo, (word, index)|
        memo + "[#{index}]" + " #{word[:name]}\n"
      end
    end

    def self.prepare_message(team, done, working, blocked)
      team_id = Request.get_teams[team][:id]
      type = { done: done, working: working, blocked: blocked }.reject { |_, v| v.nil? }
      case
      when !type[:done].nil?
        str = "Well done!\n"
      when !type[:working].nil?
        str = "Stay hungry! Stay foolish!\n"
      when !type[:blocked].nil?
        str = "Everything will gonna be ok!\n"
      end
      msg = type.values.join(' ')
      values = { messages: [{ type: type.keys.join(''), msg: msg }] }.to_json
      Request.post_messages(team_id, values)
      str
    end

    def self.digest(team, date_range)
      team_id = Request.get_teams[team][:id]
      messages = Request.get_digest(team_id, date_range)
      return "Sorry, digest was empty for this day.\n" if messages.empty?
      format_block("Digest for #{messages[0][:date]}") + format_digest(messages.first[:messages])
    end

    private

    def self.format_block(message)
      divider = '-' * message.length
      divider + "\n" + message + "\n" + divider + "\n\n"
    end

    def self.format_digest(messages)
      str = ''
      messages.each do |message|
        str += message[:user_name] + ":\n"
        next str += "   didn't answer\n" if message[:message].empty?
        message[:message].each { |content| str += format_message(content[:type], content[:msg]) }
        str += "\n"
      end
      str
    end

    def self.format_message(type, message)
      "   #{const_get(type.upcase)}  #{message}\n"
    end
  end
end
