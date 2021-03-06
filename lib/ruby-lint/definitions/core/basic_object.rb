##
# Constant: BasicObject
# Created:  2013-03-26 21:43:55 +0100
# Platform: rubinius 2.0.0.rc1 (1.9.3 cbee9a2d yyyy-mm-dd JI) [x86_64-unknown-linux-gnu]
#
RubyLint::VirtualMachine.global_scope.define_constant('BasicObject') do |klass|
  klass.inherits(
    RubyLint::VirtualMachine.constant_proxy('Class'),
    RubyLint::VirtualMachine.constant_proxy('Kernel')
  )

  klass.define_method('__class_init__')

  klass.define_instance_method('!')

  klass.define_instance_method('!=') do |method|
    method.define_argument('other')
  end

  klass.define_instance_method('==') do |method|
    method.define_argument('other')
  end

  klass.define_instance_method('__id__')

  klass.define_instance_method('__send__') do |method|
    method.define_argument('message')
    method.define_rest_argument('args')
  end

  klass.define_instance_method('equal?') do |method|
    method.define_argument('other')
  end

  klass.define_instance_method('instance_eval') do |method|
    method.define_optional_argument('string')
    method.define_optional_argument('filename')
    method.define_optional_argument('line')
    method.define_block_argument('prc')
  end

  klass.define_instance_method('instance_exec') do |method|
    method.define_rest_argument('args')
    method.define_block_argument('prc')
  end
end
