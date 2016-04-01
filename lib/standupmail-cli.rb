require 'standupmail-cli/version'
require 'thor'
require 'time'
require 'rest_client'
require 'base64'
require 'standupmail-cli/authorization'
require 'standupmail-cli/managment'
require 'standupmail-cli/request'
require 'yaml'
require 'json'
require 'api-auth'

module StandupmailCli
  class Standupmail < Thor
    map %w(--authorize -a) => :authorize
    map %w(--version -v) => :show_version
    default_command :message

    desc 'authorize', 'Authorization in www.standupmail.com'
    long_desc <<-LONGDESC
      To get your access id and token:

      Login to your account on www.standupmail.com,
      go to account settings and click 'GENERATE NEW TOKEN'
      When you run autorization you should paste token and access id.

      Setup is required only once.
    LONGDESC
    def authorize
      Authorization.login
    end

    desc 'teams', 'Show teams list'
    def teams
      print Managment.teams
    end

    desc 'message', 'Send message'
    method_option :team,    type: :numeric, aliases: '-t', required: true, default: 0
    method_option :done,    type: :array, aliases: '-d'
    method_option :working, type: :array, aliases: '-n'
    method_option :blocked, type: :array, aliases: '-b'
    def message
      return print Managment.prepare_message(options[:team],
                                             options[:done],
                                             options[:working],
                                             options[:blocked]) if options.length != 1
      return help if options[:team] == 0 
      puts "Add message with option '[ -d | -n | -b ] <message>'"
    end

    desc 'digest', 'Show digest'
    method_option :team,    type: :numeric, aliases: '-t', required: true, default: 0
    def digest(date = 'today')
      print Managment.digest(options[:team], digest_dates_range(date))
    rescue ArgumentError
      puts 'wrong argument'
    end 

    desc '-v | --version', 'Show version'
    def show_version
      puts "standupmail-cli #{VERSION}"
    end

    desc '-h | --help', 'Show this screen'
    def help(command = nil)
      if command == nil
        path = File.expand_path("../standupmail-cli/help.txt", __FILE__)
        file = File.open(path, 'r')
        contents = file.read
        return puts contents
      end
      return self.class.subcommand_classes[command].help(shell, true) if self.class.subcommands.include? command
      self.class.command_help(shell, command)
    end

    private

    def digest_dates_range(date)
      return (Date.today-1..Date.today) if date == 'today'
      return (Date.today-1..Date.today-2) if date == 'yesterday'
      (Date.parse(date)-1)..Date.parse(date)
    end
  end
end
