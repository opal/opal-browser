require 'promise'
require 'ostruct'

module Browser; module Database

class SQL
  # Check if the browser supports WebSQL.
  def self.supported?
    Browser.supports? 'WebSQL'
  end

  class Error < StandardError
    def self.new(error)
      return super if self != Error

      [Unknown, Database, Version, TooLarge, Quota, Syntax, Constraint, Timeout] \
        [`error.code`].new(`error.message`)
    end

    Unknown    = Class.new(self)
    Database   = Class.new(self)
    Version    = Class.new(self)
    TooLarge   = Class.new(self)
    Quota      = Class.new(self)
    Syntax     = Class.new(self)
    Constraint = Class.new(self)
    Timeout    = Class.new(self)
  end

  include Native

  # @return [String] the name of the database
  attr_reader :name

  # @return [String] the description for the database
  attr_reader :description

  # @return [Integer] the size constraint in bytes
  attr_reader :size

  # Open a database with the given name and options.
  #
  # @param name [String] the name for the database
  # @param options [Hash] options to open the database
  #
  # @option options [String] :description the description for the database
  # @option options [String] :version ('') the expected version of the database
  # @option options [Integer] :size (5 * 1024 * 1024) the size constraint in bytes
  def initialize(name, options = {})
    @name        = name
    @description = options[:description] || name
    @version     = options[:version]     || ''
    @size        = options[:size]        || 2 * 1024 * 1024

    super(`window.openDatabase(#{name}, #{@version}, #{@description}, #{@size})`)
  end

  # @overload version()
  #
  #   Get the version of the database.
  #
  #   @return [String]
  #
  # @overload version(from, to, &block)
  #
  #   Migrate the database to a new version.
  #
  #   @param from [String] the version you're migrating from
  #   @param to [String] the version you're migrating to
  #
  #   @yieldparam transaction [Transaction] the transaction to work with
  def version(from = nil, to = nil, &block)
    return `#@native.version` unless block

    `#@native.changeVersion(#{from}, #{to},
      #{-> t { block.call(Transaction.new(self, t)) }})`
  end

  # Start a transaction on the database.
  #
  # @yieldparam transaction [Transaction] the transaction to work on
  def transaction(&block)
    raise ArgumentError, 'no block given' unless block

    `#@native.transaction(#{-> t { block.call(Transaction.new(self, t)) }})`
  end

  # Allows you to make changes to the database or read data from it.
  class Transaction
    include Native

    # @return [Database] the database the transaction has been created from
    attr_reader :database

    # @private
    def initialize(database, transaction)
      @database = database

      super(transaction)
    end

    # Query the database.
    #
    # @param query [String] the SQL query to send
    # @param parameters [Array] optional bind parameters for the query
    #
    # @return [Promise]
    def query(query, *parameters)
      promise = Promise.new

      `#@native.executeSql(#{query}, #{parameters},
        #{-> _, r { promise.resolve(Result.new(self, r)) }},
        #{-> _, e { promise.reject(Error.new(e)) }})`

      promise
    end
  end

  # Represents a row.
  class Row < OpenStruct
    # @private
    def initialize(row)
      super(Hash.new(row))
    end

    def inspect
      "#<SQL::Row: #{Hash.new(@native).inspect}>"
    end
  end

  class Result
    include Native

    # @return [Transaction] the transaction the result came from
    attr_reader :transaction

    # @return [SQL] the database the result came from
    attr_reader :database

    # @private
    def initialize(transaction, result)
      @transaction = transaction
      @database    = transaction.database

      super(result)
    end

    include Enumerable

    # Get a row from the result.
    #
    # @param index [Integer] the index for the row
    #
    # @return [Row]
    def [](index)
      if index < 0
        index += length
      end

      unless index < 0 || index >= length
        Row.new(`#@native.rows.item(index)`)
      end
    end

    # Enumerate over the rows.
    #
    # @yieldparam row [Row]
    #
    # @return [self]
    def each(&block)
      return enum_for :each unless block

      %x{
        for (var i = 0, length = #@native.rows.length; i < length; i++) {
          #{block.call(self[`i`])};
        }
      }

      self
    end

    # @!attribute [r] length
    # @return [Integer] number of rows in the result
    def length
      `#@native.rows.length`
    end

    # @!attribute [r] affected
    # @return [Integer] number of affected rows
    alias_native :affected, :rowsAffected
  end
end

end; end
