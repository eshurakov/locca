require 'locca'
require 'minitest/autorun'

class LoccaTest < MiniTest::Test

    def test_init
        project_factory = MiniTest::Mock.new()
        project_factory.expect(:newProject, nil, ['test/dir'])
        locca = Locca::Locca.new(project_factory, 'test/dir')
        project_factory.verify()
    end

end