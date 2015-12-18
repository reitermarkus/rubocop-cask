module RuboCop
  module Cop
    module Cask
      # Do not use the deprecated DSL version syntax in your cask header.
      #
      # @example
      #   # bad
      #   cask :v1 => 'foo' do
      #     ...
      #   end
      #
      #   # good
      #   cask 'foo' do
      #     ...
      #   end
      class NoDslVersion < Cop
        MESSAGE = 'Use `%s` instead of `%s`'

        CASK_METHOD_NAMES = [:cask, :test_cask]

        def on_block(node)
          method, _args, _body = node.children
          _receiver, method_name, object = method.children
          return unless CASK_METHOD_NAMES.include?(method_name)
          check(method_name, object)
        end

        private

        def check(method_name, object)
          return unless object.type == :hash
          message = build_message(method_name, object)
          add_offense(object, :expression, message)
        end

        def build_message(method_name, object)
          left, right = *object.children.first
          cask_token = right.children.first
          dsl_version_str = left.children.first.to_s
          new_method_name =
            dsl_version_str.include?('test') ? :test_cask : method_name
          preferred_header = "#{new_method_name} '#{cask_token}'"
          actual_header = "#{method_name} #{object.loc.expression.source}"
          format(MESSAGE, preferred_header, actual_header)
        end
      end
    end
  end
end
