require 'spec_helper'
require 'browser/history'

describe Browser::History do
  describe '#current' do
    it 'should return the current location' do
      expect($window.history.current).to eq('/')
    end
  end

  describe '#push' do
    it 'should change location' do
      expect($window.history.current).to eq('/')
      $window.history.push('/lol')
      expect($window.history.current).to eq('/lol')
      $window.history.push('/')
      expect($window.history.current).to eq('/')
    end
  end

  describe '#back' do
    it 'should go back once' do
      expect($window.history.current).to eq('/')
      $window.history.push('/wut')
      expect($window.history.current).to eq('/wut')

      promise = Promise.new

      $window.on 'pop:state' do |e|
        e.off

        expect($window.history.current).to eq('/')
        promise.resolve
      end

      $window.history.back
      promise
    end
  end

  describe '#state' do
    it 'gets the right state' do
      $window.history.push('/wut', 42)
      $window.history.state.should eq(42)
      $window.history.push('/omg', 23)
      $window.history.state.should eq(23)

      promise = Promise.new

      $window.on 'pop:state' do |e|
        e.off

        expect(true).to eq(true)
        promise.resolve
      end

      $window.history.back(2)
      promise
    end
  end if Browser.supports? 'History.state'
end if Browser::History.supported?
