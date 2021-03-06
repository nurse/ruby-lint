require File.expand_path('../../../../helper', __FILE__)

describe RubyLint::VirtualMachine do
  describe 'scoping method definitions' do
    should 'process a global method' do
      defs    = build_definitions('def example; end')
      example = defs.lookup(:instance_method, 'example')

      example.is_a?(ruby_method).should == true

      example.type.should == :instance_method
      example.name.should == 'example'
    end

    should 'process a nested method' do
      code = <<-CODE
def first
  def second
  end
end
      CODE

      defs  = build_definitions(code)
      first = defs.lookup(:instance_method, 'first')

      first.is_a?(ruby_method).should == true

      first.lookup(:instance_method, 'second') \
        .is_a?(ruby_method) \
        .should == true

      defs.lookup(:instance_method, 'second').nil?.should == true
    end

    should 'process a global and nested method' do
      code = <<-CODE
def first
  def second
  end
end

def third
end
      CODE

      defs  = build_definitions(code)
      first = defs.lookup(:instance_method, 'first')

      first.lookup(:instance_method, 'second') \
        .is_a?(ruby_method) \
        .should == true

      first.lookup(:instance_method, 'second') \
        .lookup(:instance_method, 'third') \
        .is_a?(ruby_method) \
        .should == true

      defs.lookup(:instance_method, 'third') \
        .is_a?(ruby_method) \
        .should == true
    end
  end
end
