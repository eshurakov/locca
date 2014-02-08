require 'locca/project_factory'
require 'minitest/autorun'

class ProjectFactoryTest < MiniTest::Test

def setup
    @project_dir_locator = MiniTest::Mock.new()
    @config_reader = MiniTest::Mock.new()
    @config = MiniTest::Mock.new()
    @config.expect(:code_dir, 'Classes')
    @config.expect(:lang_dir, 'Localization')
    @config.expect(:base_lang, 'en')

    @factory = Locca::ProjectFactory.new(@project_dir_locator, @config_reader)
end

def test_project_is_created_and_configured
    dir = '/test/existing_dir'
    config_path = File.join(dir, '.locca/config')

    @project_dir_locator.expect(:locate, dir, [dir])
    @project_dir_locator.expect(:config_path, config_path, [dir])
    @config_reader.expect(:read, @config, [config_path])

    project = @factory.new_project(dir)
    assert(project, 'project is nil')
    assert_equal(dir, project.dir)
    assert_equal(File.join(dir, 'Classes'), project.code_dir)
    assert_equal(File.join(dir, 'Localization'), project.lang_dir)
    assert_equal('en', project.base_lang)

    @project_dir_locator.verify
    @config_reader.verify
end

def test_no_project_for_bad_dir
    dir = '/test/dir'
    @project_dir_locator.expect(:locate, nil, [dir])

    project = @factory.new_project(dir)
    assert(project == nil, 'returned project should be nil')
end

end