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
        value.map {|horizontal, value|
          value.map {|vertical, value|
            [["-moz-border-radius-#{horizontal}#{vertical}", value],
             ["-webkit-border-#{horizontal}-#{vertical}-radius", value],
             ["border-#{horizontal}-#{vertical}-radius", value]]
          }.flatten(1)
        }.flatten(1)
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
      if Array === value
        value = value.join ', '
      end

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
