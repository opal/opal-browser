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
    async 'calls the block with the transaction' do
      sql = SQL.new('test', size: SIZE)

      sql.transaction {|t|
        async {
          expect(t).to be_a(SQL::Transaction)
        }
      }
    end

    async 'the transaction database is the right one' do
      sql = SQL.new('test', size: SIZE)

      sql.transaction {|t|
        async {
          expect(t.database).to eq(sql)
        }
      }
    end
  end

  describe SQL::Transaction do
    describe '#query' do
      async 'returns a promise' do
        sql = SQL.new('test', size: SIZE)

        sql.transaction {|t|
          async {
            expect(t.query('hue')).to be_a(Promise)
          }
        }
      end

      async 'resolves on success' do
        sql = SQL.new('test', size: SIZE)

        sql.transaction {|t|
          t.query('CREATE TABLE IF NOT EXISTS test(ID INTEGER PRIMARY KEY ASC, a TEXT)').then {|r|
            async {
              expect(r).to be_a(SQL::Result)
            }
          }
        }
      end

      async 'rejects on failure' do
        sql = SQL.new('test', size: SIZE)

        sql.transaction {|t|
          t.query('huehue').rescue {|e|
            async {
              expect(e).to be_a(SQL::Error::Syntax)
            }
          }
        }
      end
    end
  end

  describe SQL::Result do
    describe '#length' do
      async 'has the proper length' do
        sql = SQL.new('test', size: SIZE)

        sql.transaction {|t|
          t.query('SELECT 1').then {|r|
            async {
              expect(r.length).to eq(1)
            }
          }
        }
      end
    end

    describe '#[]' do
      async 'returns a row' do
        sql = SQL.new('test', size: SIZE)

        sql.transaction {|t|
          t.query('SELECT 1, 2, 3').then {|r|
            async {
              expect(r[0]).to be_a(SQL::Row)
              expect(r[-1]).to be_a(SQL::Row)

              expect(r[0]).to eq(r[-1])
            }
          }
        }
      end

      async 'returns nil on missing row' do
        sql = SQL.new('test', size: SIZE)

        sql.transaction {|t|
          t.query('SELECT 1, 2, 3').then {|r|
            async {
              expect(r[5]).to be_nil
              expect(r[-5]).to be_nil
            }
          }
        }
      end
    end
  end
end if Browser::Database::SQL.supported?
