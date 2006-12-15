module PuppetTest::RailsTesting
    Parser = Puppet::Parser
    AST = Puppet::Parser::AST
    include PuppetTest::ParserTesting

    def railsinit
        Puppet::Rails.init
    end

    def railsteardown
        if Puppet[:dbadapter] != "sqlite3"
            Puppet::Rails.teardown
        end
    end

    def railsresource(type = "file", title = "/tmp/testing", params = {})
        railsteardown
        railsinit
        
        # We need a host for resources
        #host = Puppet::Rails::Host.new(:name => Facter.value("hostname"))

        # Now build a resource
        resources = []
        resources << mkresource(:restype => type, :title => title, :exported => true,
                   :params => params)

        # Now collect our facts
        facts = Facter.to_hash

        # Now try storing our crap
        host = nil 
        assert_nothing_raised {
            host = Puppet::Rails::Host.store(
                :resources => resources,
                :facts => facts,
                :name => facts["hostname"]
            )
        }        

        # Now save the whole thing
        host.save
    end
end

# $Id$
