#!/usr/bin/env ruby
=begin
                  Arachni
  Copyright (c) 2010 Tasos "Zapotek" Laskos <tasos.laskos@gmail.com>

  This is free software; you can copy and distribute and modify
  this program under the term of the GPL v2.0 License
  (See LICENSE file for details)

=end

require 'getoptlong'
require 'pp'
require 'ap'

$:.unshift( File.expand_path( File.dirname( __FILE__ ) ) )

require 'lib/options'
options = Arachni::Options.instance

options.dir            = Hash.new
options.dir['root']     = File.dirname( File.expand_path(__FILE__) ) + '/'
options.dir['modules'] = options.dir['root'] + 'modules/'
options.dir['reports'] = options.dir['root'] + 'reports/'
options.dir['plugins'] = options.dir['root'] + 'plugins/'
options.dir['lib']     = options.dir['root'] + 'lib/'

# Construct getops struct
opts = GetoptLong.new(
    [ '--help',             '-h', GetoptLong::NO_ARGUMENT ],
    [ '--port',                   GetoptLong::OPTIONAL_ARGUMENT ],
    [ '--debug',                  GetoptLong::NO_ARGUMENT ],
    [ '--reroute-to-logfile',     GetoptLong::NO_ARGUMENT ],
    [ '--ssl',                    GetoptLong::NO_ARGUMENT ],
    [ '--ssl-pkey',               GetoptLong::REQUIRED_ARGUMENT ],
    [ '--ssl-cert',               GetoptLong::REQUIRED_ARGUMENT ],
    [ '--ssl-bundle',             GetoptLong::REQUIRED_ARGUMENT ],
)

begin
    opts.each {
        |opt, arg|

        case opt

            when '--help'
                options.help = true

            when '--debug'
                options.debug = true

            when '--reroute-to-logfile'
                options.reroute_to_logfile = true

            when '--port'
                options.rpc_port = arg.to_i

            when '--ssl'
                options.ssl = true

            when '--ssl-pkey'
                options.ssl_pkey = arg.to_s

            when '--ssl-cert'
                options.ssl_cert = arg.to_s

            when '--ssl-bundle'
                options.ssl_bundle = arg.to_s

        end
    }
end

require options.dir['lib'] + 'rpc/xml/dispatcher/server'

dispatcher = Arachni::RPC::XML::Dispatcher::Server.new( Arachni::Options.instance )
dispatcher.run
