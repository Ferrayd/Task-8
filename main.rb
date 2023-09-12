# frozen_string_literal: true

require_relative 'counter'
require_relative 'company_info'
require_relative 'validator'
require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'car'
require_relative 'passenger_car'
require_relative 'cargo_car'
require_relative 'interface'

my_app = TrainApp.new
my_app.action
