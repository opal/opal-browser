require "opal"
require "console"
require "promise"
require "browser/setup/full"

# Let's test some element before we have been initialized.
# This is so we can test the upgrading behavior.
$document.body << $document.create_element("app-mycounter")

d = DOM("<div>")
$document.body << d
d.inner_html = "<app-mycounter>"

class MyCounter < Browser::DOM::Element::Custom
  # Custom Element interface:

  self.observed_attributes = %w[value]

  def initialize(node)
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

  # This should come after the methods have been defined.
  def_custom "app-mycounter"
end

$document.body << DOM("<app-mycounter></app-mycounter>")
$document.body << $document.create_element("app-mycounter")
$document.body << MyCounter.new
$document.body << DOM { e('app-mycounter') }

all = DOM("<h1>Increase all!</h1>")
all.on(:click) do
  $document.css("app-mycounter").each do |c|
    c.increase!
  end
end
$document.body << all