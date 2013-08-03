require 'browser/http'

describe Browser::HTTP do
  describe '.get' do
    async 'fetches a path' do
      Browser::HTTP.get('/test') {|req|
        req.on :success do |resp|
          run_async {
            resp.text.should == 'lol'
          }
        end

        req.on :failure do
          run_async {
            fail
          }
        end
      }
    end
  end

  describe '.get!' do
    it 'fetches a path' do
      Browser::HTTP.get!('/test').text.should == 'lol'
    end
  end

  describe '.post' do
    async 'sends parameters properly' do
      begin
      Browser::HTTP.post('/test', lol: 'wut') {|req|
        req.on :success do |resp|
          run_async {
            resp.text.should == 'ok'
          }
        end

        req.on :failure do
          run_async {
            fail
          }
        end
      }
      rescue Exception => e
        log e.inspect
      end
    end
  end
end
