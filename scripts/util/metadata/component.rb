#encoding: utf-8

require_relative "config_writers"
require_relative "field"

class Component
  include Comparable

  attr_reader :beta,
    :common,
    :description,
    :env_vars,
    :features,
    :function_category,
    :id,
    :name,
    :operating_systems,
    :options,
    :posts,
    :requirements,
    :service_name,
    :service_providers,
    :title,
    :type,
    :unsupported_operating_systems

  def initialize(hash)
    @beta = hash["beta"] == true
    @common = hash["common"] == true
    @description = hash["description"]
    @env_vars = (hash["env_vars"] || {}).to_struct_with_name(constructor: Field)
    @features = hash["features"] || []
    @function_category = hash.fetch("function_category").downcase
    @name = hash.fetch("name")
    @posts = hash.fetch("posts")
    @requirements = OpenStruct.new(hash["requirements"] || {})
    @service_name = hash["service_name"] || hash.fetch("title")
    @service_providers = hash["service_providers"] || []
    @title = hash.fetch("title")
    @type ||= self.class.name.downcase
    @id = "#{@name}_#{@type}"
    @options = (hash["options"] || {}).to_struct_with_name(constructor: Field)

    # Operating Systems

    if hash["only_operating_systems"]
      @operating_systems = hash["only_operating_systems"]
    elsif hash["except_operating_systems"]
      @operating_systems = OPERATING_SYSTEMS - hash["except_operating_systems"]
    else
      @operating_systems = OPERATING_SYSTEMS
    end

    @unsupported_operating_systems = OPERATING_SYSTEMS - @operating_systems
  end

  def <=>(other)
    name <=> other.name
  end

  def beta?
    beta == true
  end

  def config_example(format)
    id = type == "source" ? "in" : "out"

    writer =
      ConfigWriters::ExampleWriter.new(
        options_list,
        table_path: [type.pluralize, id],
        values: {inputs: ["in"]}
      ) do |option|
        option.required?
      end

    case format
    when :toml
      writer.to_toml
    else
      raise ArgumentError.new("Unknown format: #{format}")
    end
  end

  def common?
    common == true
  end

  def context_options
    options_list.select(&:context?)
  end

  def env_vars_list
    @env_vars_list ||= env_vars.to_h.values.sort
  end

  def event_types
    @event_types ||=
      begin
        types = []

        if respond_to?(:input_types)
          types += input_types
        end

        if respond_to?(:output_types)
          types += output_types
        end

        types.uniq
      end
  end

  def for_platform?
    !requirements.docker_api.nil? || requirements.heroku == true
  end

  def field_path_notation_options
    options_list.select(&:field_path_notation?)
  end

  def function_category?(name)
    function_category == name
  end

  def logo_path
    return @logo_path if defined?(@logo_path)

    variations = Set.new([name, name.sub(/_logging/, "")])

    event_types.each do |event_name|
      variations << name.sub(/_#{event_name.pluralize}$/, "")
    end

    variations.each do |name|
      path = "/img/logos/#{name}.svg"

      if File.exists?("#{STATIC_ROOT}#{path}")
        @logo_path = path
        break
      end
    end

    @logo_path
  end

  def only_service_provider?(provider_name)
    service_providers.length == 1 && service_provider?(provider_name)
  end

  def options_list
    @options_list ||= options.to_h.values.sort
  end

  def option_groups
    @option_groups ||= options_list.collect(&:groups).flatten.uniq.sort
  end

  def option_example_groups
    @option_example_groups ||=
      begin
        groups = {}

        if option_groups.any?
          option_groups.each do |group|
            groups[group] =
              lambda do |option|
                option.group?(group) && option.common?
              end
          end

          option_groups.each do |group|
            if options_list.any? { |option| option.group?(group) && !option.common? }
              groups["#{group} (adv)"] =
                lambda do |option|
                  option.group?(group)
                end
            end
          end
        else
          groups["Common"] =
            lambda do |option|
              option.common?
            end

          if options_list.any? { |option| !option.common? }
            groups["Advanced"] =
              lambda do |option|
                true
              end
          end
        end

        groups
      end
  end

  def partition_options
    options_list.select(&:partition_key?)
  end

  def service_provider?(provider_name)
    service_providers.collect(&:downcase).include?(provider_name.downcase)
  end

  def sink?
    type == "sink"
  end

  def sorted_option_group_keys
    option_example_groups.keys.sort_by do |key|
      if key.downcase.include?("adv")
        -1
      else
        1
      end
    end.reverse
  end

  def source?
    type == "source"
  end

  def specific_options_list
    options_list.select do |option|
      !["type", "inputs"].include?(option.name)
    end
  end

  def status
    beta? ? "beta" : "prod-ready"
  end

  def templateable_options
    options_list.select(&:templateable?)
  end

  def to_h
    {
      beta: beta?,
      config_examples: {
        toml: config_example(:toml)
      },
      delivery_guarantee: (respond_to?(:delivery_guarantee, true) ? delivery_guarantee : nil),
      description: description,
      event_types: event_types,
      features: features,
      function_category: (respond_to?(:function_category, true) ? function_category : nil),
      id: id,
      logo_path: logo_path,
      name: name,
      operating_systems: (transform? ? [] : operating_systems),
      service_providers: service_providers,
      short_description: short_description,
      status: status,
      title: title,
      type: type,
      unsupported_operating_systems: unsupported_operating_systems
    }
  end

  def to_toml_example(common: true)
    example_options = options_list.sort_by(&:config_file_sort_token)
    example_options = common ? example_options.select(&:common?) : example_options

    option_examples =
      included_options.collect do |option|
        option.to_toml_example(common: common)
      end

    <<~EOF
    [#{type.pluralize}.my_#{type}_id]
    #{option_examples.join}
    EOF
  end

  def transform?
    type == "transform"
  end
end
