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
        async {
          expect($window.history.current).to eq('/')
        }

        e.off
      end

      $window.history.back
    end
  end
end if Browser::History.supported?
