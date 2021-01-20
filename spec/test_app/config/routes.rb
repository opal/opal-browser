Rails.application.routes.draw do
  get    'http' =>      'test#get_delete'
  post   'http' =>      'test#post_put'
  put    'http' =>      'test#post_put'
  delete 'http' =>      'test#get_delete'
  post   'http-file' => 'test#post_file'
end
