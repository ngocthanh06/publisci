module PubliSci
  class Dataset
    module DSL

      class Instance
        include Dataset::DSL

        def initialize
          Dataset.registry.clear
        end
      end

      # def interactive(value=nil)
      #   set_or_get('interactive',value)
      # end

      def object(file=nil)
        set_or_get('object',file)
      end

      def dimension(*args)
        if args.size == 0
          add_or_get('dimension',nil)
        else
          args.each{|arg|
            add_or_get('dimension',arg)
          }
        end
      end

      def measure(*args)
        if args.size == 0
          add_or_get('measure',nil)
        else
          args.each{|arg|
            add_or_get('measure',arg)
          }
        end
      end

      def settings
        Dataset.configuration
      end

      def generate_n3
        opts = {}
        %w{dimension measure}.each{|field|
          opts[field.to_sym] = send(field.to_sym) if send(field.to_sym)
        }
        interact = settings.interactive
        # publishers.each{|pub|
        #   opts[:publishers] ||= [] << {label: pub.label, uri: pub.uri}
        # } if publishers
        # gen = Class.new {include PubliSci::Metadata::Generator}

        Dataset.for(object,opts,interact)
      end

      private
      def set_or_get(var,input=nil)
        ivar = instance_variable_get("@#{var}")

        if input
          instance_variable_set("@#{var}", input)
        else
          ivar
        end
      end

      def add_or_get(var,input)
        ivar = instance_variable_get("@#{var}")

        if input
          instance_variable_set("@#{var}", []) unless ivar
          instance_variable_get("@#{var}") << input
          instance_variable_get("@#{var}")
        else
          ivar
        end
      end
    end
  end
end