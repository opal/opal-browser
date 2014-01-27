require 'spec_helper'
require 'browser/http'

describe Browser::HTTP do
  let :path do
    '/http'
  end

  describe '.get' do
    async 'fetches a path' do
      Browser::HTTP.get(path).then {|res|
        async {
          expect(res.text).to eq('lol')
        }
      }.rescue {
        async {
          fail
        }
      }
    end
  end

  describe '.get!' do
    it 'fetches a path' do
      expect(Browser::HTTP.get!(path).text).to eq('lol')
    end
  end

  describe '.post' do
    async 'sends parameters properly' do
      Browser::HTTP.post(path, lol: 'wut').then {|res|
        async {
          expect(res.text).to eq('ok')
        }
      }.rescue {
        async {
          fail
        }
      }
    end
  end

  describe '.post!' do
    it 'sends parameters properly' do
      expect(Browser::HTTP.post!(path, lol: 'wut').text).to eq('ok')
    end
  end

  describe '.put' do
    async 'sends parameters properly' do
      Browser::HTTP.put(path, lol: 'wut').then {|res|
        async {
          expect(res.text).to eq('ok')
        }
      }.rescue {
        async {
          fail
        }
      }
    end
  end

  describe '.put!' do
    it 'sends parameters properly' do
      expect(Browser::HTTP.put!(path, lol: 'wut').text).to eq('ok')
    end
  end

  describe '.delete' do
    async 'fetches a path' do
      Browser::HTTP.delete(path).then {|res|
        async {
          expect(res.text).to eq('lol')
        }
      }.rescue {
        async {
          fail
        }
      }
    end
  end

  describe '.delete!' do
    it 'fetches a path' do
      expect(Browser::HTTP.delete!(path).text).to eq('lol')
    end
  end
end if Browser::HTTP.supported?
