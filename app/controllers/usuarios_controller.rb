class UsuariosController < ApplicationController
  def index
    @users = ActiveRecord::Base.connection.execute("SELECT nome, rg, cpf, categoria FROM usuario;")
  end

  def create
    ActiveRecord::Base.connection.execute("INSERT INTO usuario VALUES(#{params[:cpf]}, '#{params[:rg]}', '#{params[:nome]}', '#{params[:categoria]}');")

    case params[:categoria]
    when "admin"
      ActiveRecord::Base.connection.execute("INSERT INTO admin VALUES(#{params[:cpf]});")  
    when "juiz"
      ActiveRecord::Base.connection.execute("INSERT INTO juiz VALUES(#{params[:cpf]},'000000');")  
    when  "empresa"
      ActiveRecord::Base.connection.execute("INSERT INTO empresa VALUES(#{params[:cpf]}, 0);")  
    end
    redirect_to "/usuarios/#{params[:cpf]}/"+'edit'
  end

  def new
  end

  def edit
    @user = ActiveRecord::Base.connection.execute("SELECT cpf, nome, rg FROM usuario WHERE cpf=#{params[:id]} LIMIT 1;").to_a[0]
  end

  def update
    @user = ActiveRecord::Base.connection.execute("UPDATE usuario SET cpf=#{params[:cpf]}, nome='#{params[:nome]}', rg='#{params[:rg]}' where cpf=#{params[:id]};")
    redirect_to "/usuarios/#{params[:cpf]}/"+'edit'
  end

  def destroy
    @user = ActiveRecord::Base.connection.execute("DELETE FROM usuario WHERE cpf=#{params[:id]};")
    redirect_to root_path
  end
end
