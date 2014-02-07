require 'locca/project'
require 'minitest/autorun'

class ProjectTest < MiniTest::Test

def setup
    @config = MiniTest::Mock.new()
end

def test_project
    project = Locca::Project.new('/test/dir', @config)
    assert(project)
    assert_equal(project.dir, '/test/dir')
end

end