require 'rubygems'
require 'json'
require 'aws-sdk'
require 'logger'
require 'pp'

module Bind2Route53
  class CreateHostedZoneStack
    def initialize(args)
      options = MyOptionParser.new(args)
      options.add_option_c
      options.add_option_t
      options.parse

      config_path   = options.val(:config_path)
      template_path = options.val(:template_path)

      $config = load_config(config_path)

      #AWS.config(:logger => Logger.new($stdout))
      cfm = AWS::CloudFormation.new(
        :access_key_id     => $config[:access_key_id],
        :secret_access_key => $config[:secret_key],
        :region            => $config[:region]
      )

      stackname, template = load_template(cfm, template_path)

      confirm("Do you create hosted zone stack?") if $config[:confirm] 
      cfm.stacks.create(stackname, template)

      puts "[Info][#{$config[:env]}] Create hosted zone stack start. (#{Time.now.strftime("%Y-%m-%d %H:%M:%S")})"
      unless wait_update_stacke(cfm, stackname, 10)
        puts "[Error][#{$config[:env]}] Create hosted zone stack failed. (#{Time.now.strftime("%Y-%m-%d %H:%M:%S")})"
        exit 1
      end
      puts "[Info[#{$config[:env]}]] Create hosted zone stack finish. (#{Time.now.strftime("%Y-%m-%d %H:%M:%S")})"
    end
  end
end
