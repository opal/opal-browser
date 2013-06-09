module Browser
  def self.engine
    `/MSIE|WebKit|Presto|Gecko/.exec(navigator.userAgent)[0]`.downcase
  rescue
    :unknown
  end
end

require 'browser/utils'
require 'browser/window'
