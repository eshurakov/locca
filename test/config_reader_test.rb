require 'locca/config'
require 'locca/config_reader'
require 'minitest/autorun'

class ConfigReaderTest < MiniTest::Test

def setup
	@reader = MiniTest::Mock.new()
	@parser = MiniTest::Mock.new()
	@config_reader = Locca::ConfigReader.new(@reader, @parser)
end

# def test_happy
# 	config = @config_reader.read(".locca/config")
# 	assert(config, 'config is nil')
# end

end