require 'locca/actions/build_action'
require 'locca/collection_merger'
require 'minitest/autorun'
require 'mocha/mini_test'


class BuildActionTest < MiniTest::Test

def setup
    @project = mock('project')
    @collection_builder = mock('collection_builder')
    @collections_generator = mock('collections_generator')
    @collection_merger = mock('collection_merger')

    @action = Locca::BuildAction.new(@project, @collection_builder, @collections_generator, @collection_merger)
end

# Generate language files from the code: Localizable.strings, Other.strings
# Get available languages from the project
# Iterate through (generated language files / available languages) and merge with project files

def test_action
    collection_name = 'Localizable'

    generated_collection = mock('generated_collection')
    generated_collection.stubs(:name).returns(collection_name)

    code_dir = '/some/dir'
    lang_dir = '/lang/dir'
    langs = ['en', 'ja']

    @project.stubs(:code_dir).returns(code_dir)
    @project.stubs(:lang_dir).returns(lang_dir)
    @project.stubs(:langs).returns(langs)

    generated_collections = [generated_collection]
    @collections_generator.expects(:generate).with(code_dir).returns(generated_collections)

    langs.each do |lang|
        collection_path = "#{lang_dir}/#{lang}.lproj/#{collection_name}.strings"

        collection = mock("collection-#{lang}")
        collection.expects(:write_to).with(collection_path)

        @collection_builder.expects(:collection_at_path).with(collection_path).returns(collection)

        @collection_merger.expects(:merge).with(generated_collection, collection, (Locca::CollectionMerger::ACTION_ADD | Locca::CollectionMerger::ACTION_DELETE))
    end

    @action.execute()
end

end