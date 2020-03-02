require 'simplecov'
SimpleCov.start do
  add_filter %r{^/test/}
end

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "method_installable"

require "minitest/autorun"
