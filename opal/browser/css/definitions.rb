module Browser; module CSS; class Declaration

define :border do |args|
  return [['border', args]] if String === args

  args.map {|name, value|
    case name
    when :radius
      if String === value
        [['-moz-border-radius', value],
         ['-webkit-border-radius', value],
         ['border-radius', value]]
      else
      end

    else
      [["border-#{name}", value]]
    end
  }.flatten(1)
end

define :box do |args|
  return [['box', args]] if String === args

  args.map {|name, value|
    case name
    when :shadow
      if String === value
        [['-moz-box-shadow', value],
         ['-webkit-box-shadow', value],
         ['box-shadow', value]]
      else
      end

    else
      [["box-#{name}", value]]
    end
  }.flatten(1)
end

end; end; end
