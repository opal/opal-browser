require 'browser/css/style_sheet'
require 'browser/css/declaration'
require 'browser/css/rule'

module Browser

module CSS
  def self.create(text = nil, &block)
    style = $document.create_element(:style)
    style[:type] = 'text/css'
    style.append_to($document.head)

    if text
      style.inner_text = text
    end

    if block
      sheet = $document.style_sheets.last

      if block.arity == 0
        sheet.instance_eval(&block)
      else
        block.call(sheet)
      end
    end

    style
  end
end

end
