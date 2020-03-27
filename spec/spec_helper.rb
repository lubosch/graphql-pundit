# frozen_string_literal: true

require_relative 'support/simplecov'

require 'bundler/setup'
require 'graphql-pundit'
require 'fuubar'
require 'pry'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    TestSchema::Car.add_field(
      TestSchema::BaseField.from_options(
        name: :name,
        type: String,
        null: false
      )
    )
  end

  config.fuubar_progress_bar_options = { format: '[%B] %c/%C',
                                         progress_mark: '#',
                                         remainder_mark: '-' }
end

class TestSchema < GraphQL::Schema
  class BaseField < GraphQL::Schema::Field
    prepend GraphQL::Pundit::Scope
    prepend GraphQL::Pundit::Authorization
  end

  class Car < GraphQL::Schema::Object
    field :country, String, null: false
  end

  class Query < GraphQL::Schema::Object
    field_class BaseField

    field :car, Car, null: true

    def car
      ::Car.first
    end

    field :cars, [Car], null: true

    def cars
      ::Car
    end
  end

  use GraphQL::Execution::Interpreter
  use GraphQL::Analysis::AST
  query(Query)
end

class CarDataset
  attr_reader :cars

  def initialize(cars)
    @cars = cars
  end

  def object
    self
  end

  def where(&block)
    self.class.new(cars.select(&block))
  end

  def first
    cars.first
  end

  def all
    self
  end

  def to_a
    @cars
  end

  def model
    Car
  end
end

class Car
  attr_reader :name, :country

  def self.all
    CarDataset.new(CARS)
  end

  def self.object
    self
  end

  def self.where(&block)
    all.where(&block)
  end

  def self.first(&block)
    where(&block).first
  end

  def initialize(name, country)
    @name = name
    @country = country
  end

  CARS = [{ name: 'Toyota', country: 'Japan' },
          { name: 'Volkswagen Group', country: 'Germany' },
          { name: 'Hyundai', country: 'South Korea' },
          { name: 'General Motors', country: 'USA' },
          { name: 'Ford', country: 'USA' },
          { name: 'Nissan', country: 'Japan' },
          { name: 'Honda', country: 'Japan' },
          { name: 'Fiat Chrysler', country: 'Italy' },
          { name: 'Renault', country: 'France' },
          { name: 'Groupe PSA', country: 'France' },
          { name: 'Suzuki', country: 'Japan' },
          { name: 'SAIC', country: 'China' },
          { name: 'Daimler', country: 'Germany' },
          { name: 'BMW', country: 'Germany' },
          { name: 'Changan', country: 'China' },
          { name: 'Mazda', country: 'Japan' },
          { name: 'BAIC', country: 'China' },
          { name: 'Dongfeng Motor', country: 'China' },
          { name: 'Geely', country: 'China' },
          { name: 'Great Wall', country: 'China' }]
    .map { |c| Car.new(c[:name], c[:country]) }
end

class CarPolicy
  class Scope
    attr_reader :scope

    def initialize(_user, scope)
      @scope = scope
    end

    def resolve
      @scope.where { |c| c.country == 'Germany' }
    end
  end

  def initialize(_user, car)
    @car = car
  end

  def cars?
    false
  end

  def name?
    false
  end

  def display_name?
    false
  end
end

class ChineseCarPolicy
  class Scope
    def initialize(_user, scope)
      @scope = scope
    end

    def resolve
      @scope.where { |c| c.country == 'China' }
    end
  end

  def initialize(_user, car)
    @car = car
  end

  def name?
    false
  end

  def display_name?
    false
  end
end
