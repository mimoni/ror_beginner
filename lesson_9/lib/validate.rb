# frozen_string_literal: true

module Validate
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    attr_reader :val_hash

    protected

    def validate(attr_name, type, param = nil)
      @val_hash ||= {}
      @val_hash[attr_name] ||= []
      @val_hash[attr_name] << { type: type, param: param }
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    private

    def validate!
      # val_hash  {:name=> [{:type=>:presence, :param=>nil}, {:type=>:type, :param=>String}]}
      self.class.val_hash.each do |attr_name, params|
        instance_val = instance_variable_get("@#{attr_name}")
        params.each do |hash|
          send(hash[:type], value: instance_val, param: hash[:param], attr: attr_name)
        end
      end
    end

    def presence(options)
      attr_name, value = extract_options(options, :attr, :value)

      raise ValidationError, "Параметр #{attr_name} не может быть nil" if value.nil?
      raise ValidationError, "Параметр #{attr_name} не может быть пустым" if value == ''
    end

    def type(options)
      attr_name, value, param = extract_options(options, :attr, :value, :param)
      message_error = "Параметр #{attr_name} должен быть типа #{param}"

      raise ValidationError, message_error unless value.instance_of? param
    end

    def format(options)
      attr_name, value, param = extract_options(options, :attr, :value, :param)
      message_error = "Параметр #{attr_name} не соответствует рег. выражению #{param}"

      raise ValidationError, message_error unless value =~ param
    end

    def custom(options)
      options[:param].call(options[:value])
    end

    def extract_options(options, *keys)
      keys.map { |key| options[key] }
    end
  end
end
