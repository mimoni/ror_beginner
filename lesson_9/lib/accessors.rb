# frozen_string_literal: true

module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}"
      var_name_history = "@#{name}_history"

      define_method(name) { instance_variable_get(var_name) }

      define_method("#{name}=") do |value|
        instance_variable_set(var_name, value)
        instance_variable_set(var_name_history, []) unless instance_variable_get(var_name_history)
        instance_variable_get(var_name_history) << value
      end

      define_method("#{name}_history") { instance_variable_get(var_name_history) }
    end
  end

  def strong_attr_accessor(name, type)
    define_method(name) { instance_variable_get("@#{name}") }

    define_method("#{name}=") do |value|
      val_type = value.class
      raise TypeError, "Тип #{name} должен быть #{type}, вместо #{val_type}" unless val_type == type

      instance_variable_set("@#{name}", value)
    end
  end
end

# class Test
#   extend Accessors
#
#   strong_attr_accessor :int, Integer
#   strong_attr_accessor :str, String
#
#   attr_accessor_with_history :var1, :var2
# end
#
# test = Test.new
#
# 5.times { |i| test.var1 = i }
# p test.var1_history
#
# ('a'..'d').each { |i| test.var2 = i }
# p test.var2_history
#
# test.int = 86
# test.str = 'str'
#
# test.int = 'str'
# test.str = 86
