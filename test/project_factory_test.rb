require 'locca/project_factory'
require 'minitest/autorun'

class ProjectFactoryTest < MiniTest::Test

def setup
	@project_dir_locator = MiniTest::Mock.new()
	@config_reader = MiniTest::Mock.new()
    @config = MiniTest::Mock.new()

	@factory = Locca::ProjectFactory.new(@project_dir_locator, @config_reader)
end

def test_new_project
	dir = '/test/existing_dir'
	config_path = '/test/existing_dir/.locca/config'

	@project_dir_locator.expect(:locate, dir, [dir])
	@project_dir_locator.expect(:config_path, config_path, [dir])
	@config_reader.expect(:read, @config, [config_path])

	project = @factory.new_project(dir)
	assert(project, 'project is nil')
	assert_equal(dir, project.dir)
	assert_equal(@config.object_id, project.config.object_id)

end

def test_new_project_bad_dir
	dir = '/test/dir'
	@project_dir_locator.expect(:locate, nil, [dir])

	project = @factory.new_project(dir)
	assert(project == nil, 'returned project should be nil')
end

end