defmodule SkillControllerSearchIntegrationTest do
  use ExUnit.Case, async: true
  alias CodeCorps.ElasticSearchHelper

  @test_url Application.get_env(:code_corps, :elasticsearch_url)
  @test_index  "skills"
  @type_value "title"

  setup do
    ElasticSearchHelper.delete(@test_url, @test_index)
    ElasticSearchHelper.create_index(@test_url, @test_index, @type_value)
    init()
    :ok
  end

  test "search partial word" do
   results = ElasticSearchHelper.search(@test_url, @test_index, "ru")
   assert results == ["Ruby"]
  end

  test "search whole word" do
    results = ElasticSearchHelper.search(@test_url, @test_index, "css")
    assert results == ["CSS"]
  end

  test "search no matches" do
    results = ElasticSearchHelper.search(@test_url, @test_index, "foo")
    assert results == []
  end

  def init do
    ElasticSearchHelper.add_document(@test_url, @test_index, @type_value, %{title: "Elixir"}, [refresh: true])
    ElasticSearchHelper.add_document(@test_url, @test_index, @type_value, %{title: "Ruby"}, [refresh: true])
    ElasticSearchHelper.add_document(@test_url, @test_index, @type_value, %{title: "Rails"}, [refresh: true])
    ElasticSearchHelper.add_document(@test_url, @test_index, @type_value, %{title: "CSS"}, [refresh: true])
  end
end
