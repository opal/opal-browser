require 'spec_helper'

describe Browser::DOM::MutationObserver do
  html <<-HTML
    <div id="mutate">
      <span></span>
    </div>
  HTML

  it 'notifies additions' do
    promise = Promise.new
    obs = Browser::DOM::MutationObserver.new {|mutations|
      expect(mutations.first.added.first.name).to eq('DIV')
      promise.resolve

      obs.disconnect
    }

    obs.observe $document[:mutate]

    $document[:mutate].add_child $document.create_element('div')

    promise
  end

  it 'notifies removals' do
    promise = Promise.new
    obs = Browser::DOM::MutationObserver.new {|mutations|
      expect(mutations.first.removed.first.name).to eq('SPAN')
      promise.resolve

      obs.disconnect
    }

    obs.observe $document[:mutate]

    $document[:mutate].first_element_child.remove

    promise
  end
end if Browser::DOM::MutationObserver.supported?
