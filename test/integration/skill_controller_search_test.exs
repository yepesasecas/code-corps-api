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
   results = ElasticSearchHelper.search(@test_url, @test_index, "title", "ru")
   assert results == ["Ruby"]
  end

  test "fuzzy search partial word" do
    results = ElasticSearchHelper.search(@test_url, @test_index, "title", "rj")
    assert results -- ["Ruby", "Rails"] == []
  end

  test "search whole word" do
    results = ElasticSearchHelper.search(@test_url, @test_index, "title", "css")
    assert results == ["CSS"]
  end

  test "fuzzy search whole word" do
    results = ElasticSearchHelper.search(@test_url, @test_index, "title", "csw")
    assert results == ["CSS"]
  end

  test "search no matches" do
    results = ElasticSearchHelper.search(@test_url, @test_index, "title", "foo")
    assert results == []
  end

  test "match all entries" do
    results = ElasticSearchHelper.match_all(@test_url, @test_index, "title")
    assert results -- ["Elixir", "Ruby", "Rails", "CSS"] == []
  end

  def init do
    ElasticSearchHelper.add_documents(@test_url, @test_index, @type_value, ["Elixir", "Ruby", "Rails", "CSS"], [refresh: true])
  end
end
