require 'spec_helper'

describe Browser::DOM::MutationObserver do
  html <<-HTML
    <div id="mutate">
      <span></span>
    </div>
  HTML

  async 'notifies additions' do
    obs = Browser::DOM::MutationObserver.new {|mutations|
      run_async {
        mutations.first.added.first.name.should == 'DIV'
      }
    }

    obs.observe $document[:mutate]

    $document[:mutate].add_child $document.create_element('div')
  end

  async 'notifies removals' do
    obs = Browser::DOM::MutationObserver.new {|mutations|
      run_async {
        mutations.first.removed.first.name.should == 'SPAN'
      }
    }

    obs.observe $document[:mutate]

    $document[:mutate].first_element_child.remove
  end
end
