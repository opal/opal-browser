require 'browser/http'

describe Browser::HTTP do
  describe '.get' do
    async 'fetches a path' do
      Browser::HTTP.get('/spec/http/test') {|req|
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
      Browser::HTTP.get!('/spec/http/test').text.should == 'lol'
    end
  end

  describe '.post' do
    async 'sends parameters properly' do
      Browser::HTTP.post('/spec/http/test', lol: 'wut') {|req|
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
    end
  end

  describe '.post!' do
    it 'sends parameters properly' do
      Browser::HTTP.post!('/spec/http/test', lol: 'wut').text.should == 'ok'
    end
  end

  describe '.put' do
    async 'sends parameters properly' do
      Browser::HTTP.put('/spec/http/test', lol: 'wut') {|req|
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
    end
  end

  describe '.put!' do
    it 'sends parameters properly' do
      Browser::HTTP.put!('/spec/http/test', lol: 'wut').text.should == 'ok'
    end
  end

  describe '.delete' do
    async 'fetches a path' do
      Browser::HTTP.delete('/spec/http/test') {|req|
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

  describe '.delete!' do
    it 'fetches a path' do
      Browser::HTTP.delete!('/spec/http/test').text.should == 'lol'
    end
  end
end
