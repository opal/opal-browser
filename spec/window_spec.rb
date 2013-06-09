require File.expand_path('../spec_helper', __FILE__)

describe Browser::Window do
	describe '#document' do
		it 'should return `document`' do
			$window.document.should == `document`
			$window.document.class.should == Browser::DOM::Document
		end
	end
end
