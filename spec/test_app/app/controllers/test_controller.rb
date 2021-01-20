class TestController < ApplicationController
  def get_delete
    render plain: 'lol'
  end

  def post_put
    raise 'lol param does not eq wut' unless params['lol'] == 'wut'

    render plain: 'ok'
  end

  def post_file
    file = params['file']
    raise 'bad file name' unless file.original_filename == 'yay.txt'
    raise 'bad content'   unless file.tempfile.read == 'content'

    render plain: 'ok'
  end
end
