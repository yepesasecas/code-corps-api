defmodule SkillControllerSearchIntegrationTest do
  use ExUnit.Case, async: true
  alias CodeCorps.ElasticSearchHelper
  alias Elastix.Document

  @test_url Application.get_env(:code_corps, :elasticsearch_url)
  @test_index  Application.get_env(:code_corps, :elasticsearch_index)
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
    data = %{
      title: "Elixir"
    }
    Document.index @test_url, @test_index, @type_value, 1, data, [refresh: true]
    data = %{
      title: "Ruby"
    }
    Document.index @test_url, @test_index, @type_value, 2, data, [refresh: true]
    data = %{
      title: "Rails"
    }
    Document.index @test_url, @test_index, @type_value, 3, data, [refresh: true]
    data = %{
      title: "CSS"
    }
    Document.index @test_url, @test_index, @type_value, 4, data, [refresh: true]
  end
end
