# frozen_string_literal: true

begin
  /(?<ruby_version>\d+\.\d+)/ =~ RUBY_VERSION
  require_relative "redwood/#{ruby_version}/redwood"
rescue LoadError
  begin
    require_relative "redwood/redwood"
  rescue LoadError
    require_relative "redwood.so"
  end
end
