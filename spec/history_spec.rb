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

      $window.one 'pop:state' do |e|
        expect($window.history.current).to eq('/')
        promise.resolve
      end

      $window.history.back
      promise
    end
  end

  describe '#state' do
    it 'gets the right state' do
      # XX: The previous test creates a race condition with this one.
      # Adding a delay fixes it.
      promise = Promise.new

      after 0.05 do
        $window.history.push('/wut', 42)
        $window.history.state.should eq(42)
        $window.history.push('/omg', 23)
        $window.history.state.should eq(23)

        $window.one 'pop:state' do |e|
          expect(true).to eq(true)
          promise.resolve
        end

        $window.history.back(2)
      end
      promise
    end
  end if Browser.supports? 'History.state'
end if Browser::History.supported?
