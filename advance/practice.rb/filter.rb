class FeatureFlags
end

class FeatureFlags::Base
  def self.context
    @context ||= Hash.new { |h,k| h[k] = []}
  end

  def self.features
    @features ||= {}
  end

  def self.feature(name, default: false, context: nil)
    raise ArgumentError, "feature name can not start with 'context_'" if name.start_with?('context_')

    @features ||= {}
    @context ||= Hash.new { |h,k| h[k] = []}
    @features[name] = {value: default, context: context}
    @context[context] << name if context
  end

  def method_missing(name, *args, &blk)
    context = self.class.context
    features = self.class.features

    if name.start_with?("enable_context_")
      base = name.match(/^enable_context_(\w+)!$/)[1].to_sym
      context[base].each do |attr|
        features[attr][:value] = true
      end
    elsif name.start_with?("disable_context_")
      base = name.match(/^disable_context_(\w+)!$/)[1].to_sym
      context[base].each do |attr|
        features[attr][:value] = false
      end
    elsif name.start_with?("enable_")
      base = name.match(/^enable_(\w+)!$/)[1].to_sym
      features[base][:value] = true
    elsif name.start_with?("disable_")
      base = name.match(/^disable_(\w+)!$/)[1].to_sym
      features[base][:value] = false
    elsif name.end_with?('?')
      base = name.to_s[0..-2].to_sym
      features[base][:value]
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    true
  end

end

class AppConfig < FeatureFlags::Base
  feature :dark_mode, default: true
  feature :new_cart,  default: false

  feature :checkout_redesigned, context: :redesigned
  feature :cart_redesigned, context: :redesigned
end

cfg = AppConfig.new
p cfg.dark_mode?        #=> true
cfg.disable_dark_mode!
p cfg.dark_mode?        #=> false
cfg.enable_dark_mode!
p cfg.dark_mode?        #=> true
p cfg.checkout_redesigned?  #=> false
cfg.enable_context_redesigned!
p cfg.checkout_redesigned?  #=> true
