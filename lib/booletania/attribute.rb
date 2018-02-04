module Booletania
  class Attribute
    class << self
      def define_methods!(klass, boolean_columns)
        boolean_columns.each do |boolean_column|
          method_obj = Booletania::Method.new(klass, boolean_column)

          define_attribute_text(method_obj)

          define_attribute_options(method_obj)
        end
      end

      private

      def define_attribute_text(method_obj)
        method_obj.klass.class_eval method_obj._text, __FILE__, __LINE__ + 1
      end

      def define_attribute_options(method_obj)
        method_obj.klass.instance_eval method_obj._options, __FILE__, __LINE__ + 1
      end
    end
  end
end
