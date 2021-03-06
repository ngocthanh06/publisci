module PubliSci
  class Prov
    class Derivation

      include PubliSci::CustomPredicate

    def __label
      # raise "MissingInternalLabel: no __label for #{self.inspect}" unless @__label
      @__label ||= Time.now.nsec.to_s(32)
    end

      def subject(sub=nil)
        if sub
          @subject = sub
        else
          @subject ||= "#{Prov.base_url}/derivation/#{Time.now.nsec.to_s(32)}"
        end
      end

      def had_activity(activity=nil)
        if activity
          @had_activity = activity
        elsif @had_activity.is_a? Symbol
          raise "UnknownActivity #{@had_activity}" unless Prov.activities[@had_activity]
          @had_activity = Prov.activities[@had_activity]
        else
          @had_activity
        end
      end
      alias_method :activity, :had_activity

      def entity(entity=nil)
        if entity
          @entity = entity
        elsif @entity.is_a? Symbol
          raise "UnknownEntity #{@entity}" unless Prov.entities[@entity]
          @entity = Prov.entities[@entity]
        else
          @entity
        end
      end
      alias_method :data, :entity

      def to_n3
        str = "<#{subject}> a prov:Derivation ;\n"
        str << "\tprov:entity <#{entity}> ;\n" if entity
        str << "\tprov:hadActivity <#{had_activity}> ;\n" if had_activity
        str << "\trdfs:label \"#{__label}\".\n\n"

        add_custom(str)

        str
      end

      def to_s
        subject
      end
    end
  end
end