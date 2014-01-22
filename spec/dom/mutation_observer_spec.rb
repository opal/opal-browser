require 'spec_helper'

describe Browser::DOM::MutationObserver do
  html <<-HTML
    <div id="mutate">
      <span></span>
    </div>
  HTML

  async 'notifies additions' do
    obs = Browser::DOM::MutationObserver.new {|mutations|
      async {
        expect(mutations.first.added.first.name).to eq('DIV')
      }

      obs.disconnect
    }

    obs.observe $document[:mutate]

    $document[:mutate].add_child $document.create_element('div')
  end

  async 'notifies removals' do
    obs = Browser::DOM::MutationObserver.new {|mutations|
      async {
        expect(mutations.first.removed.first.name).to eq('SPAN')
      }

      obs.disconnect
    }

    obs.observe $document[:mutate]

    $document[:mutate].first_element_child.remove
  end
end if Browser::DOM::MutationObserver.supported?
