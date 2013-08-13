require 'spec_helper'
require 'browser/storage'

describe Browser::Window do
  describe '#storage' do
    it 'creates a new storage' do
      $window.storage.should be_kind_of Browser::Storage
    end

    it 'creates a storage with the proper name' do
      $window.storage.name.should == :default
      $window.storage(:spec).name.should == :spec
    end
  end

  describe '#session_storage' do
    it 'creates a new session storage' do
      $window.session_storage.should be_kind_of Browser::SessionStorage
    end

    it 'creates a session storage with the proper name' do
      $window.session_storage.name.should == :default
      $window.session_storage(:spec).name.should == :spec
    end
  end
end
