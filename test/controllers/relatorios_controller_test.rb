require 'test_helper'

class RelatoriosControllerTest < ActionController::TestCase
  test "should get eventos" do
    get :eventos
    assert_response :success
  end

  test "should get topicos" do
    get :topicos
    assert_response :success
  end

  test "should get mensagens" do
    get :mensagens
    assert_response :success
  end

  test "should get listas" do
    get :listas
    assert_response :success
  end

end
