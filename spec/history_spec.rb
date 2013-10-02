require 'spec_helper'
require 'browser/history'

describe Browser::History do
  describe '#current' do
    it 'should return the current location' do
      $window.history.current.should == '/'
    end
  end

  describe '#push' do
    it 'should change location' do
      $window.history.current.should == '/'
      $window.history.push('/lol')
      $window.history.current.should == '/lol'
      $window.history.push('/')
      $window.history.current.should == '/'
    end
  end

  describe '#back' do
    async 'should go back once' do
      $window.history.current.should == '/'
      $window.history.push('/wut')
      $window.history.current.should == '/wut'

      $window.on 'pop:state' do |e|
        run_async {
          $window.history.current.should == '/'
        }

        e.off
      end

      $window.history.back
    end
  end

  describe '#state' do
    it 'gets the right state' do
      $window.history.push('/wut', 42)
      $window.history.state.should == 42
      $window.history.push('/omg', 23)
      $window.history.state.should == 23
      $window.history.back(2)
    end
  end
end
