if defined?(WillPaginate)
  module WillPaginate
    module ActiveRecord
      module RelationMethods
<<<<<<< HEAD
        alias_method :per, :per_page
        alias_method :num_pages, :total_pages
        alias_method :total_count, :total_entries
      end
    end
=======
        def per(value = nil) per_page(value) end
        def total_count() count end
      end
    end
    module CollectionMethods
      alias_method :num_pages, :total_pages
    end
>>>>>>> 82d07ccd3c7cf7cbcf49bf1bd0e4231380f20ac7
  end
end