require 'spec_helper'
require 'browser/http'

describe Browser::HTTP do
  let(:path) { '/http' }
  let(:path_file) { '/http-file' }

  describe '.get' do
    it 'fetches a path' do
      Browser::HTTP.get(path).then {|res|
        expect(res.text).to eq('lol')
      }.rescue {
        fail
      }
    end
  end

  describe '.get!' do
    it 'fetches a path', :requires_server do
      expect(Browser::HTTP.get!(path).text).to eq('lol')
    end
  end

  describe '.post' do
    it 'sends parameters properly' do
      Browser::HTTP.post(path, lol: 'wut').then {|res|
        expect(res.text).to eq('ok')
      }.rescue {
        fail
      }
    end
  end

  describe '.post!', :requires_server do
    it 'sends parameters properly' do
      expect(Browser::HTTP.post!(path, lol: 'wut').text).to eq('ok')
    end

    it 'sends files properly' do
      file = Browser::File.create(["content"], "yay.txt", type: "text/plain")
      expect(Browser::HTTP.post!(path_file, lol: 'wut', file: file).text).to eq('ok')
    end
  end

  describe '.put' do
    it 'sends parameters properly' do
      Browser::HTTP.put(path, lol: 'wut').then {|res|
        expect(res.text).to eq('ok')
      }.rescue {
        fail
      }
    end
  end

  describe '.put!', :requires_server do
    it 'sends parameters properly' do
      expect(Browser::HTTP.put!(path, lol: 'wut').text).to eq('ok')
    end
  end

  describe '.delete' do
    it 'fetches a path' do
      Browser::HTTP.delete(path).then {|res|
        expect(res.text).to eq('lol')
      }.rescue {
        fail
      }
    end
  end

  describe '.delete!', :requires_server do
    it 'fetches a path' do
      expect(Browser::HTTP.delete!(path).text).to eq('lol')
    end
  end
end if Browser::HTTP.supported?
