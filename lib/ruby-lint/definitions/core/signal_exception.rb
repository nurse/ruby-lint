##
# Constant: SignalException
# Created:  2013-04-01 18:33:55 +0200
# Platform: rbx 2.0.0.rc1
#
RubyLint::VirtualMachine.global_scope.define_constant('SignalException') do |klass|
  klass.inherits(RubyLint::VirtualMachine.constant_proxy('Exception'))

  klass.define_method('__class_init__')

  klass.define_instance_method('initialize') do |method|
    method.define_optional_argument('signo')
    method.define_optional_argument('signm')
  end

  klass.define_instance_method('signm')

  klass.define_instance_method('signo')
end