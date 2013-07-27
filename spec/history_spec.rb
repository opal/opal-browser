require 'spec_helper'

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

      $window.on 'pop:state' do
        run_async {
          $window.history.current.should == '/'
        }

        $window.off('pop:state')
      end

      $window.history.back
    end
  end
end
