require File.expand_path('../../helper', __FILE__)

describe 'Rlint::Iterator' do
  it 'Iterate over a simple AST' do
    code = <<-CODE
number = 10
number
    CODE

    tokens   = Rlint::Parser.new(code).parse
    iterator = Rlint::Iterator.new

    callback = Class.new do
      attr_reader :assigned
      attr_reader :referenced
      attr_reader :file

      def on_assignment(token, file)
        @file     = file
        @assigned = true
      end

      def on_local_variable(token, file)
        @referenced = true
      end
    end

    iterator.bind(callback)

    iterator.iterate(tokens)

    iterator.callbacks[0].assigned.should   == true
    iterator.callbacks[0].referenced.should == true
    iterator.callbacks[0].file.should       == '(rlint)'
  end

  it 'Iterate over a multi dimensional AST' do
    code = <<-CODE
class Foo
  def initialize
    @number = 10
  end
end
    CODE

    tokens   = Rlint::Parser.new(code).parse
    iterator = Rlint::Iterator.new
    callback = Class.new do
      attr_reader :class_name
      attr_reader :method_name
      attr_reader :assigned

      def on_class(token, file)
        @file       = file
        @class_name = token.name[0]
      end

      def on_method_definition(token, file)
        @method_name = token.name
      end

      def on_assignment(token, file)
        @assigned = true
      end
    end

    iterator.bind(callback)

    iterator.iterate(tokens)

    iterator.callbacks[0].class_name.should  == 'Foo'
    iterator.callbacks[0].method_name.should == 'initialize'
    iterator.callbacks[0].assigned.should    == true
  end
end