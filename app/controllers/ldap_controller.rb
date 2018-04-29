require "net/ldap"

class LdapController < ApplicationController
  def connect
    ldap = Net::LDAP.new(
      host: "biciun-ldap",
      port: 389,
      auth: {
        method: :simple,
        dn: "cn=admin,dc=arqsoft,dc=unal,dc=edu,dc=co",
        password: "admin",
      },
    )
    return ldap.bind
  end

  def create
    email = params[:email]
    password = params[:password]
    email = email[/\A\w+/].downcase
    if connect()
      puts("cn=" + email + ",ou=biciun,dc=arqsoft,dc=unal,dc=edu,dc=co")
      ldap = Net::LDAP.new(
        host: "biciun-ldap",
        port: 389,
        auth: {
          method: :simple,
          dn: "cn=" + email + ",ou=biciun,dc=arqsoft,dc=unal,dc=edu,dc=co",
          password: password,
        },
      )

      if ldap.bind
        user = User.find_by(:id => email)
        if user.present?
          @newAuth = ObjAuth.new(email, password, "true")
          puts("Autenticación satisfactoria.")
          render json: @newAuth
        else
          puts("Autenticación no satisfactoria, el usuario no se encuentra registrado en la base de datos.")
          @newAuth = ObjAuth.new(email, password, "false")
          render json: @newAuth
        end
      else
        puts("No se pudo conectar a LDAP.")
        @newAuth = ObjAuth.new(email, password, "false")
        render json: @newAuth
      end
    end
  end
end

class ObjAuth
  def initialize(email, password, answer)
    @email = email
    @password = password
    @answer = answer
  end
end
