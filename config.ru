$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'epticsmix'

EpticsMix.setup!

run EpticsMix::App.new
