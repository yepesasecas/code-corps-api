defmodule CodeCorps.ElasticSearchHelper do
  alias Elastix.Search
  alias Elastix.Index
  alias Elastix.Document

  @test_url Application.get_env(:code_corps, :elasticsearch_url)
  @test_index  Application.get_env(:code_corps, :elasticsearch_index)

  def delete(url, index) do
    Index.delete(url, index)
  end

  def create_index(url, index, type) do
    Index.settings(url, index, settings_map)
    Index.settings(url, "#{index}/_mapping/#{type}", field_filter)
  end

  def add_document(url, index, type, data, query) do
    Document.index_new(url, index, type, data, query)
  end

  def search(url, index, search_query) do
    data = %{
      query: %{
        match: %{ title: search_query }
      }
    }

    response = Search.search url, index, [], data

    #response.status_code == 200 do
    #count = response.body["hits"]["total"]

    hits = response.body["hits"]["hits"] || []
    Enum.map(hits, fn(x) -> x["_source"]["title"] end)
  end

  defp settings_map do
  %{
      settings: %{
        number_of_shards: 5,
        analysis: %{
          filter: %{
            autocomplete_filter: %{
              type:     "edge_ngram",
              min_gram: 2,
              max_gram: 20
            }
          },
          analyzer: %{
            autocomplete: %{
              type:      "custom",
              tokenizer: "standard",
              filter: [
                "lowercase",
                "autocomplete_filter"
              ]
            }
          }
        }
      }
    }
  end

  defp field_filter do
    %{
      title: %{
        properties: %{
          title: %{
            "type":     "string",
            "analyzer": "autocomplete"
          }
        }
      }
    }
  end
end

# elastix index.ex gets:
  # custom method
  #  @doc false
  #  def settings(elastic_url, name, data) do
    #  elastic_url <> make_path(name)
    # |> HTTP.put(Poison.encode!(data))
    #    |> process_response
    #  end

