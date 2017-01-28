defmodule CodeCorps.ElasticSearchHelper do
  alias Elastix.Search
  alias Elastix.Index
  alias Elastix.Document

  def delete(url, index) do
    Index.delete(url, index)
  end

  def create_index(url, index, type) do
    Index.settings(url, index, settings_map)
    Index.settings(url, "#{index}/_mapping/#{type}", field_filter)
  end

  def add_documents(url, index, type, documents) when is_list(documents) do
    add_documents(url, index, type, documents, [])
  end

  def add_documents(url, index, type, documents, query) when is_list(documents) do
    Enum.each(documents, fn(x) -> add_document(url, index, type, to_map(type, x), query) end)
  end

  def add_document(url, index, type, data) do
    add_document(url, index, type, data, [])
  end

  def add_document(url, index, type, data, query) do
    Document.index_new(url, index, type, data, query)
  end

  def search(url, index, type, search_query) do
    data = %{
      query: %{
        match: to_map(type, search_query)
      }
    }

    response = Search.search url, index, [], data

    #response.status_code == 200 do
    #count = response.body["hits"]["total"]

    hits = response.body["hits"]["hits"] || []
    Enum.map(hits, fn(x) -> x["_source"]["title"] end)
  end

  def to_map(foo, bar), do: %{ String.to_atom(foo) => bar}

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
