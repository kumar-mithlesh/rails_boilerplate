# frozen_string_literal: true

module Api
  module CollectionOptionsHelper
    def collection_links(collection)
      {
        self: request.original_url,
        next: pagination_url(collection.next || collection.pages),
        prev: pagination_url(collection.prev || 1),
        last: pagination_url(collection.pages),
        first: pagination_url(1)
      }
    end

    def collection_meta(collection)
      {
        count: collection.in,
        total_count: collection.count,
        total_pages: collection.pages
      }
    end

    # leaving this method in public scope so it's still possible to modify
    # those params to support non-standard non-JSON API parameters
    def collection_permitted_params
      params.permit(:format, :page, :per_page, :sort, :include, fields: {}, filter: {})
    end

    private

    def pagination_url(page)
      url_for(collection_permitted_params.merge(page:))
    end

    def collection_options(collection)
      {
        links: collection_links(collection),
        meta: collection_meta(collection),
        include: resource_includes,
        fields: sparse_fields
      }
    end
  end
end
