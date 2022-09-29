# frozen_string_literal: true

require 'i18n'

require_relative 'deco_lite/configure'
require_relative 'deco_lite/field_assignable'
require_relative 'deco_lite/field_conflictable'
require_relative 'deco_lite/field_creatable'
require_relative 'deco_lite/field_name_namespaceable'
require_relative 'deco_lite/field_names_persistable'
require_relative 'deco_lite/field_retrievable'
require_relative 'deco_lite/fields_optionable'
require_relative 'deco_lite/hash_loadable'
require_relative 'deco_lite/hashable'
require_relative 'deco_lite/model'
require_relative 'deco_lite/model_nameable'
require_relative 'deco_lite/namespace_optionable'
require_relative 'deco_lite/optionable'
require_relative 'deco_lite/options'
require_relative 'deco_lite/options_defaultable'
require_relative 'deco_lite/options_validatable'
require_relative 'deco_lite/version'

DecoLite.configure do |config| end
