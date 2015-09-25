# Generic Normalizer

module Hampusn
  module MessageCache
    module API
      module Normalizers
        class GenericNormalizer
          
          def self.normalize(p)
            # Generic normalizer doesn't do anything,
            # we just hope for the best.
            
            # But if we did know about the structure of post data we should place 
            # the main message text under the key 'message'. 
            # The rest of the data should be placed in a hash/array under the key 'meta'.
            # 
            # Example:
            # 
            # p[:message] = p[:somewhere_else]
            # p[:meta] = {
            #   meta_1: p[:some_meta],
            #   foo:    p[:bar]
            # }
            p
          end

        end
      end
    end
  end
end
