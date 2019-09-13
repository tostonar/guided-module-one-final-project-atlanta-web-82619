require_relative '../config/environment'
require_relative './cli.rb'


cli = Cli.new
cli.run
