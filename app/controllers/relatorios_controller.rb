class RelatoriosController < ApplicationController
  def eventos
    @eventos = ActiveRecord::Base.connection.execute("SELECT nome, data_ini, data_fim, local, descricao FROM evento;")
  end

  def grupos
    @grupos = ActiveRecord::Base.connection.execute("SELECT G.nome, count(DISTINCT M.usuario, M.grupo, M.datetime) AS mensagens,
                                                                     count(DISTINCT T.id) AS topicos FROM grupo G
                                                                     LEFT JOIN msg_grupo M ON M.grupo = G.id
                                                                     LEFT JOIN topico_grupo T ON T.grupo = G.id
                                                                     GROUP BY G.id").to_a
  end

  def listas
    if params[:modalidade] == nil || !defined?(params[:modalidade])
      params[:modalidade] = 'Xadrez'
    end
    if params[:evento] == nil || !defined?(params[:evento])
      params[:evento] = 'Tusca 2014'
    end

    @modalidade = params[:modalidade]
    @evento = params[:evento]

    @users = ActiveRecord::Base.connection.execute("SELECT US.nome, US.rg, US.cpf, AL.ra, AL.faculdade FROM usuario US
       INNER JOIN aluno AL ON US.cpf=AL.cpf
       INNER JOIN atleta AT ON AL.cpf = AT.cpf
       INNER JOIN participa_modalidade PM ON PM.atleta = AT.cpf
       INNER JOIN modalidade MO ON MO.nome = PM.modalidade
       INNER JOIN credencia CR ON CR.atleta = PM.atleta
       INNER JOIN participacao PA ON PA.id = CR.participacao
       INNER JOIN evento EV ON EV.id = PA.evento
       WHERE upper(MO.nome)='#{params[:modalidade]}' AND upper(EV.nome)='#{params[:evento]}';")
  end
end
