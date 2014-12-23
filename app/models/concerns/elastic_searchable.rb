require 'active_support/concern'

module ElasticSearchable
  extend ActiveSupport::Concern

  # Search model instance code:
  included do

    # require and include Elasticsearch libraries
    require 'elasticsearch/model'
    include Elasticsearch::Model
    #include Elasticsearch::Model::Callbacks
    include Elasticsearch::Model::Indexing

   # Customize the index name
    #
    #index_name [Rails.application.engine_name, Rails.env].join('_')

    # Set up index configuration and mapping
    #
    settings(index: { number_of_shards: 1, number_of_replicas: 0 }, analysis: { analyzer: { whole_email: { tokenizer: 'uax_url_email' } } }) do
      mapping dynamic: 'false' do
        indexes :name, analyzer: 'snowball'
        indexes :telephone, analyzer: 'keyword'
        indexes :email, analyzer: 'whole_email'
        indexes :country, analyzer: 'snowball'

        indexes :competencies, type: 'nested' do
          indexes :description, analyzer: 'snowball'
          indexes :name, analyzer: 'keyword'
          indexes :skill_level, analyzer: 'keyword'
          indexes :skill_proficiency, analyzer: 'keyword'
          
        end
      end
    end
    
    # index document on model touch
    # @see: http://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html
    after_touch() { __elasticsearch__.index_document }

    # Customize the JSON serialization for Elasticsearch
    def as_indexed_json(options={})

      # define JSON structure (including nested model associations)
      _include = self.class.reflect_on_all_associations.each_with_object({}) {|a,hsh|
        hsh[a.name] = {}
        hsh[a.name][:only] = a.klass.attribute_names
      }

      self.as_json(include: _include)
    end

  end

  # Search model class methods
  module ClassMethods

    # todo/note: params processing is a controller function.
    def search_params(params={})
      return [nil,nil, nil] if params.blank? || params[:search].blank?
      p = params[:search].dup
      q = p.delete(:q)
      n = p.delete(:not)
      [q, p, n]
    end

    # define search method to be used in Rails controller
    def search(query=nil, options={}, not_filters={})

      options ||= {}
      not_filters ||= {}
      
      # setup empty search definition
      @search_definition = {
        query: {},
        filter: {},
        facets: {},
      }

      # Prefill and set the filters (top-level `filter` and `facet_filter` elements)
      __set_filters = lambda do |key, f|

        @search_definition[:filter][:and] ||= []
        @search_definition[:filter][:and]  |= [f]

        @search_definition[:facets].each_pair do |k, v|
          #TODO parent filters don't get applied to child facets
          if v[:nested].nil?
            v[:facet_filter][:and] ||= []
            v[:facet_filter][:and] |= [f]            
          end
        end
        #@search_definition[:facets][key.to_sym][:facet_filter][:and] ||= []
        #@search_definition[:facets][key.to_sym][:facet_filter][:and]  |= [f]
      end
     
      __set_nested_filters = lambda do |key, f|

        @search_definition[:filter][:and] ||= []
        @search_definition[:filter][:and]  |= [f]

        @search_definition[:facets].each_pair do |k, v|
          v[:facet_filter][:and] ||= []
          v[:facet_filter][:and] |= [f[:nested][:filter]]
        end
#        @search_definition[:facets][key.to_sym][:facet_filter][:and] ||= []
#        @search_definition[:facets][key.to_sym][:facet_filter][:and]  |= [f[:nested][:filter]]
      end

      __set_not_filters = lambda do |key, f|

        @search_definition[:filter][:and] ||= []
        @search_definition[:filter][:and]  |= [not: f]
        
        @search_definition[:facets].each_pair do |k, v|
          v[:facet_filter][:and] ||= []
          v[:facet_filter][:and] |= [not: f]
        end
        
      end

      __set_nested_not_filters = lambda do |key, f|

        @search_definition[:filter][:and] ||= []
        @search_definition[:filter][:and] |= [not: f]

        @search_definition[:facets].each_pair do |k, v|
          v[:facet_filter][:and] ||= []
          v[:facet_filter][:and] |= [not: f[:nested][:filter]]
        end
       
#        @search_definition[:facets][key.to_sym][:facet_filter][:and] ||= []
#        @search_definition[:facets][key.to_sym][:facet_filter][:and]  |= [f[:nested][:filter]]
      end
      
      # facets
      @search_definition[:facets] = search_facet_fields.each_with_object({}) do |a,hsh|
        hsh[a.to_sym] = {
          terms: {
            field: a
          },
          facet_filter: {}
        }
      end

      nested_facet_fields.each_with_object(@search_definition[:facets]) do |a,hsh|
        hsh[a.first.to_sym] = {
          nested: a.last,
          terms: {
            field: a.first
          },
          facet_filter: {}
        }
      end
      
      # query
      unless query.blank?
        @search_definition[:query] = {
          bool: {
            should: [
              { multi_match: {
                  query: query,
                  # limit which fields to search, or boost here:
                  fields: search_text_fields,
                  operator: 'and'
                }
              }
            ]
          }
        }
      else
        @search_definition[:query] = { match_all: {} }
      end

      # add filters for facets
      options.each do |key,value|
        next unless search_facet_fields.include?(key)

        f = { terms: { key.to_sym => value } }

        __set_filters.(key, f)

      end      
      # add filters for facets
      options.each do |key,value|
        next unless nested_facet_fields.include?(key)

        f = { nested: {path: nested_facet_fields[key], filter: {terms: { key.to_sym => value } }}}

        __set_nested_filters.(key, f)
      end        
      
      # add not filters for facets
      not_filters.each do |key,value|
        next unless search_facet_fields.include?(key)

        f = { terms: { key.to_sym => value } }

        __set_not_filters.(key, f)

      end
      # add filters for facets
      not_filters.each do |key,value|
        next unless nested_facet_fields.include?(key)

        f = { nested: {path: nested_facet_fields[key], filter: {terms: { key.to_sym => value } }}}

        __set_nested_not_filters.(key, f)
      end        

      # execute Elasticsearch search
      __elasticsearch__.search(@search_definition)

    end

    private

    # return array of model attributes to search on
    def search_text_fields
      @search_text_fields ||= self.content_columns.select {|c| [:string,:text].include?(c.type) }.map {|c| c.name }
    end

    # return array of model attributes to facet
    def search_facet_fields
      @search_facet_fields ||= self.content_columns.select {|c| [:boolean,:decimal,:float,:integer,:string,:text].include?(c.type) }.map {|c| c.name } 
    end

    def nested_facet_fields
      @nested_facet_fields ||= self.reflect_on_all_associations.each_with_object({}) do |nested_association, nested_facets|       
        nested_columns = nested_association.klass.content_columns.select {|c| [:boolean,:decimal,:float,:integer,:string,:text].include?(c.type) }
        nested_columns.each do |nc| 
          nested_facets["#{nested_association.name}.#{nc.name}"] = nested_association.name
        end
      end
    end
  end

end