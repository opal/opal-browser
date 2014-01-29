require 'spec_helper'
require 'browser/storage'

describe Browser::Window do
  describe '#storage' do
    it 'creates a new storage' do
      expect($window.storage).to be_a(Browser::Storage)
    end

    it 'creates a storage with the proper name' do
      expect($window.storage.name).to eq(:default)
      expect($window.storage(:spec).name).to eq(:spec)
    end
  end

  describe '#session_storage' do
    it 'creates a new session storage' do
      expect($window.session_storage).to be_a(Browser::SessionStorage)
    end

    it 'creates a session storage with the proper name' do
      expect($window.session_storage.name).to eq(:default)
      expect($window.session_storage(:spec).name).to eq(:spec)
    end
  end if Browser::SessionStorage.supported?
end
