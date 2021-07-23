module Browser; module DOM

class Element < Node
  # @!attribute editable
  # @return [Boolean?] the value of contentEditable for this element
  def editable
    case `#@native.contentEditable`
    when "true"
      true
    when "false"
      false
    when "inherit"
      nil
    end
  end

  def editable=(value)
    value = case value
    when true
      "true"
    when false
      "false"
    when nil
      "inherit"
    end
    `#@native.contentEditable = #{value}`
  end

  def editable?
    `#@native.isContentEditable`
  end

  # Execute a contentEditable command
  def edit(command, value=nil)
    command = command.gsub(/_./) { |i| i[1].upcase }
    
    focus

    if value
      `#{document}.native.execCommand(#{command}, false, #{value})`
    else
      `#{document}.native.execCommand(#{command}, false)`
    end
  end
end

end; end
