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
        MESSAGE = "Use `%s '%s'` instead of `%s %s => '%s'`"

        CASK_METHOD_NAMES = [:cask, :test_cask]

        def on_block(node)
          method, _args, _body = node.children
          _receiver, method_name, object = method.children
          return unless CASK_METHOD_NAMES.include?(method_name)
          return unless object.type == :hash
          check(method_name, object)
        end

        private

        def check(method_name, object)
          left, right = *object.children.first
          dsl_version_sym = left.children.first
          cask_token = right.children.first
          message = format(MESSAGE, method_name, cask_token, method_name,
                           dsl_version_sym.inspect, cask_token)
          add_offense(object, :expression, message)
        end
      end
    end
  end
end
