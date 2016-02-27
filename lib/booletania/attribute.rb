module Booletania
  class Attribute
    class << self
      def define_methods!(klass, boolean_columns)
        boolean_columns.each do |boolean_column|
          define_attribute_text(klass, boolean_column)
        end
      end

      private

      def define_attribute_text(klass, boolean_column)
        klass.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{boolean_column.name}_text
            # http://yaml.org/type/bool.html
            I18n.t "booletania.#{klass.name.underscore}.#{boolean_column.name}." + #{boolean_column.name}.__send__(:to_s), default: #{boolean_column.name}.__send__(:to_s)
          end
        RUBY
      end
    end
  end
end
