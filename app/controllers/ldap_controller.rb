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
    id = params[:id]
    password = params[:password]
    puts("cn=" + id + ",ou=biciun,dc=arqsoft,dc=unal,dc=edu,dc=co")

    if not connect()
      puts("No se pudo conectar a LDAP.")
      @newAuth = ObjAuth.new(id, password, "false")
      render json: @newAuth
      return
    end

    ldap = Net::LDAP.new(
      host: "biciun-ldap",
      port: 389,
      auth: {
        method: :simple,
        dn: "cn=" + id + ",ou=biciun,dc=arqsoft,dc=unal,dc=edu,dc=co",
        password: password,
      },
    )

    if not ldap.bind
      puts("Usuario no esta registrado en ldap.")
      @newAuth = ObjAuth.new(id, password, "false")
      render json: @newAuth
      return
    end

    user = User.find_by(:id => id)

    if user.present?
      @newAuth = ObjAuth.new(id, password, "true")
      puts("Autenticación satisfactoria.")
      render json: @newAuth
      return
    else
      puts("Autenticación no satisfactoria, el usuario no se encuentra registrado en la base de datos.")
      @newAuth = ObjAuth.new(id, password, "false")
      render json: @newAuth
      return
    end
  end
end

class ObjAuth
  def initialize(id, password, answer)
    @id = id
    @password = password
    @answer = answer
  end
end
