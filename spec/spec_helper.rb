# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  minimum_coverage 91
  add_filter '/vendor/'
  add_filter '/spec/'
  add_filter '/diagnostics/'
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'icontrol_rest'
