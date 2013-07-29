module Prov
  class Activity
    include Prov::Element

    def generated(entity=nil)
      if entity
        e = Prov.entities[entity.to_sym]
        raise "UnkownEntity #{entity}" unless e

        e.generated_by self

        (@generated ||= []) << e
      else
        @generated
      end
    end

    def associated_with(agent=nil, &block)
      if agent
        ag = Prov.agents[agent.to_sym]
        raise "UnkownAgent #{ag}" unless ag
        assoc = Association.new
        assoc.agent(ag)
        (@associated ||= []) << assoc
        Prov.register(nil,assoc)
      elsif block_given?
        assoc = Association.new
        assoc.instance_eval(&block)
        (@associated ||= []) << assoc
        Prov.register(nil,assoc)
      else
        @associated
      end
    end

    def used(entity=nil)
      if entity
        e = Prov.entities[entity.to_sym]
        raise "UnkownEntity #{entity}" unless e
        (@used ||= []) << e
      else
        @used
      end
    end

    def had_plan(*args, &block)
      if block_given?
        p = Prov::Plan.new
        p.instance_eval(&block)
        p.__label=args[0]
        Prov.register(args[0], e)
      else
        name = args.shift
        args = Hash[*args]
        p = Prov::Plan.new

        p.subject args[:subject]
        (args.keys - [:subject]).map{|k|
          raise "Unkown plan setting #{k}" unless try_auto_set(p,k,args[k])
        }

        p.__label=name

        Prov.register(name, p)
      end
    end
    alias_method :plan, :had_plan

    def to_n3
      str = "<#{subject}> a prov:Activity ;\n"

      if generated
        str << "\tprov:generated "
        generated.map{|src|
          str << "<#{src}>, "
        }
        str[-2]=" "
        str[-1]=";\n"
      end

      if used
        str << "\tprov:used "
        used.map{|used|
          str << "<#{used}>, "
        }
        str[-2]=";"
        str[-1]="\n"
      end

      if associated_with
        str << "\tprov:wasAssociatedWith "
        associated_with.map{|assoc|
          str << "<#{assoc.agent}>, "
        }
        str[-2]=" "
        str[-1]=";\n"

        associated_with.map{|assoc|
          str << "\tprov:qualifiedAssociation <#{assoc}> ;\n"
        }
      end

      str << "\trdfs:label \"#{__label}\" .\n\n"
    end
  end
end