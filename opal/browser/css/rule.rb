module Browser; module CSS

class Rule
  include Native

  STYLE_RULE               = 1
  CHARSET_RULE             = 2
  IMPORT_RULE              = 3
  MEDIA_RULE               = 4
  FONT_FACE_RULE           = 5
  PAGE_RULE                = 6
  KEYFRAMES_RULE           = 7
  KEYFRAME_RULE            = 8
  NAMESPACE_RULE           = 10
  COUNTER_STYLE_RULE       = 11
  SUPPORTS_RULE            = 12
  DOCUMENT_RULE            = 13
  FONT_FEATURE_VALUES_RULE = 14
  VIEWPORT_RULE            = 15
  REGION_STYLE_RULE        = 16

  def self.new(rule)
    if self == Rule
      @classes ||= [nil, Style]

      if klass = @classes[`rule.type`]
        klass.new(rule)
      else
        raise ArgumentError, 'cannot instantiate a non derived Rule object'
      end
    else
      super(rule)
    end
  end

  alias_native :text, :cssText
  alias_native :to_s, :cssText

  def parent
    Rule.new(`#@native.parentRule`) if `#@native.parentRule != null`
  end

  def style_sheet
    StyleSheet.new(`#@native.parentStyleSheet`) if `#@native.parentStyleSheet != null`
  end
end

end; end
