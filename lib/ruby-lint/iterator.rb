module RubyLint
  ##
  # The Iterator class provides the means to iterate over an AST generated by
  # {RubyLint::Parser} using callback methods for the various node types
  # generated by this parser.
  #
  # For each node type two events are called: one before and one after
  # processing the node and all of its children. The names of these events are
  # the following:
  #
  # * `on_X`
  # * `after_X`
  #
  # Here "X" is the name of the event. For example, when iterator an integer
  # this would result in the event names `on_integer` and `after_integer`.
  #
  # These event names are used to call the corresponding callback methods if
  # they exist. Each callback method takes a single argument: the node (an
  # instance of {RubyLint::Node}) that belongs to the event.
  #
  # Creating iterator classes is done by extending this particular class and
  # adding the needed methods to it:
  #
  #     class MyIterator < RubyLint::Iterator
  #       def on_integer(node)
  #         puts node.children[0]
  #       end
  #
  #       def after_integer(node)
  #         puts '---'
  #       end
  #     end
  #
  # When used this particular iterator class would display the values of all
  # integers it processes. After processing an integer it will display three
  # dashes.
  #
  # Each instance of a class that subclasses {RubyLint::Iterator} also has
  # access to the instance variable `@options`. This instance variable is used
  # to store certain information, such as the list of definitions for a block
  # of Ruby code. The following two keys are set by default:
  #
  # * `:definitions`: a set of Ruby definitions such as classes and methods.
  # * `:report`: an instance of {RubyLint::Report} that can be used for adding
  #   information about the analyzed code.
  #
  # To make it easier to add data to a report sub classes can use the following
  # three methods:
  #
  # * error
  # * info
  # * warning
  #
  # These methods take away some of the boilerplate that would otherwise be
  # required to check for a report and add data to it if it's set.
  #
  class Iterator
    ##
    # Hash containing the options that were set for the iterator.
    #
    # @return [Hash]
    #
    attr_reader :options

    ##
    # @param [Hash] options Hash containing custom options to set for the
    #  iterator.
    #
    def initialize(options = {})
      @options     = default_options.merge(options)
      @definitions = []
      @call_types  = []
    end

    ##
    # Recursively processes the specified list of nodes.
    #
    # @param [RubyLint::Node] node A node and optionally a set of sub nodes to
    #  iterate over.
    #
    def iterate(node)
      return unless node.is_a?(Node)

      before, after = callback_names(node)

      execute_callback(before, node)

      node.children.each do |child|
        if child.is_a?(Array)
          child.each { |c| iterate(c) }
        else
          iterate(child)
        end
      end

      execute_callback(after, node)
    end

    protected

    ##
    # Adds an error message to the report.
    #
    # @param [String] message The message to add.
    # @param [RubyLint::Node] node The node for which to add the message.
    #
    def error(message, node)
      add_message(:error, message, node)
    end

    ##
    # Adds a warning message to the report.
    #
    # @see RubyLint::Callback#error
    #
    def warning(message, node)
      add_message(:warning, message, node)
    end

    ##
    # Adds a regular informational message to the report.
    #
    # @see RubyLint::Callback#error
    #
    def info(message, node)
      add_message(:info, message, node)
    end

    ##
    # Adds a message of the given level.
    #
    # @param [Symbol] level
    # @param [String] message
    # @param [String] node
    #
    def add_message(level, message, node)
      if has_report?
        @options[:report].add(
          level,
          message,
          node.line,
          node.column,
          node.file
        )
      end
    end

    ##
    # Returns `true` if the current iterator has a report instance set.
    #
    # @return [TrueClass|FalseClass]
    #
    def has_report?
      return @options[:report].is_a?(Report)
    end

    ##
    # Returns a definition list to use for the last segment in the constant
    # path. If one of the segments is invalid `nil` is returned instead.
    #
    # @param [Array] path An array of nodes or definitions that make up the
    #  constant path.
    # @return [RubyLint::Definition::RubyObject|NilClass]
    #
    def resolve_definitions(path)
      current = definitions

      path.each do |segment|
        if segment.is_a?(Definition::RubyObject)
          name = segment.name
        else
          name = segment.children[0]
        end

        found = current.lookup(segment.type, name)
        found ? current = found : return
      end

      return current
    end

    ##
    # Returns the call type to use for method calls.
    #
    # @return [Symbol]
    #
    def call_type
      return @call_types.empty? ? :instance_method : @call_types[-1]
    end

    ##
    # Returns the current definition list to use.
    #
    # @return [RubyLint::Definition::RubyObject]
    #
    def definitions
      return @definitions.empty? ? @options[:definitions] : @definitions[-1]
    end

    protected

    ##
    # Executes the specified callback method if it exists.
    #
    # @param [String|Symbol] name The name of the callback method to execute.
    # @param [Array] args Arguments to pass to the callback method.
    #
    def execute_callback(name, *args)
      send(name, *args) if respond_to?(name)
    end

    ##
    # Returns an array containin the callback names for the specified node.
    #
    # @param [RubyLint::Node] node
    # @return [Array]
    #
    def callback_names(node)
      return [:"on_#{node.type}", :"after_#{node.type}"]
    end

    ##
    # Associates a definitions object with a node of the AST.
    #
    # @param [RubyLint::Node] node
    # @param [RubyLint::Definition::RubyObject] definitions
    #
    def associate_node_definition(node, definitions)
      @options[:node_definitions][node] = definitions
    end

    ##
    # Retrieves the definitions list associated to an AST node.
    #
    # @param [RubyLint::Node] node
    # @return [RubyLint::Definition::RubyObject|NilClass]
    #
    def associated_definition(node)
      return @options[:node_definitions][node]
    end

    ##
    # Returns a Hash containing the default configuration options.
    #
    # @return [Hash]
    #
    def default_options
      return {:node_definitions => {}}
    end
  end # Iterator
end # RubyLint
