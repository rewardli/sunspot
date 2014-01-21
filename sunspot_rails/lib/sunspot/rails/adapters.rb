module Sunspot #:nodoc:
  module Rails #:nodoc:
    #
    # This module provides Sunspot Adapter implementations for ActiveRecord
    # models.
    #
    module Adapters
      class ActiveRecordInstanceAdapter < Sunspot::Adapters::InstanceAdapter
        #
        # Return the primary key for the adapted instance
        #
        # ==== Returns
        #
        # Integer:: Database ID of model
        #
        def id
          @instance.id
        end
      end

      class ActiveRecordDataAccessor < Sunspot::Adapters::DataAccessor
        # options for the find
        attr_accessor :include, :select

        #
        # Set the fields to select from the database. This will be passed
        # to ActiveRecord.
        #
        # ==== Parameters
        #
        # value<Mixed>:: String of comma-separated columns or array of columns
        #
        def select=(value)
          value = value.join(', ') if value.respond_to?(:join)
          @select = value
        end

        #
        # Get one ActiveRecord instance out of the database by ID
        #
        # ==== Parameters
        #
        # id<String>:: Database ID of model to retreive
        #
        # ==== Returns
        #
        # ActiveRecord::Base:: ActiveRecord model
        #
        def load(id)
          base_relation.where(@clazz.primary_key => id).first
        end

        #
        # Get a collection of ActiveRecord instances out of the database by ID
        #
        # ==== Parameters
        #
        # ids<Array>:: Database IDs of models to retrieve
        #
        # ==== Returns
        #
        # Array:: Collection of ActiveRecord models
        #
        def load_all(ids)
          base_relation.where(@clazz.primary_key => ids.map { |id| id }).to_a
        end

        private

        def base_relation
          relation = @clazz
          relation = relation.includes(@include) unless @include.blank?
          relation = relation.select(@select)    unless  @select.blank?
          relation
        end
      end
    end
  end
end
