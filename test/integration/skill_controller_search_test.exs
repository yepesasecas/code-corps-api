defmodule SkillControllerSearchIntegrationTest do
  use ExUnit.Case, async: true
  alias CodeCorps.ElasticSearchHelper

  @test_url Application.get_env(:code_corps, :elasticsearch_url)
  @test_index  Application.get_env(:code_corps, :elasticsearch_index)

  setup do
    Elastix.Index.delete(Application.get_env(:code_corps, :elasticsearch_url),
      Application.get_env(:code_corps, :elasticsearch_index))
    :ok
  end

  test "search partial word" do
   results = ElasticSearchHelper.search("ru")
   assert results == ["Ruby"]
  end

  test "search whole word" do
    results = ElasticSearchHelper.search("css")
    assert results == ["CSS"]
  end

  test "search no matches" do
    results = ElasticSearchHelper.search("foo")
    assert results == []
  end

end
