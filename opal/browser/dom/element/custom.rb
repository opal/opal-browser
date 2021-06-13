# use_strict: true
# helpers: truthy

module Browser; module DOM; class Element < Node

# CustomElements implementation for opal-browser. See examples/custom_elements/.
#
# @see https://developer.mozilla.org/en-US/docs/Web/Web_Components/Using_custom_elements
# @abstract This class should not be used directly. Please extend it and implement needed methods.
class Custom < Element
  # The reason why we wrap class definition with an eval is kind of selfish. I want it to work
  # with opal-optimizer which doesn't support the new class syntax. I would do it with prototypes,
  # but the prototypes system is so messy I gave up.
  #
  # Therefore, for it to be cleaned up, one of those two must happen:
  # - we raise the supported ES version in Opal and we implement those ES syntax features in
  #   rkelly-turbo. And then we remove the polyfill.
  # - we reimplement it in terms of prototypes.
  %x{
    var make_custom_class = Function('self,base_class',
      '"use strict"; \
      var klass = class extends base_class { \
        constructor() { \
          super(); \
          self.$_dispatch_constructor(this); \
        } \
        connectedCallback() { \
          return this.$$opal_native_cached.$attached(); \
        } \
        disconnectedCallback() { \
          return this.$$opal_native_cached.$detached(); \
        } \
        adoptedCallback() { \
          return this.$$opal_native_cached.$adopted(); \
        } \
        attributeChangedCallback(attr, from, to) { \
          if (from === null) from = Opal.nil; \
          if (to === null) to = Opal.nil; \
          return this.$$opal_native_cached.$attribute_changed(attr, from, to); \
        } \
        \
        static get observedAttributes() { \
          return self.$observed_attributes(); \
        } \
      }; \
      klass.$$opal_class = self; \
      return klass;'
    );
  } if Browser.supports? 'Custom Elements' #'

  module ClassMethods
    if Browser.supports? 'Custom Elements'
      # Defines a new custom element
      #
      # @opalopt uses:_dispatch_constructor,attached,detached,adopted,attribute_changed,observed_attributes
      def def_custom(tag_name, base_class: nil, extends: nil)
        $console.log(tag_name, base_class)
        if `base_class !== nil`
        elsif self.superclass == Custom
          base_class = `HTMLElement`
        elsif self.ancestors.include? Custom
          base_class = `#{self.superclass}.custom_class`
        else
          raise ArgumentError, "You must define base_class"
        end

        @custom_class = `make_custom_class(self, #{base_class})`
        @observed_attributes ||= []

        def_selector tag_name

        %x{
          if ($truthy(#{extends})) customElements.define(#{tag_name}, #{@custom_class}, {extends: #{extends}});
          else customElements.define(#{tag_name}, #{@custom_class});
        }
      end

      private def _dispatch_constructor(obj)
        new(obj) if Element.native_is?(obj, self)
      end
    elsif Browser.supports? 'MutationObserver'
      # Can we polyfill it?
      def def_custom(tag_name, base_class: nil, extends: nil)
        def_selector tag_name

        $document.body.css(tag_name).each(&:attached)
      end

      MutationObserver.new do |obs|
        obs.each do |e|
          target = e.target

          case e.type
          when :attribute
            if Custom::Mixin === target && target.class.observed_attributes.include?(e.name)
              target.attribute_changed(e.name, e.old, target[e.name])
            end
          when :tree
            e.added.each { |n| n.attached if Custom::Mixin === n }
            e.removed.each { |n| n.detached if Custom::Mixin === n }
          end
        end
      end.observe($document.body, tree: true, children: true, attributes: :old)
    else
      # Well, we can't. Let's do what we can.
      def def_custom(tag_name, base_class: nil, extends: nil)
        def_selector tag_name

        $document.body.css(tag_name).each(&:attached)
      end
    end

    # This must be defined before def_custom is called!
    attr_accessor :observed_attributes

    attr_reader :custom_class
  end

  module Mixin
    def self.included(klass)
      klass.extend ClassMethods
    end

    def attached
    end

    def detached
    end

    def adopted
    end

    # Note: for this method to fire, you will need to 
    def attribute_changed(attr, from, to)
    end

    # Return true if the node is a custom element.
    def custom?
      true
    end
  end

  include Mixin
end

end; end; end