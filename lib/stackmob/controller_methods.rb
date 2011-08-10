module StackMob
  module ControllerMethods
    def sm_datastore
      @sm_datastore ||= begin
                          client = StackMob::Client.new(sm_api_host, sm_app_name, 0, sm_key, sm_secret)
                          StackMob::DataStore.new(client)
                        end
    end
    
    def sm_push
      @sm_push ||= begin
                     client = StackMob::Client.new(sm_push_host, sm_app_name, 0, sm_key, sm_secret)
                     StackMob::Push.new(client)
                   end
    end
    
    def sm_api_host
      sm_normalize_host(request.env['HTTP_X_STACKMOB_API'])
    end

    def sm_push_host
      sm_normalize_host(request.env['HTTP_X_STACKMOB_PUSH'])
    end
    
    def sm_app_name
      StackMob.config['app_name']
    end
    private :sm_app_name
    
    def sm_app_version
      0
    end
    private :sm_app_version
    
    def sm_key
      @sm_key ||= OAuth::Signature.build(request).request.consumer_key    
    end
    private :sm_key
    
    def sm_secret
      StackMob.config['secret']
    end
    private :sm_secret

    def sm_normalize_host(host_str)
      normalized = host_str =~ /^http:\/\// ? "" : "http://"
      normalized += host_str
    end
    private :sm_normalize_host

  end
end
