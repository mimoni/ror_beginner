# frozen_string_literal: true

module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethod
  end

  module ClassMethods
    attr_reader :instances

    def increment_instance
      @instances ||= 0
      @instances += 1
    end
  end

  module InstanceMethod
    private

    def register_instance
      self.class.increment_instance
    end
  end
end
