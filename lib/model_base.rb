class ModelBase
  include ActiveModel::AttributeMethods
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks

  extend  ActiveModel::Naming

  #include BaseMethods
  #include Decrypt

  NOT_MASSASSIGNABLE_ATTRS = [:==, :!, :_validation_callbacks, :_validators,
    :_validate_callbacks, :validation_context]

  def initialize(attrs=nil)
    unless attrs.nil?
      attrs.each do |key, value|
        self.send("#{key}=", try_decrypt(value))
      end
    end
  end

  def persisted?
    !(self.id.nil?)
  end

  class << self
    def instance(object_params)
      self.new(format_object_params(object_params))
    end

    private

    def format_object_params(object_params)
      return {} if object_params.nil?
      not_accessor_keys = object_params.keys.map(&:to_sym) - get_attr_accessors
      object_params.delete_if{ |key, val| not_accessor_keys.include?(key.to_sym) }
    end

    def attr_accessors
      self.instance_methods.find_all do |method|
        !NOT_MASSASSIGNABLE_ATTRS.include?(method) && self.instance_methods.include?(:"#{method}=")
      end
    end
  end
end