module AdminConfig
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    puts self.configuration
    yield(self.configuration)
  end

  def self.configuration
    @@configuration ||= Configuration.new
  end

  def self.member_actions(model)
    m = self.configuration.models[model]
    if m
      m.actions.values.select{|a| a.type == :member}
    else
      []
    end
  end

  def self.collection_actions(model)
    m = self.configuration.models[model]
    if m
      m.actions.values.select{|a| a.type == :collection}
    else
      []
    end
  end

  class RedisgerModel
    attr_accessor :name, :actions

    def initialize(name)
      self.name = name
      self.actions = {}
    end

    def add_action(options = {})
      default = {
        method: :get,
        type: :member
      }

      options.reverse_merge!(default)
      action = ModelAction.new(options)

      self.actions[action.name] = action
    end
  end

  class ModelAction
    attr_accessor :method, :type, :name, :text

    def initialize(options = {})
      default = {
        method: :get,
        type: :member,
        name: '',
        text: ''
      }

      options.reverse_merge!(default)

      self.method = options[:method]
      self.type = options[:type]
      self.name = options[:name]
      self.text = options[:text]
    end
  end

  class Configuration
    attr_accessor :models

    def initialize
      @models = {}
    end

    def add(model_name)
      @models[model_name] = RedisgerModel.new(model_name)
      yield(@models[model_name])
    end
  end
end
