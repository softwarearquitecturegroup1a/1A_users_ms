class WsusersController < ApplicationController

    soap_service namespace: 'urn:WashOutUser', camelize_wsdl: :lower

    soap_action "showUser",
                    :args => {:iduser => :integer},
                    :return => :string
                
    def showUser
        
        if !(User.exists?(id: params[:iduser]))
            render :soap => "El usuario no existe"
        else 
            @user = User.find(params[:iduser])
            render :soap => ("Nombre: "+@user.name+" "+@user.lastname+", "+@user.id_type+" No. "+@user.id_code.to_s+", email: "+@user.email)
        end
    end

    # soap_action "transferBikes",
    #             :args => { :source => :string, :target => :string},
    #             :return => :boolean
    
    # def transferBikes
    #     require 'net/http'

    #     uri = URI('35.193.172.140:3004/bicicletas')
    #     http = Net::HTTP.new(uri.host, uri.port)
    #     req = Net::HTTP.Get(uri.path)
    #     req["Content-Type"] = "application/json"
    #     resp = http.request(req)

    #     bikes = resp.body

    #     puts bikes

    #     render :soap => true

    # end

end