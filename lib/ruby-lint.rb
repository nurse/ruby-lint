require 'parser'
require 'parser/current'
require 'yaml'

require_relative 'ruby-lint/extensions/string'

require_relative 'ruby-lint/variable_predicates'
require_relative 'ruby-lint/ast/node'
require_relative 'ruby-lint/ast/builder'
require_relative 'ruby-lint/parser'
require_relative 'ruby-lint/nested_stack'

require_relative 'ruby-lint/helper/constant_paths'

require_relative 'ruby-lint/definition_builder/base'
require_relative 'ruby-lint/definition_builder/ruby_module'
require_relative 'ruby-lint/definition_builder/ruby_class'
require_relative 'ruby-lint/definition_builder/ruby_method'
require_relative 'ruby-lint/definition_builder/ruby_array'
require_relative 'ruby-lint/definition_builder/ruby_hash'
require_relative 'ruby-lint/definition_builder/ruby_block'
require_relative 'ruby-lint/definition_builder/primitive'

require_relative 'ruby-lint/iterator'
require_relative 'ruby-lint/virtual_machine'
require_relative 'ruby-lint/constant_loader'

require_relative 'ruby-lint/definition/ruby_object'
require_relative 'ruby-lint/definition/ruby_method'
require_relative 'ruby-lint/definition/constant_proxy'
require_relative 'ruby-lint/definitions/core'

require_relative 'ruby-lint/analysis/base'
require_relative 'ruby-lint/analysis/unused_variables'
require_relative 'ruby-lint/analysis/shadowing_variables'
require_relative 'ruby-lint/analysis/undefined_variables'
require_relative 'ruby-lint/analysis/undefined_methods'
require_relative 'ruby-lint/analysis/argument_amount'
require_relative 'ruby-lint/analysis/confusing_variables'
require_relative 'ruby-lint/analysis/pedantics'

require_relative 'ruby-lint/report'
require_relative 'ruby-lint/report/entry'

require_relative 'ruby-lint/presenter/text'
require_relative 'ruby-lint/presenter/json'

require_relative 'ruby-lint/configuration'
require_relative 'ruby-lint/default_names'
require_relative 'ruby-lint/runner'
require_relative 'ruby-lint/version'
