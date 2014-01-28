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
    async 'should go back once' do
      expect($window.history.current).to eq('/')
      $window.history.push('/wut')
      expect($window.history.current).to eq('/wut')

      $window.on 'pop:state' do |e|
        e.off

        async {
          expect($window.history.current).to eq('/')
        }
      end

      $window.history.back
    end
  end

  describe '#state' do
    async 'gets the right state' do
      $window.history.push('/wut', 42)
      $window.history.state.should eq(42)
      $window.history.push('/omg', 23)
      $window.history.state.should eq(23)

      $window.on 'pop:state' do |e|
        e.off

        async {
          expect(true).to eq(true)
        }
      end

      $window.history.back(2)
    end
  end if Browser.supports? 'History.state'
end if Browser::History.supported?
