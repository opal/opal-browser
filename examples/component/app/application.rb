require "opal"
require "console"
require "browser"
require "browser/dom/mutation_observer"
require "browser/dom/element/custom"

class MyCounter < Browser::DOM::Element::Custom
  # Custom Element interface:

  self.observed_attributes = %w[value]
  def_custom "app-mycounter"

  def initialize
    super
  end

  def attached
    self[:value] ||= "0"
    on :click do
      increase!
    end
    render  
  end

  def detached
    off :click
  end

  def attribute_changed(attr, from, to)
    render
  end

  # Our interface:

  def increase!
    self[:value] = (self[:value].to_i + 1)
  end

  # Private:

  def render
    self.inner_html = "<h1>[#{self[:value]}]</h1>"
  end
end

$document.body << DOM("<app-mycounter></app-mycounter>")
$document.body << $document.create_element("app-mycounter")
$document.body << MyCounter.new

all = DOM("<h1>Increase all!</h1>")
all.on(:click) do
  $document.css("app-mycounter").each do |c|
    c.increase!
  end
end
$document.body << all