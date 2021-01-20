require 'spec_helper'
require 'browser/http'

describe Browser::HTTP do
  let!(:path) { '/http' }
  let!(:path_file) { '/http-file' }

  # Actual requests are routed to test_app/app/test_controller.rb

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
    it 'fetches a path', :js do
      expect { Browser::HTTP.get!(path).text }.on_client_to eq('lol')
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

  describe '.post!', :js do
    it 'sends parameters properly' do
      expect { Browser::HTTP.post!(path, lol: 'wut').text }.on_client_to eq('ok')
    end

    it 'sends files properly' do
      expect do
        file = Browser::File.create(["content"], "yay.txt", type: "text/plain")
        Browser::HTTP.post!(path_file, lol: 'wut', file: file).text
      end.on_client_to eq('ok')
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

  describe '.put!', :js do
    it 'sends parameters properly' do
      expect { Browser::HTTP.put!(path, lol: 'wut').text }.on_client_to eq('ok')
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

  describe '.delete!', :js do
    it 'fetches a path' do
      expect { Browser::HTTP.delete!(path).text }.on_client_to eq('lol')
    end
  end
end if Browser::HTTP.supported?
