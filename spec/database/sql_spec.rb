require 'spec_helper'
require 'browser/database/sql'

describe Browser::Database::SQL do
  SQL  = Browser::Database::SQL
  SIZE = 1024 * 1024

  describe '#new' do
    it 'sets the attributes properly' do
      sql = SQL.new('test', description: 'trains', size: SIZE)

      expect(sql.name).to eq('test')
      expect(sql.description).to eq('trains')
      expect(sql.size).to eq(SIZE)
    end

    it 'sets the version properly' do
      sql = SQL.new('test2', version: '1.0', size: SIZE)
      expect(sql.version).to eq('1.0')

      sql = SQL.new('test', size: SIZE)
      expect(sql.version).to eq('')
    end
  end

  describe '#transaction' do
    it 'calls the block with the transaction' do
      sql = SQL.new('test', size: SIZE)

      promise = Browser::Promise.new
      sql.transaction {|t|
        expect(t).to be_a(SQL::Transaction)
        promise.resolve
      }
      promise.for_rspec
    end

    it 'the transaction database is the right one' do
      sql = SQL.new('test', size: SIZE)

      promise = Browser::Promise.new
      sql.transaction {|t|
        expect(t.database).to eq(sql)
        promise.resolve
      }
      promise.for_rspec
    end
  end

  describe SQL::Transaction do
    describe '#query' do
      it 'returns a promise' do
        sql = SQL.new('test', size: SIZE)

        promise = Browser::Promise.new
        sql.transaction {|t|
          expect(t.query('hue')).to be_a(Promise)
          promise.resolve
        }
        promise.for_rspec
      end

      it 'resolves on success' do
        sql = SQL.new('test', size: SIZE)

        promise = Browser::Promise.new
        sql.transaction {|t|
          t.query('CREATE TABLE IF NOT EXISTS test(ID INTEGER PRIMARY KEY ASC, a TEXT)').then {|r|
            expect(r).to be_a(SQL::Result)
            promise.resolve
          }
        }
        promise.for_rspec
      end

      it 'rejects on failure' do
        sql = SQL.new('test', size: SIZE)

        promise = Browser::Promise.new
        sql.transaction {|t|
          t.query('huehue').rescue {|e|
            expect(e).to be_a(SQL::Error::Syntax)
            promise.resolve
          }
        }
        promise.for_rspec
      end
    end
  end

  describe SQL::Result do
    describe '#length' do
      it 'has the proper length' do
        sql = SQL.new('test', size: SIZE)

        promise = Browser::Promise.new
        sql.transaction {|t|
          t.query('SELECT 1').then {|r|
            expect(r.length).to eq(1)
            promise.resolve
          }
        }
        promise.for_rspec
      end
    end

    describe '#[]' do
      it 'returns a row' do
        sql = SQL.new('test', size: SIZE)

        promise = Browser::Promise.new
        sql.transaction {|t|
          t.query('SELECT 1, 2, 3').then {|r|
            expect(r[0]).to be_a(SQL::Row)
            expect(r[-1]).to be_a(SQL::Row)

            expect(r[0]).to eq(r[-1])
            promise.resolve
          }
        }
        promise.for_rspec
      end

      it 'returns nil on missing row' do
        sql = SQL.new('test', size: SIZE)

        promise = Browser::Promise.new
        sql.transaction {|t|
          t.query('SELECT 1, 2, 3').then {|r|
            expect(r[5]).to be_nil
            expect(r[-5]).to be_nil
            promise.resolve
          }
        }
        promise.for_rspec
      end
    end
  end
end if Browser::Database::SQL.supported?
