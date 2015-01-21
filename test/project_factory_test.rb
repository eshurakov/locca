require 'locca/projects/project_factory'
require 'minitest/autorun'

class ProjectFactoryTest < MiniTest::Test

def setup
    @dir = '/test/dir'
    @config_path = File.join(@dir, '.locca/config')

    @project_dir_locator = MiniTest::Mock.new()
    @project_dir_locator.expect(:config_path, @config_path, [@dir])

    @config_reader = MiniTest::Mock.new()
    
    @factory = Locca::ProjectFactory.new(@project_dir_locator, @config_reader)
end

def test_project_is_created_and_configured
    @project_dir_locator.expect(:locate, @dir, [@dir])
    
    config = {
        'code_dir' => "Classes", 
        'lang_dir' => 'Localization',
        'base_lang' => 'en'
    }
    @config_reader.expect(:read, config, [@config_path])

    project = @factory.new_project(@dir)
    assert(project, 'project is nil')
    assert_equal(@dir, project.dir)
    assert_equal(File.join(@dir, 'Classes'), project.code_dir)
    assert_equal(File.join(@dir, 'Localization'), project.lang_dir)
    assert_equal('en', project.base_lang)

    @project_dir_locator.verify
    @config_reader.verify
end

def test_raises_bad_dir
    @project_dir_locator.expect(:locate, nil, [@dir])

    assert_raises(Locca::ProjectNotFoundError) {
        project = @factory.new_project(@dir)
    }
end

def test_raises_no_config
    @project_dir_locator.expect(:locate, @dir, [@dir])
    @config_reader.expect(:read, nil, [@config_path])

    assert_raises(Locca::ConfigNotFoundError) {
        project = @factory.new_project(@dir)
    }
end

# def test_raises_bad_config
#     config = {}

#     @project_dir_locator.expect(:locate, @dir, [@dir])
#     @config_reader.expect(:read, config, [@config_path])
#     @config_validator.expect(:validate, false, [config])

#     assert_raises(Locca::ConfigNotValidError) {
#         project = @factory.new_project(@dir)
#     }
# end

end