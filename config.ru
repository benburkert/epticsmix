$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'epticsmix'

run EpticsMix::App.new
