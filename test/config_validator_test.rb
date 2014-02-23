require 'locca/config_validator'
require 'minitest/autorun'

class ConfigValidatorTest < MiniTest::Test

def setup
    @validator = Locca::ConfigValidator.new()
end

def test_validation
    hash = {
        'code_dir' => "Classes", 
        'lang_dir' => 'Localization'
    }
    @validator.fields = ['code_dir', 'lang_dir']

    result = @validator.validate(hash)
    assert(result)
end

def test_validation_empty_fields
    hash = {}
    @validator.fields = []

    result = @validator.validate(hash)
    assert(result)
end

def test_validation_err
    hash = {
        'code_dir' => "Classes"
    }
    @validator.fields = ['code_dir', 'lang_dir']

    result = @validator.validate(hash)
    refute(result)
end

end