module Prov
  class Association
    def subject(sub=nil)
      if sub
        @subject = sub
      else
        @subject ||= "#{Prov.base_url}/assoc/#{Time.now.nsec.to_s(32)}"
      end
    end

    def agent(agent=nil)
      if agent
        agent = Prov.agents[agent.to_sym] if agent.is_a?(String) || agent.is_a?(Symbol)
        raise "UnkownAgent #{ag}" unless agent
        # puts "Warning: overwriting agent #{@agent.subject}" if @agent
        @agent = agent
      else
        @agent
      end
    end

    def to_n3
      str = "<#{subject}> a prov:Association ;\n"
      str << "\tprov:agent <#{agent.to_s}> .\n\n"
    end

    def to_s
      subject
    end
  end
end